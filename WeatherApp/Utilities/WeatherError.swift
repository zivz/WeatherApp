//
//  WeatherError.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import Foundation

enum WeatherError: String, Error {
    case invalidResponse = "Invalid response from the server"
    case invalidURL = "Invalid url"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidData = "The data received from the server was corrupted. Please try again"
}


