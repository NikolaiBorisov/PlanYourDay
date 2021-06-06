//
//  UIImageView+Extension.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import UIKit

extension UIImageView {
  func roundView() {
    self.layer.cornerRadius = self.frame.width / 2
    self.clipsToBounds = true
  }
}
