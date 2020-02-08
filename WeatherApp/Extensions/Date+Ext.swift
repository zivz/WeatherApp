//
//  Date+Ext.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import Foundation

extension Date {
    
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        return "Today, \(currentDate)"
    }
}
