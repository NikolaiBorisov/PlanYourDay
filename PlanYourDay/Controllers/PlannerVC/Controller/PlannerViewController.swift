//
//  PlannerViewController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import FSCalendar
import RealmSwift
import UIKit

class PlannerViewController: UIViewController, UISearchControllerDelegate, FSCalendarDelegate {
  
  @IBOutlet weak var plannerTableView: UITableView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var calendarView: FSCalendar!
  
  private var notes = [Note]()
  private var realm = RealmService.shared.realm
  public var deletionHandler: (() -> Void)?
  public var completionHandler: (() -> Void)?
  private var selectedDate: Date?
  
  private var datesOfEvents: [String] {
    return notes.map { DateFormatters.stringFromDatestamp(datestamp: Int($0.dateStartTimestamp) ?? .zero) }
  }
  
  // MARK: - Setting up the search bar properties
  private let searchController = UISearchController(searchResultsController: nil)
  var filteredNotes: [Note] = []
  private var searchBarIsEmpty: Bool {
    guard let text = searchController.searchBar.text else { return false }
    return text.isEmpty
  }
  var isFiltering: Bool {
    return searchController.isActive && !searchBarIsEmpty
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    notes = realm.objects(Note.self).map({$0})
    setUpTableViewAndCalendarView()
    setupSearchController()
    setupActivityIndicator()
    getNotesFromJSON()
    renderRealmObjects()
    showThePathToRealmObjects()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    refresh()
    countNotes()
  }
  
  private func countDates(for dateOfEvent: String) -> Int {
    var count: [String: Int] = [:]
    for date in datesOfEvents {
      count[date] = (count[date] ?? 0) + 1
    }
    return count[dateOfEvent] ?? 0
  }
  
  private func showThePathToRealmObjects() {
    if let path = Realm.Configuration.defaultConfiguration.fileURL {
      print("Path to saved data: \(path)")
    }
  }
  
  private func renderRealmObjects() {
    let data = realm.objects(Note.self)
    for item in data {
      let id = item.id
      let title = item.name
      let object  = "\(id) \(title)"
      print("Realm objects rendering:\(object)")
    }
  }
  
  private func saveObjectsToRealm() {
    RealmService.shared.saveObjects(self.notes) {
      DispatchQueue.main.async { [weak self] in
        self?.plannerTableView.reloadData()
      }
    }
  }
  
  private func getNotesFromJSON() {
    
    let items = realm.objects(Note.self)
    
    if items.isEmpty {
      JSONParcer.parseFile(with: .plannerJSON, type: Note.self)?.forEach {
        print(
          "id: \($0.id)\n",
          "startDate: \($0.dateStart)\n",
          "endDate: \($0.dateFinish)\n",
          "title: \($0.name)\n",
          "description:\($0.descriptionText)\n")
        notes.append($0)
      }
      saveObjectsToRealm()
      plannerTableView.reloadData()
    } else {
      notes = realm.objects(Note.self).map({$0})
      plannerTableView.reloadData()
    }
  }
  
  private func countNotes() {
    if notes.count == 1 {
      countLabel.text = "\(notes.count)" + Constants.Counter.note
      countLabel.textColor = .black
    } else {
      countLabel.text = "\(notes.count)" + Constants.Counter.notes
      countLabel.textColor = .black
    }
  }
  
  private func setUpTableViewAndCalendarView() {
    plannerTableView.register(
      UINib(nibName: Constants.CellNibName.plannerCellNibName, bundle: nil),
      forCellReuseIdentifier: PlannerCell.identifier)
    plannerTableView.delegate = self
    plannerTableView.dataSource = self
    calendarView.delegate = self
    calendarView.dataSource = self
  }
  
  private func setupActivityIndicator() {
    activityIndicator.startAnimating()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
      self?.activityIndicator.stopAnimating()
      self?.activityIndicator.removeFromSuperview()
    }
  }
  
  private func setupSearchController() {
    searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchController.searchResultsUpdater = self
    searchController.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = Constants.Placeholders.searchControllerplaceholder
    UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
    navigationItem.searchController = searchController
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  @IBAction func onAddButtonTapped() {
    guard let vc = storyboard?.instantiateViewController(withIdentifier: Constants.VCIdentifiers.entyVCId) as? EntryViewController else { return }
    vc.completionHandler = { [weak self] in
      self?.refresh()
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  private func refresh() {
    notes = realm.objects(Note.self).map({$0})
    plannerTableView.reloadData()
    calendarView.reloadData()
  }
  
}

// MARK: - TableViewDataSource, TableViewDelegate

extension PlannerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.DefaultValues.rowHeight
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let date = selectedDate {
      let notes = self.notes.filter { $0.dateStart == DateFormatters.convertToStringFromDateType(format: date) }
      return notes.count
    }
    if isFiltering {
      return filteredNotes.count
    }
    return notes.count
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? PlannerCell else { return }
    if let date = selectedDate {
      let notes = self.notes.filter { $0.dateStart == DateFormatters.convertToStringFromDateType(format: date) }
      cell.configure(with: notes[indexPath.row])
    } else {
      var note: Note
      if isFiltering {
        note = filteredNotes[indexPath.row]
      } else {
        note = notes[indexPath.row]
      }
      cell.configure(with: note)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PlannerCell.identifier, for: indexPath) as? PlannerCell else { return UITableViewCell() }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let vc = storyboard?.instantiateViewController(withIdentifier: Constants.VCIdentifiers.infoVCId) as? InfoViewController else { return }
    vc.deletionHandler = { [weak self] in
      self?.refresh()
      self?.calendarView.reloadData()
    }
    vc.completionHandler = { [weak self] in
      self?.calendarView.reloadData()
      self?.refresh()
    }
    let note: Note
    if isFiltering {
      note = filteredNotes[indexPath.row]
    } else {
      note = notes[indexPath.row]
    }
    vc.note = note
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let note = notes[indexPath.row]
      notes.remove(at: indexPath.row)
      tableView.reloadData()
      self.countNotes()
      RealmService.shared.delete(note)
    }
  }
  
}
// MARK: - SearchController methods

extension PlannerViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text ?? "")
  }
  
  func filterContentForSearchText(_ searchText: String) {
    filteredNotes = notes.filter({ (note: Note) -> Bool in
      return note.name.lowercased().contains(searchText.lowercased())
    })
    plannerTableView.reloadData()
  }
}

extension PlannerViewController: FSCalendarDelegateAppearance, FSCalendarDataSource {
  
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
    let dateString = DateFormatters.dateFormatter.string(from: date)
    if datesOfEvents.contains(dateString) {
      return [UIColor.blue]
    }
    return [UIColor.white]
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    if date.addThreeHours() == selectedDate {
      selectedDate = nil
    } else {
      selectedDate = date.addThreeHours()
    }
    plannerTableView.reloadData()
  }
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    let dateString = DateFormatters.dateFormatter.string(from: date)
    let count = countDates(for: dateString)
    plannerTableView.reloadData()
    return count
  }
  
}
