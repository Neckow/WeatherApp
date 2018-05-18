//
//  ForecastWeather.swift
//  weatherapp
//
//  Created by Loic B on 04/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import Foundation

struct ForecastWeather: Codable {
    let dt: Double
    let temp_min: Double
    let temp_max: Double
    
    var dayOfWeek : String {
        get {
            return datetimeToDate(datetime: dt)
        }
        set {
        }
    }
    
}

extension ForecastWeather {
    func datetimeToDate(datetime: Double?) -> String {
        guard let datetime = datetime else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: datetime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "EEEE" // put in cache
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }

}
