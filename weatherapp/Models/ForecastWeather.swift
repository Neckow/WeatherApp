//
//  ForecastDayWeather.swift
//  weatherapp
//
//  Created by Loic B on 04/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import Foundation

struct ForecastDayWeather: Codable {
    let id: Int
    let icon: String?
    let temp_min: Float
    let temp_max: Float
}
