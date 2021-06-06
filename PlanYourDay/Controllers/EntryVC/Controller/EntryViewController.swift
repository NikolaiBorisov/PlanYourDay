//
//  EntryViewController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import RealmSwift
import UIKit

class EntryViewController: UIViewController, UINavigationControllerDelegate {
  
  @IBOutlet var noteTitleTextField: UITextField!
  @IBOutlet var startDatePicker: UIDatePicker!
  @IBOutlet weak var endDatePicker: UIDatePicker!
  @IBOutlet var noteDescriptionTextView: UITextView!
  @IBOutlet var noteImage: UIImageView!
  @IBOutlet weak var photoCameraButton: UIButton!
  
  private let realm = RealmService.shared.realm
  public var completionHandler: (() -> Void)?
  private var note = [Note]()
  weak var delegate: EntryViewControllerCreationHandler?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTextFieldAndTextView()
    setUpNavigationBar()
    setupDatePicker()
  }
  
  private func setupDatePicker() {
    startDatePicker.setDate(Date(), animated: true)
    endDatePicker.setDate(Date(), animated: true)
    startDatePicker.setUpWhiteBorder()
    endDatePicker.setUpWhiteBorder()
  }
  
  private func setUpNavigationBar() {
    title = Constants.VCTitle.entryVCTitle
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: Constants.Buttons.saveButton,
      style: .done,
      target: self,
      action: #selector(onSaveButtonTapped))
  }
  
  private func setUpTextFieldAndTextView() {
    noteTitleTextField.becomeFirstResponder()
    noteDescriptionTextView.becomeFirstResponder()
    noteTitleTextField.delegate = self
    noteDescriptionTextView.delegate = self
  }
  
  @IBAction func onPhotoButtonTapped(_ sender: UIButton) {
    photoCameraButton.pulsate()
    pickImage()
  }
  
  @objc func onSaveButtonTapped() {
    if let text = noteTitleTextField.text, !text.isEmpty {
      let startDate = startDatePicker.date
      let endDate = endDatePicker.date
      guard let description = noteDescriptionTextView.text,
            !description.isEmpty,
            description != Constants.Placeholders.textViewPlaceHolder else {
        return AlertController.showIncompleteFormAlert(on: self)
      }
      
      let newNote = Note()
      newNote.dateStart = DateFormatters.convertToTimestamp(date: startDate)
      newNote.dateFinish = DateFormatters.convertToTimestamp(date: endDate)
      newNote.name = text
      newNote.descriptionText = description
      newNote.id = Int.random(in: 3...10000)
      RealmService.shared.saveObjects([newNote])
      completionHandler?()
      self.navigationController?.popToRootViewController(animated: true)
    } else {
      AlertController.showIncompleteFormAlert(on: self)
    }
  }
  
}

// MARK: - TextFieldDelegate

extension EntryViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - TextViewDelegate

extension EntryViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == Constants.Placeholders.textViewPlaceHolder {
      textView.text = ""
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

extension EntryViewController: UIImagePickerControllerDelegate {
  
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

protocol EntryViewControllerCreationHandler: AnyObject {
  func didCreateNote()
}
