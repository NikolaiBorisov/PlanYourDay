//
//  SplashViewController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 07.05.2021.
//

import UIKit

class SplashViewController: UIViewController {
  
  @IBOutlet var arrayOfCircles: [UIImageView]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpAlpha()
    runAnimation()
  }
  
  private func setUpAlpha() {
    for circle in arrayOfCircles {
      circle.alpha = 0
    }
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3, execute: {
      for circle in self.arrayOfCircles {
        circle.layer.removeAllAnimations()
      }
      self.performSegue(withIdentifier: Constants.Segue.toNextController, sender: self)
    })
  }
  
  private func animate(delay: Double, circle: UIImageView) {
    UIView.animateKeyframes(withDuration: 0.5, delay: delay, options: [.repeat, .autoreverse], animations: {
      circle.alpha = 1
    })
  }
  
  private func runAnimation() {
    animate(delay: 0, circle: arrayOfCircles[0])
    animate(delay: 0.1, circle: arrayOfCircles[1])
    animate(delay: 0.2, circle: arrayOfCircles[2])
  }
  
}
