//
//  Constants.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import UIKit

enum Constants {
  
  enum VCIdentifiers {
    static let entyVCId = "EntryViewController"
    static let infoVCId = "InfoViewController"
    static let plannerVCId = "PlannerViewController"
  }
  
  enum CellNibName {
    static let plannerCellNibName = "PlannerCell"
  }
  
  enum Segue {
    static let toNextController = "ToNextController"
  }
  
  enum AlertController {
    static let saveAlertControllerTitle = "Missing Data"
    static let saveAlertControllerMessage = "You still have some empty fields. All the fields should be filled before saving"
    static let saveDismissTitle = "Dismiss"
    static let noteNameKey = "NoteName"
    static let noteTextKey = "NoteDescription"
    static let noteImageKey = "NoteImage"
    static let alertTitle = "Choose an Avatar"
    static let alertMessage = "from Source"
    static let cameraTitle = "From Camera"
    static let libraryTitle = "From Photos Library"
    static let savedPhotosTitle = "Saved Photos Album"
    static let cancelTitle = "Cancel"
    static let save = "Save"
    static let yesTitle = "Yes"
    static let deletionAlertTitle = "Please, confirm deletion!"
    static let deletionAlertMessage = "Are you sure you want to delete this note?"
    static let imgAlertCtrlTitle = "Add an Image"
    static let imgAlertCtrlMessage = "from Source"
    static let imgCancelActionTitle = "Cancel"
    static let photoLibraryTitle = "Photos Library"
  }
  
  enum Placeholders {
    static let textViewPlaceHolder = "Type something here..."
    static let searchControllerplaceholder = "Search"
  }
  
  enum Prefixes {
    static let infoVCTitelPrefix = "Update "
    static let startDatePrefix = " Starts: "
    static let endDatePrefix = " Ends: "
  }
  
  enum StoryboardTitle {
    static let mainStoryboard = "Main"
  }
  
  enum DefaultValues {
    static let defaultDate = "00/00/00"
    static let rowHeight: CGFloat = 100.0
    static let imagePlaceholder = UIImage(named: "defaultPhoto")
    static let threeHours: Double = 10800
  }
  
  enum VCTitle {
    static let entryVCTitle = "Add New Note"
  }
  
  enum Errors {
    static let realmError = "RealmError"
  }
  
  enum Buttons {
    static let saveButton = "Save"
  }
  
  enum Counter {
    static let note = " Note"
    static let notes = " Notes"
  }
  
  enum StringConstants {
    static let jsonType = "json"
  }
  
}
