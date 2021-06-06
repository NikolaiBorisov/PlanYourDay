//
//  AppDelegate.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    if #available(iOS 13, *) {
      
    } else {
      guard let window = window else { return false }
      let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
      window.rootViewController = vc
      window.makeKeyAndVisible()
    }
    return true
  }
}
