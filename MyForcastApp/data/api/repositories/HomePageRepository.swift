//
//  HomeRepository.swift
//  MyForcastApp
//
//  Created by MacBook Air on 18/08/2022.
//

import Foundation

typealias CompletionListWeather = (_ success: Bool,
                                   _ model: WeatherResponse?,
                                   _ error: String?) -> Void

protocol HomePageRepository {
    func callGetListWeathersLonLat(lon: String,
                                   lat: String,
                                   completion: @escaping(CompletionListWeather))
}

extension MyBaseRepository: HomePageRepository {
    
    /*
     This function will get list of weathers by lat, lon position
     */
    func callGetListWeathersLonLat(lon: String,
                                   lat: String,
                                   completion: @escaping(CompletionListWeather)) {
        let params: [String: Any] = [
            MyConstants.latKey: lat,
            MyConstants.lonKey: lon,
            MyConstants.unitsKey: "metric",
            MyConstants.apiIdKey: MyConstants.apiWeatherId
        ]
        let headers: [String: String] = [:]
        self.apiRequest(path: MyConstants.getListWeathersPath,
                        method: .get,
                        params: params,
                        headers: headers,
                        responseType: WeatherResponse.self) { res, error in
            guard res != nil else {
                return
            }
            completion(true, res, error)
        }
    }
}
