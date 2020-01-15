//
//  CityNameLikeResponse.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import Foundation

struct CityNameLikeResponse: Codable {
    var message: String?
    var cod: String?
    var count: Int?
    var list: Array<City>?
}

extension CityNameLikeResponse {
    
    struct City: Codable {
        var id: Int?
        var name: String?
        var coord: Coord?
        var main: Main?
        var dt: TimeInterval?
        var wind: Wind?
        var sys: Sys?
        var weather: Array<Weather>?
    }
    
    struct Coord: Codable {
        var lat: Double?
        var lon: Double?
    }
    
    struct Main: Codable {
        var temp: Double?
        var pressure: Double?
        var humidity: Double?
        var temp_min: Double?
        var temp_max: Double?
    }
    
    struct Wind: Codable {
        var speed: Double?
        var deg: Double?
    }
    
    struct Sys: Codable {
        var country: String?
    }
    
    struct Weather: Codable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
}
