//
//  OtherDetailsViewCell.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit

class OtherDetailsViewCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var sectionImage: UIImageView!
    
    private let props = Properties()
    private var timeZone: TimeZone!
    
    
    // MARK: - Custom fonctions
    
    func configure(data currentWeatherData: CurrentWeatherResponse, for section: Int) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = self.timeZone
        
        switch section {
        case 0:
            if let iconID = currentWeatherData.weather![0].icon {
                fetchImage(for: iconID)
            }
            valueLabel.text = "\(currentWeatherData.weather![0].description ?? "null")"
        case 1:
            let sunrise = currentWeatherData.sys?.sunrise
            let date1 = Date(timeIntervalSince1970: sunrise!)
            let sunriseTime = dateFormatter.string(from: date1)
            valueLabel.text = sunriseTime
            sectionImage.image = UIImage(named: "Sunrise.png")
        case 2:
            let sunset = currentWeatherData.sys?.sunset
            let date2 = Date(timeIntervalSince1970: sunset!)
            let sunsetTime = dateFormatter.string(from: date2)
            valueLabel.text = sunsetTime
            sectionImage.image = UIImage(named: "Sunset.png")
        default:
            valueLabel.text = "null"
            sectionImage.image = UIImage(named: "Default.png")
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
                    self.sectionImage.image = UIImage(data: data)
                }
            } else {
                print("Error while getting image data.")
            }
        }.resume()
    }
}
