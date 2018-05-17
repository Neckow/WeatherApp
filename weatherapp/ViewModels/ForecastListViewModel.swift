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
                ForecastWeather( dt: self.datetimeToDate(datetime: json["dt"].doubleValue),
                                 temp_min: json["main"]["temp_min"].stringValue,
                                 temp_max: json["main"]["temp_max"].stringValue )
            }
            guard let list = forecastWeatherList else {
                return
            }
            self.forecasWeathers.value = list
        }
    }
    
    // Transform the model array to ViewModel array
    private func formatToViewModel(_ model: [ForecastWeather]) -> [ForecastListCellViewModel] {
        let forecastCellVM = model.map {
            return ForecastListCellViewModel(model: $0)
        }
        return forecastCellVM
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
}

extension ForecastListViewModel {

    func datetimeToDate(datetime: Double?) -> String {
        guard let datetime = datetime else {
            return ""
        }
          
        let date = Date(timeIntervalSince1970: datetime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = " EEE dd.MM"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
}

extension ForecastListViewModel {
    private func setup() {
        self.forecasWeathers
            .asObservable()
            .subscribe(onNext: { [weak self] weather in
            guard let strongSelf = self else { return }
                strongSelf.cellViewModels.value = strongSelf.formatToViewModel(weather)
        }).disposed(by: disposeBag)
    }
    
}

struct ForecastListCellViewModel {
    let day: String?
    let temp_min: String?
    let temp_max: String?
}

extension ForecastListCellViewModel {
    init(model: ForecastWeather) {
        self.day = model.dt
        self.temp_min = model.temp_min
        self.temp_max = model.temp_max
    }
}
