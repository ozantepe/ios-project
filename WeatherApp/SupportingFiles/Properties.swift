//
//  Properties.swift
//  WeatherAppOS
//
//  Created by Ozan Tepe on 12.01.2020.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import Foundation

struct Properties {
    
    let BASE_API_URL = "https://api.openweathermap.org/data/2.5/"
    let WEATHER_API_URL = "https://api.openweathermap.org/data/2.5/weather"
    let FORECAST_API_URL = "https://api.openweathermap.org/data/2.5/forecast"
    let API_KEY = "&appid=e6847540897e8e388c607ce5a99d010d"
    let LANG = "&lang=en"
    let UNITS = "&units=metric"
    let IMAGES_PATH = "https://openweathermap.org/img/w/"
    
    func callByCityID(for cityID: Int) -> String {
        return "?id=\(cityID)"
    }
    
    func callBySeveralCityIDs(for cityIDs: String) -> String{
        return "group?id=\(cityIDs)"
    }
    
    func callByCityName(cityName: String) -> String {
        return "?q=\(cityName)"
    }
    
    func callByCityName(like: String) -> String {
        return "find?q=\(like)&type=like"
    }
    
    func celsiusToFahrenheit(celsius: Double) -> Double {
        return celsius * (9.0/5.0) + 32
    }
}
