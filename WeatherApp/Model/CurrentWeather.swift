//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import Foundation

// MARK: - CurrentWeather
struct DecodedWeather: Decodable {
    
    let weather: [Weather]
    let main: Main
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case weather, main
        case cityName = "name"
    }
}

// MARK: - Main
struct Main: Decodable {
    let temp: Double
}

// MARK: - Weather
struct Weather: Decodable {
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case type = "main"
    }
}

struct CurrentWeather: Codable {

    let currentTemp: Int
    let weatherType: String
    let cityName: String
    
    init(weather: DecodedWeather) {
        self.currentTemp = Int(weather.main.temp.rounded(.toNearestOrEven))
        self.weatherType = weather.weather.first?.type ?? ""
        self.cityName = weather.cityName
    }
}
