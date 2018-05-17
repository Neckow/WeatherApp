//
//  CurrentWeather.swift
//  weatherapp
//
//  Created by Loic B on 04/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let id: Int
    let mainWeather: String
    let description: String
    let icon: String?
    let temp: Float
}
