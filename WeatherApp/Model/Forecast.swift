//
//  Forecast.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import Foundation

// MARK: - Forecast
struct DecodedForecasts: Codable {
    let list: [DecodedForecast]
}

// MARK: - List
struct DecodedForecast: Codable {
    let date: Date
    let temp: Temp
    let forecastWeather: [ForecastWeather]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temp
        case forecastWeather = "weather"
    }
}

// MARK: - Temp
struct Temp: Codable {
    let min, max: Double
}

// MARK: - ForecastWeather
struct ForecastWeather: Codable {
    let main: String
}

struct Forecast: Codable {
    let date: Date
    let maxTemp: Int
    let minTemp: Int
    let description: String
    
    init(forecast: DecodedForecast) {
        self.date = forecast.date
        self.minTemp = Int(forecast.temp.min.rounded(.toNearestOrEven))
        self.maxTemp = Int(forecast.temp.max.rounded(.toNearestOrEven))
        self.description = forecast.forecastWeather.first?.main ?? ""
    }
}
