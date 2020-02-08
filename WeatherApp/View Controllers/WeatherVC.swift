//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var currentWeatherElements: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecasts = [DecodedForecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.shared.latitude = currentLocation.coordinate.latitude
            Location.shared.longitude = currentLocation.coordinate.longitude
            fetchData()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func fetchData() {
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
                self.showCurrentWeatherElements()
            }
            
            switch result {
            case .success(let currentWeather):
                self.currentWeather = currentWeather
                DispatchQueue.main.async {
                    self.updateMainUI()
                }
                self.getForecast()
            case .failure(let error):
                print(error.rawValue)
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
                print(error.rawValue)
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

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
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
