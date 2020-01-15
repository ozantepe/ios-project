//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import Foundation

struct ForecastResponse: Codable {
    var count: Int?
    var list: Array<Forecast>?
}

extension ForecastResponse {
    
    struct Forecast: Codable {
        var dt: TimeInterval?
        var main: Main?
        var weather: Array<Weather>?
        var wind: Wind?
    }
    
    struct Main: Codable {
        var temp: Double?
        var tempMin: Double?
        var tempMax: Double?
        var pressure: Double?
        var seaLevel: Double?
        var groundLevel: Double?
        var humidity: Int?
        var tempKF: Double?
        
        private enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case groundLevel = "grnd_level"
            case humidity
            case tempKF = "temp_kf"
        }
    }
    
    struct Weather: Codable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
    
    struct Wind: Codable {
        var speed: Double?
        var deg: Double?
    }
}
