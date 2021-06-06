//
//  PlannerCell.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 08.05.2021.
//

import UIKit

class PlannerCell: UITableViewCell {
  
  static let identifier = "plannerCell"
  
  @IBOutlet weak var noteImage: UIImageView!
  @IBOutlet weak var noteTitleLabel: UILabel!
  @IBOutlet weak var noteDescriptionLabel: UILabel!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    noteImage.setUpGreyBorder()
  }
  
  func configure(with model: Note) {
    noteTitleLabel.text = model.name
    noteDescriptionLabel.text = model.descriptionText
    if let image = model.noteImage {
      noteImage.image = image
    } else {
      noteImage.image = Constants.DefaultValues.imagePlaceholder
    }
    startDateLabel.text = Constants.Prefixes.startDatePrefix + model.dateStart
    endDateLabel.text = Constants.Prefixes.endDatePrefix + model.dateFinish
  }
  
}
