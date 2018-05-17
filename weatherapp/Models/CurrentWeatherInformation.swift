//
//  CurrentWeatherInformation.swift
//  weatherapp
//
//  Created by Loic B on 04/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import Foundation

struct CurrentWeatherInformation: Codable {
    let id: Int
    let sunrise: String?
    let sunset: String?
    let cloud: Int
    let rain: Int
    let humidity: Int
    let pression: Int
}
