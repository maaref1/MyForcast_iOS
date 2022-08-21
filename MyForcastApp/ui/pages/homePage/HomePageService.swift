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
    
    /*
     This function will represent an empty Service as default service with no action
     */
    func noneService() {
        self.serviceOutput.onNext(HomePageOutputResult.didFinish(result: true))
    }
    
    /*
     This function will get list of cities either from a web's Api and/or from local db if exists
     */
    func loadWeatherForCities(cities: [ResultCity]) {
        // will get saved list, then update tableView if list not empty
        self.sendSavedListIfExists(cities: cities)
        // meanwhile we execute a fetch on api to get the newest list weathers
        self.performGetWeatherFromApi(cities: cities)
    }
    
    /*
     This function will get list of weather from Api by list of cities
     */
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
    
    /*
     This function will get the list of cities from local DB
     */
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
