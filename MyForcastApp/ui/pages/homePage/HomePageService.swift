//
//  LoginPageService.swift
//
//

import Foundation
import RxSwift

protocol HomePageServiceProtocol {
    func noneService()
    func loadWeatherForCities(cities: [CityModel])
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
    
    func loadWeatherForCities(cities: [CityModel]) {
        var listWeather: [WeatherResponse] = []
        cities.forEach { cityModel in
            self.apiClient.callGetListWeathersLonLat(lon: "\(cityModel.lon)",
                                                     lat: "\(cityModel.lat)") { _, model, _ in
                var model = model
                model?.cityName = cityModel.name
                model?.districtName = cityModel.subName
                
                listWeather.append(model ?? .init(lat: -1))
                if listWeather.count == cities.count {
                    listWeather = listWeather.filter({$0.lat != -1})
                    self.serviceOutput.onNext(HomePageOutputResult.didFinish(result: listWeather))
                }
            }
        }
    }
}
