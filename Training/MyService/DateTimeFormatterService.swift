//
//  DateTimeFormatterService.swift
//  Training
//
//  Created by ManhLD on 12/11/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation

class DateTimeFormatterService {
    
    let dateFormatter = DateFormatter()

class var getInstance: DateTimeFormatterService {
     struct Static {
         static let instance: DateTimeFormatterService = DateTimeFormatterService()
     }
     return Static.instance
 }
    
   open func StringToDate(date : String, output: @escaping (Date) -> () ) {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        let dateOuput = dateFormatter.date(from: date)!
        output(dateOuput)
    }
    
  open func DateToString(date : Date, output: @escaping (String) -> () ) {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let outputDate = dateFormatter.string(from: date)
        output(outputDate)
    }
    
}
