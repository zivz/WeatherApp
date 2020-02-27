//
//  Location.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import Foundation

class Location {
    static var shared = Location()
    
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
