//
//  HomePageModel.swift
//
//

import Foundation

// This struct to save HomePage's variables
struct HomePageModel {
    var listCities: [CityModel] = []
    var fullListForcast: [WeatherResponse] = []
    var filtredList: [WeatherResponse] = []
}

// This enum presents the actions used on View to command the ViewModel
enum HomePageInputAction {
    case loadListCities
    case searchForCity(name: String)
}

// This enum presents the actions used to communicate the ViewModel's data to View
enum HomePageOutputResult {
    case didFinish(result: Any)
    case didFailed(error: String)
    case loadingState(state: Bool)
}

// This struct used to store data to pass from View to ViewModel as Input
struct HomePageInputModel {
}
