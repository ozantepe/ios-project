//
//  ForecastViewCell.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit

class ForecastViewCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    private var props = Properties()
    private var timeZone: TimeZone!
    
    
    // MARK: - Custom functions
    
    func configure(for forecast: ForecastResponse.Forecast, with metric: String?) {
        if let iconID = forecast.weather![0].icon {
            fetchImage(for: iconID)
        }
        let date = Date(timeIntervalSince1970: forecast.dt!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = self.timeZone
        let localDate = dateFormatter.string(from: date)
        self.dayLabel.text = localDate
        self.weatherLabel.text = forecast.weather![0].main
        
        switch metric {
        case "celsius":
            self.maxTempLabel.text = "\(forecast.main?.tempMax?.toString(format: ".1") ?? "--")ºC"
            self.minTempLabel.text = "\(forecast.main?.tempMin?.toString(format: ".1") ?? "--")ºC"
        case "fahrenheit":
            self.maxTempLabel.text = "\(props.celsiusToFahrenheit(celsius:(forecast.main?.tempMax)!).toString(format: ".1") )ºF"
            self.minTempLabel.text = "\(props.celsiusToFahrenheit(celsius:(forecast.main?.tempMin)!).toString(format: ".1") )ºF"
        default:
            self.maxTempLabel.text = "\(forecast.main?.tempMax?.toString(format: ".1") ?? "--")ºC"
            self.minTempLabel.text = "\(forecast.main?.tempMin?.toString(format: ".1") ?? "--")ºC"
        }
    }
    
    
    private func fetchImage(for iconID: String) {
        let requestURL = URL(string: props.IMAGES_PATH + iconID + ".png")!
        let request = URLRequest(url: requestURL)
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.weatherImage.image = UIImage(data: data)
                }
            } else {
                print("Error while getting image data.")
            }
        }.resume()
    }
}
