//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 03/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    static let reuseID = "forecastCell"
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    func configureCell(forecast: Forecast) {
        lowTemp.text = "\(forecast.minTemp)°"
        highTemp.text = "\(forecast.maxTemp)°"
        weatherType.text = "\(forecast.description)"
        weatherIcon.image = UIImage(named: forecast.description) 
        dayLabel.text = forecast.date.dayOfTheWeek()
    }
    
}
