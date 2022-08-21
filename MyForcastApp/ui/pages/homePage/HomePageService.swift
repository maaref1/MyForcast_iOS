//
//  LoginPageService.swift
//
//

import Foundation
import RxSwift

protocol HomePageServiceProtocol {
    func noneService()
    func loadWeatherForCities(cities: [ResultCity])
    func performGetWeatherFromApi(cities: [ResultCity], completion: (() -> Void)?)
}

class HomePageService: HomePageServiceProtocol {

    var serviceOutput = PublishSubject<Any>()
    
    var apiClient: HomePageRepository
    
    init(api: HomePageRepository) {
        self.apiClient = api
    }
    
    // This function presents a none Service
    func noneService() {
        self.serviceOutput.onNext(HomePageOutputResult.didFinish(result: true))
    }
    
    func loadWeatherForCities(cities: [ResultCity]) {
        self.sendSavedListIfExists(cities: cities)
        self.performGetWeatherFromApi(cities: cities)
    }
    
    func performGetWeatherFromApi(cities: [ResultCity], completion: (() -> Void)? = nil) {
        guard !cities.isEmpty else {
            completion?()
            return
        }
        var listWeather: [WeatherResponse] = []
        cities.forEach { cityModel in
            self.apiClient.callGetListWeathersLonLat(lon: "\(cityModel.lon)",
                                                     lat: "\(cityModel.lat)") { _, model, _ in
                var model = model
                model?.cityName = cityModel.name
                model?.districtName = cityModel.state
                
                listWeather.append(model ?? .init(lat: -1))
                if listWeather.count == cities.count {
                    listWeather = listWeather.filter({$0.lat != -1})
                    CoreDataManager.shared.setWeatherList(list: listWeather)
                    listWeather = listWeather.sorted(by: {$0.cityName < $1.cityName})
                    self.serviceOutput.onNext(HomePageOutputResult.didFinish(result: listWeather))
                    completion?()
                }
            }
        }
    }
    
    func sendSavedListIfExists(cities: [ResultCity]) {
        var listWeather: [WeatherResponse] = []
        listWeather = CoreDataManager.shared.getListWeathers()
        guard listWeather.count == cities.count else {
            return
        }
        listWeather = listWeather.sorted(by: {$0.cityName < $1.cityName})
        self.serviceOutput.onNext(HomePageOutputResult.didFinish(result: listWeather))
    }
}
