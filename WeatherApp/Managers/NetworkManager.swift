//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import Foundation

private struct EndPoints {
    private struct Path {
        static let weather = "/data/2.5/weather"
        static let forecast = "/data/2.5/forecast/daily"
    }
    
    private static let base_url = "api.openweathermap.org"
    
    private struct QueryParams {
        static let latitude = "lat"
        static let longitude = "lon"
        static let app_id = "appid"
        static let mode = "mode"
        static let count = "cnt"
        static let units = "units"
    }
    
    private struct QueryValues {
        static let api_key = "42a1771a0b787bf12e734ada0cfc80cb"
        static let mode = "json"
        static let count = 10
        static let units = "metric"
        static let latitude = Location.shared.latitude!
        static let longitude = Location.shared.longitude!
    }
    
    
    static var currentWeatherURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = EndPoints.base_url
        components.path = Path.weather
        components.queryItems = [
            URLQueryItem(name: QueryParams.latitude, value: String(Location.shared.latitude!)),
            URLQueryItem(name: QueryParams.longitude, value: String(Location.shared.longitude!)),
            URLQueryItem(name: QueryParams.app_id, value: QueryValues.api_key),
            URLQueryItem(name: QueryParams.units, value: QueryValues.units)
        ]
        
        return components.url
        
    }
    
    static var forecastURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = EndPoints.base_url
        components.path = Path.forecast
        components.queryItems = [
            URLQueryItem(name: QueryParams.latitude, value: String(Location.shared.latitude!)),
            URLQueryItem(name: QueryParams.longitude, value: String(Location.shared.longitude!)),
            URLQueryItem(name: QueryParams.app_id, value: QueryValues.api_key),
            URLQueryItem(name: QueryParams.units, value: QueryValues.units),
            URLQueryItem(name: QueryParams.mode, value: QueryValues.mode),
            URLQueryItem(name: QueryParams.count, value: String(QueryValues.count)),
        ]
               
        return components.url
    }
    
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func getCurrentWeather(completionHandler: @escaping (Result<CurrentWeather, WeatherError>) -> Void ) {
        
        guard let url = EndPoints.currentWeatherURL else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedWeather = try decoder.decode(DecodedWeather.self, from: data)
                let currentWeather = CurrentWeather(weather: decodedWeather)
                completionHandler(.success(currentWeather))
            } catch {
                completionHandler(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
    
    func getForecast(completionHandler: @escaping(Result<DecodedForecasts, WeatherError>) -> Void ) {
        
        guard let url = EndPoints.forecastURL else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let forecasts = try decoder.decode(DecodedForecasts.self, from: data)
                completionHandler(.success(forecasts))
            } catch {
                completionHandler(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
}
