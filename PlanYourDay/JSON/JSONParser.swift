//
//  JSONParser.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 08.05.2021.
//

import UIKit

enum FileName: String {
  case plannerJSON
}

class JSONParcer {
  
  static func parseFile<T: Codable>(with name: FileName, type: T.Type) -> [T]? {
    
    guard let bundlePath = Bundle.main.path(forResource: name.rawValue, ofType: Constants.StringConstants.jsonType) else { return nil }
    let url = URL(fileURLWithPath: bundlePath)
    guard let data = try? Data(contentsOf: url) else { return nil }
    
    let decoder: JSONDecoder = JSONDecoder()
    do {
      return try decoder.decode([T].self, from: data)
    } catch {
      print(error)
    }
    return nil
  }
}
