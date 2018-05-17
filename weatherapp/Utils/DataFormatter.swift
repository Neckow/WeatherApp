//
//  DataFormatter.swift
//  weatherapp
//
//  Created by Loic B on 15/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import Foundation

protocol DataFormatter  {
    func datetimeToDate(datetime: Double?) -> Date
}


