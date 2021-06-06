//
//  RealmService.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 24.05.2021.
//

import Foundation
import RealmSwift

class RealmService {
  
  private init() {}
  static let shared = RealmService()
  var realm = try! Realm()
  
  func saveObjects<T: Object>(_ objects: [T], closure: (() -> Void)? = nil) {
    objects.forEach { object in
      do {
        try self.realm.write {
          self.realm.add(object, update: .modified)
        }
      } catch {
        print(error)
      }
    }
    closure?()
  }
  
  func delete<T: Object>(_ object: T) {
    do {
      try realm.write {
        realm.delete(object)
      }
    } catch {
      print(error)
    }
  }
  
}
