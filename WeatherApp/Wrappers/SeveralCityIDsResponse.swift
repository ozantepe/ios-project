//
//  SeveralCityIDsResponse.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import Foundation

struct SeveralCityIDsResponse: Codable {
    var cnt: Int?
    var list: Array<CurrentWeatherResponse>?
}
