//
//  CoreDataManagerTest.swift
//  MyForcastAppTests
//
//  Created by MacBook Air on 21/08/2022.
//

import XCTest
@testable import MyForcastApp

class CoreDataManagerTest: XCTestCase {
    
    func testCoreData() {
    }
    
    func testCityData() {
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        let cityModel = ResultCity(name: "Paris",
                                   localNames: [:],
                                   lat: 0,
                                   lon: 0,
                                   country: "",
                                   state: "")
        CoreDataManager.shared.addCityToLocalList(city: cityModel)
        _ = CoreDataManager.shared.getListCities()
        _ = CoreDataManager.shared.getCityFromDb(name: "Paris")
        CoreDataManager.shared.removeCityFromLocalList(name: "Paris")
        CoreDataManager.shared.deleteAllData("CDCityModel") { _ in
            expectation.fulfill()
        }
        PersistenceService.deleteEntityByName(name: "CDCityModel")
        wait(for: [expectation], timeout: 10)
    }
    
    func testWeatherData() {
        let weatherModel = WeatherResponse(cityName: "Paris", districtName: "")
        CoreDataManager.shared.addWeatherToLocalList(city: weatherModel)
        CoreDataManager.shared.setWeatherList(list: [weatherModel])
        
        _ = CoreDataManager.shared.getWeatherFromDb(name: "Paris")
        CoreDataManager.shared.removeWeatherFromLocalList(name: "Paris")
    }
    
}
