//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    @IBOutlet var currentWeatherElements: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var currentWeather: CurrentWeather!
    var forecasts = [DecodedForecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 5000
        locationManager.requestWhenInUseAuthorization()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        activityIndicator.isHidden = true
        hideCurrentWeatherElements()
    }
    
    private func hideCurrentWeatherElements() {
        for element in currentWeatherElements {
            element.isHidden = true
        }
        currentWeatherImage.isHidden = true
    }
    
    private func showCurrentWeatherElements() {
        for element in currentWeatherElements {
            element.isHidden = false
        }
        currentWeatherImage.isHidden = false
    }
    
    private func fetchData() {
        print("fetching new data as location has changed to (lat: \(Location.shared.latitude), lon: \(Location.shared.longitude))")
        getCurrentWeather()
    }
    
    private func startSpinner() {
        view.alpha = 0.75
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopSpinner() {
        view.alpha = 1.0
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func getCurrentWeather() {
        startSpinner()
        NetworkManager.shared.getCurrentWeather { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.stopSpinner()
            }
            
            switch result {
            case .success(let currentWeather):
                self.currentWeather = currentWeather
                DispatchQueue.main.async {
                    self.updateMainUI()
                    self.showCurrentWeatherElements()
                }
                self.getForecast()
            case .failure(let error):
                self.showAlertOnMain(title: "Something went wrong", message: error.rawValue)
            }
        }
    }
    
    private func getForecast() {
        NetworkManager.shared.getForecast { [weak self] result in
            guard let self = self else { return }
           
            switch result {
            case .success(let forecasts):
                self.forecasts = forecasts.list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.showAlertOnMain(title: "Something went wrong", message: error.rawValue)
            }
        }
    }
    
    func updateMainUI() {
        dateLabel.text = Date().currentDate()
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
}

extension WeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.reuseID, for: indexPath) as? ForecastCell {
            let forecast = Forecast(forecast: forecasts[indexPath.row])
            cell.configureCell(forecast: forecast)
            return cell
        }
        
        return ForecastCell()
    }
}

extension WeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showAlertOnMain(title: "Check your location", message: "Your location seems to be none")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = locationManager.location?.coordinate else {
            return }
        Location.shared.latitude = currentLocation.latitude
        Location.shared.longitude = currentLocation.longitude
        fetchData()
    }
}
