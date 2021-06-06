//
//  AlertController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 08.05.2021.
//

import UIKit

struct AlertController {
  
  var model = InfoViewController()
  
  private static func showSaveButtonAlert(
    on vc: UIViewController,
    with title: String,
    message: String
  ) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    alertController.addAction(UIAlertAction(
      title: Constants.AlertController.saveDismissTitle,
      style: .default,
      handler: nil
    ))
    DispatchQueue.main.async {
      vc.present(alertController, animated: true)
    }
  }
  
  static func showIncompleteFormAlert(on vc: UIViewController) {
    showSaveButtonAlert(
      on: vc,
      with: Constants.AlertController.saveAlertControllerTitle,
      message: Constants.AlertController.saveAlertControllerMessage
    )
  }
  
  private static func showImagePickerAlert(
    on vc: UIViewController,
    with title: String,
    message: String) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    pickerController.allowsEditing = true
    
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .actionSheet
    )
    
    alertController.addAction(UIAlertAction(
      title: Constants.AlertController.libraryTitle,
      style: .default) { (_) in
      pickerController.sourceType = .photoLibrary
      vc.present(pickerController, animated: true, completion: nil)
    })
    
    alertController.addAction(UIAlertAction(
      title: Constants.AlertController.savedPhotosTitle,
      style: .default) { (_) in
      pickerController.sourceType = .savedPhotosAlbum
      vc.present(pickerController, animated: true, completion: nil)
    })
    
    alertController.addAction(UIAlertAction(
                                title: Constants.AlertController.cancelTitle,
                                style: .destructive,
                                handler: nil))
    DispatchQueue.main.async {
      vc.present(alertController, animated: true)
    }
  }
  
  static func showImagePickerSources(on vc: UIViewController) {
    showImagePickerAlert(
      on: vc,
      with: Constants.AlertController.alertTitle,
      message: Constants.AlertController.alertMessage
    )
  }
  
}
