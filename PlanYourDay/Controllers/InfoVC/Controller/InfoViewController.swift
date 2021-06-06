//
//  InfoViewController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//
import RealmSwift
import UIKit

class InfoViewController: UIViewController, UINavigationControllerDelegate {
  
  public var note: Note?
  public var deletionHandler: (() -> Void)?
  public var completionHandler: (() -> Void)?
  private var realm = RealmService.shared.realm
  
  @IBOutlet weak var noteTitleTextField: UITextField!
  @IBOutlet weak var noteStartDateLabel: UILabel!
  @IBOutlet weak var noteEndDateLabel: UILabel!
  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBOutlet weak var endDatePicker: UIDatePicker!
  @IBOutlet weak var noteDescription: UITextView!
  @IBOutlet weak var noteImage: UIImageView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var photoCameraButton: UIButton!
  @IBOutlet weak var newNoteButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.Prefixes.infoVCTitelPrefix + (note?.name ?? "")
    setUpTrashButton()
    setUpTextFieldAndTextView()
    setUpDataForInfoVC()
    setUpBorderForUI()
  }
  
  private func setUpBorderForUI() {
    startDatePicker.setUpWhiteBorder()
    endDatePicker.setUpWhiteBorder()
    noteStartDateLabel.setUpWhiteBorder()
    noteEndDateLabel.setUpWhiteBorder()
  }
  
  private func setUpDataForInfoVC() {
    noteTitleTextField.text = note?.name
    noteDescription.text = note?.descriptionText
    noteStartDateLabel.text = Constants.Prefixes.startDatePrefix +
      (DateFormatters.convertToStringFromTimestampWithTime(datestamp: note?.dateStartTimestamp ?? Constants.DefaultValues.defaultDate))
    noteEndDateLabel.text = Constants.Prefixes.endDatePrefix +
      (DateFormatters.convertToStringFromTimestampWithTime(datestamp: note?.dateFinishTimestamp ?? Constants.DefaultValues.defaultDate))
    noteImage.image = note?.noteImage
  }
  
  private func setUpTextFieldAndTextView() {
    noteDescription.delegate = self
    noteDescription.becomeFirstResponder()
    noteTitleTextField.delegate = self
  }
  
  private func setUpTrashButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .trash,
      target: self,
      action: #selector(onTrashButtonTapped))
  }
  
  @IBAction func onNewNoteButtonDidTap(_ sender: UIButton) {
    newNoteButton.pulsate()
    guard let vc = UIStoryboard.init(name: Constants.StoryboardTitle.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.VCIdentifiers.entyVCId) as? EntryViewController else { return }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func onCameraButtonDidTap(_ sender: UIButton) {
    photoCameraButton.pulsate()
    pickImage()
  }
  
  @IBAction func onSaveButtonDidTap(_ sender: UIButton) {
    if let noteTitle = noteTitleTextField.text, !noteTitle.isEmpty {
      saveButton.pulsate()
      guard let description = noteDescription.text,
            !description.isEmpty else { return AlertController.showIncompleteFormAlert(on: self) }
      let startDate = startDatePicker.date
      let endDate = endDatePicker.date
      
      if let updateNote = note {
        do {
          try realm.write {
            updateNote.name = noteTitle
            updateNote.descriptionText = description
            updateNote.dateStart = DateFormatters.convertToTimestamp(date: startDate)
            updateNote.dateFinish = DateFormatters.convertToTimestamp(date: endDate)
            self.completionHandler?()
            self.navigationController?.popToRootViewController(animated: true)
          }
        } catch {
          print(error)
        }
      }
    } else {
      AlertController.showIncompleteFormAlert(on: self)
    }
  }
  
  @objc private func onTrashButtonTapped() {
    let alertMessage = UIAlertController(
      title: Constants.AlertController.deletionAlertTitle,
      message: Constants.AlertController.deletionAlertMessage,
      preferredStyle: .alert
    )
    let yesAction = UIAlertAction(title: Constants.AlertController.yesTitle, style: .destructive, handler: { (_) -> Void in
      self.deleteTheNote()
    })
    let cancelAction = UIAlertAction(title: Constants.AlertController.cancelTitle, style: .cancel) { (_) -> Void in }
    alertMessage.addAction(yesAction)
    alertMessage.addAction(cancelAction)
    self.present(alertMessage, animated: true, completion: nil)
  }
  
  private func deleteTheNote() {
    guard let item = note else { return }
    RealmService.shared.delete(item)
    deletionHandler?()
    print("Object has been deleted!")
    self.navigationController?.popToRootViewController(animated: true)
  }
  
}

// MARK: - TextFieldDelegate

extension InfoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - TextViewDelegate

extension InfoViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if !textView.text.isEmpty {
      textView.text = note?.descriptionText
      if #available(iOS 13.0, *) {
        textView.textColor = .label
      } else {
        textView.textColor = .black
      }
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.setupPlaceholder(text: Constants.Placeholders.textViewPlaceHolder)
    }
  }
}

// MARK: - ImagePickerDelegate

extension InfoViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    self.dismiss(animated: true, completion: nil)
    DispatchQueue.main.async {
      if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
        self.noteImage.image = image
      }
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
