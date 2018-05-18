//
//  ForecastListViewModel.swift
//  weatherapp
//
//  Created by Loic B on 04/05/2018.
//  Copyright © 2018 Loic B. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class ForecastListViewModel {
    
    let disposeBag = DisposeBag()
    
    let forecasWeathers : Variable<[ForecastWeather]> = Variable([])
    public let cellViewModels: Variable<[ForecastListCellViewModel]> = Variable([])
    let isLoading: Variable<Bool?> = Variable(nil)
    let alertMessage: Variable<String?> = Variable("")

    init() {
        setup()
    }
    
    // Array Model instance (old way)
//    var forecastWeathers : [ForecastWeather] = [ForecastWeather]() {
//        didSet {
//            cellViewModels = formatToViewModel(forecastWeathers)
//        }
//    }
//
//    public var cellViewModels: [ForecastListCellViewModel] = [ForecastListCellViewModel]() {
//        didSet {
//            self.reloadTableViewClosure?()
//        }
//    }
//
//    var isLoading: Bool = false {
//        didSet {
//            self.updateLoadingStatus?()
//        }
//    }
//
//    var alertMessage: String? {
//        didSet {
//            self.showAlertClosure?()
//        }
//    }
    
    func fetchData() {
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast?q=Lyon,fr&units=metric&appid=9127d6dae386254ac9dc6c3315148aaf").responseJSON {
            response in
              guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while fetching Weather: \(String(describing: response.result.error))")
                    return
            }
            
            let forecastWeatherList = JSON(value)["list"].array?.map { json -> ForecastWeather in
                    ForecastWeather( dt: json["dt"].doubleValue, // to convert into string
                                     temp_min: json["main"]["temp_min"].doubleValue,
                                     temp_max: json["main"]["temp_max"].doubleValue )
            }
            
            guard let list = forecastWeatherList else {
                return
            }
            
            let grouped = list.groupBy(\.dayOfWeek)

            let final: [ForecastWeather] = grouped.compactMap {                 //ask for detail
                guard let dt = $0.value.map ({ $0.dt }).min(),
                      let temp_min = $0.value.map ({ $0.temp_min }).min(),
                      let temp_max = $0.value.map ({ $0.temp_max }).max() else {
                        return nil
                }
                return ForecastWeather(
                                dt: dt,
                                temp_min: temp_min,
                                temp_max: temp_max)
            }.sorted(by: { $0.dt < $1.dt })
        
            self.forecasWeathers.value = final
        }
    }
    
    // Transform the model array to ViewModel array
    private func formatToViewModel(_ model: [ForecastWeather]) -> [ForecastListCellViewModel] {
        let forecastCellVM = model.map {
            return ForecastListCellViewModel(model: $0)
        }
        return forecastCellVM
    }
    
    private func setup() {
        self.forecasWeathers
            .asObservable()
            .subscribe(onNext: { [weak self] weather in
                guard let strongSelf = self else { return }
                strongSelf.cellViewModels.value = strongSelf.formatToViewModel(weather)
            }).disposed(by: disposeBag)
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
}

struct ForecastListCellViewModel {
    let day: String
    let temp_min: Double
    let temp_max: Double
}

extension ForecastListCellViewModel {
    init(model: ForecastWeather) {
        self.day = model.dayOfWeek   //number formatter
        self.temp_min = model.temp_min
        self.temp_max = model.temp_max
    }
}

extension Sequence {
    public func groupBy<T: Hashable>(_ groupAttribute: KeyPath<Element, T>) -> [T: [Element]] {
        var result: [T: [Element]] = [:]
        
        for value in self {
            let attribute = value[keyPath: groupAttribute]
            
            if result.keys.contains(attribute) {
                result[attribute]?.append(value)
            } else {
                result[attribute] = [value]
            }
        }
        
        return result
    }
}
