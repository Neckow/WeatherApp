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
    
    // Array Model instance
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
                ForecastWeather( dt: json["dt"].stringValue,
                                 temp_min: json["main"]["temp_min"].stringValue,
                                 temp_max: json["main"]["temp_max"].stringValue )
            }
            
            self.forecasWeathers.value = forecastWeatherList!
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

//extension ForecastListViewModel: DataFormatter {
//
////    func DatetimeToDate(datetime: Double?)  -> String {
////        if  let  timeResult = (datetime) {
////            let date = Date(timeIntervalSince1970: timeResult)
////            let dateFormatter = DateFormatter()
////
////            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
////            dateFormatter.locale = Locale(identifier: "fr_FR")
//////            dateFormatter.timeZone = TimeZone()
////
////            return dateFormatter.string(from: date)
////        }
////        return "34/34/34"
////    }
//    func getDayOfWeek(_ today: String) -> Int? {
//        let formatter  = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        guard let todayDate = formatter.date(from: today) else { return nil }
//        let myCalendar = Calendar(identifier: .gregorian)
//        let weekDay = myCalendar.component(.weekday, from: todayDate)
//        return weekDay
//    }
//}

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
