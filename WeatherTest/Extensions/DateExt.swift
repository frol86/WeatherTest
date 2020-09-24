//
//  DateExt.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import Foundation

extension Date {
    
    func toYmd() -> String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ru_RU")
        dateFormater.dateFormat = "YYYY-MM-dd"
        return dateFormater.string(from: self)
    }
    
    
    func toDm() -> String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ru_RU")
        dateFormater.dateFormat = "dd MMMM"
        return dateFormater.string(from: self)
    }
}
