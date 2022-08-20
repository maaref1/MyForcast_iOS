//
//  SearchPageModel.swift
//
//

import Foundation

struct SearchPageModel {
    var listCities: [ResultCity] = []
}

enum SearchPageInputAction {
    case searchForCity(name: String)
    case selectCityFromTable(model: ResultCity)
}

enum SearchPageOutputResult {
    case didCitySelected(model: ResultCity)
    case didFinish(result: Any)
    case didFailed(error: String)
    case loadingState(state: Bool)
}

enum SearchServiceOutputResult {
    case didFinish(result: Any)
    case didFailed(error: String)
    case loadingState(state: Bool)
}

struct SearchPageInputModel {
}
