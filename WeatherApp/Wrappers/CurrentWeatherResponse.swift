//
//  CurrentWeatherResponse.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    var coord: Coord?
    var weather: Array<Weather>?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var dt: TimeInterval?
    var sys: Sys?
    var id: Int?
    var name: String?
}

extension CurrentWeatherResponse {
    
    struct Coord: Codable {
        var lon: Double?
        var lat: Double?
    }
    
    struct Weather: Codable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
    
    struct Main: Codable {
        var temp: Double?
        var pressure: Int?
        var humidity: Int?
        var temp_min: Double?
        var temp_max: Double?
    }
    
    struct Wind: Codable {
        var speed: Double?
        var deg: Double?
    }
    
    struct Sys: Codable {
        var country: String?
        var sunrise: TimeInterval?
        var sunset: TimeInterval?
    }
}
