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
    
    func StringToDate(date : String, output: @escaping (Date) -> () ) {
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        let dateOuput = dateFormatter.date(from:date)!
        output(dateOuput)
    }
    
    func DateToString(date : Date, output: @escaping (String) -> () ) {
        dateFormatter.dateFormat = "dd"
        let outputDate = dateFormatter.string(from: date)
        output(outputDate)
    }
    
}
