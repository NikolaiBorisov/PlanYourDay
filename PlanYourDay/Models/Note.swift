//
//  JSONModel.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 09.05.2021.
//

import SwiftyJSON
import RealmSwift
import UIKit

class Note: Object, Codable {
  @objc dynamic var id: Int = 0
  @objc dynamic var dateStartTimestamp: String = ""
  @objc dynamic var dateFinishTimestamp: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var descriptionText: String = ""
  @objc dynamic var image: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case dateStartTimestamp = "date_start"
    case dateFinishTimestamp = "date_finish"
    case name
    case descriptionText = "description"
    case image
  }
  
}

extension Note {
  var dateStart: String {
    get { DateFormatters.convertToStringFromTimestamp(datestamp: self.dateStartTimestamp) }
    set { self.dateStartTimestamp = newValue }
  }
  
  var dateFinish: String {
    get { DateFormatters.convertToStringFromTimestamp(datestamp: self.dateFinishTimestamp) }
    set { self.dateFinishTimestamp = newValue }
  }
  
  var noteImage: UIImage? {
    return UIImage(named: image)
  }
}

enum DateFormatters {
  
  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }
  
  static var dateAndTimeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }
  
  static func convertToStringFromTimestamp(datestamp: String) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(datestamp) ?? 0.0)
    return Self.dateFormatter.string(from: date)
  }
  
  static func convertToStringFromTimestampWithTime(datestamp: String) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(datestamp) ?? 0.0)
    return Self.dateAndTimeFormatter.string(from: date)
  }
  
  static func convertToTimestamp(date: Date) -> String {
    return String(Int64(date.timeIntervalSince1970))
  }
  
  static func convertToStringFromDateType(format: Date) -> String {
    return Self.dateFormatter.string(from: format)
  }
  
  static func stringFromDatestamp(datestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(datestamp))
    return Self.dateFormatter.string(from: date)
  }
  
}

extension Date {
  
  func addThreeHours() -> Date {
    let timeInterval = timeIntervalSince1970
    return Date(timeIntervalSince1970: timeInterval + Constants.DefaultValues.threeHours)
  }
  
}
