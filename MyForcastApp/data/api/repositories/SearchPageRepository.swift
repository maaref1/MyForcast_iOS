//
//  SearchPageRepository.swift
//  MyForcastApp
//
//  Created by MacBook Air on 20/08/2022.
//

import Foundation

typealias CompletionListCities = (_ success: Bool,
                                  _ model: CityLocationResponse?,
                                  _ error: String?) -> Void

protocol SearchPageRepository {
    func searchListCitiesByName(value: String,
                                completion: @escaping(CompletionListCities))
}

extension MyBaseRepository: SearchPageRepository {
    
    func searchListCitiesByName(value: String,
                                completion: @escaping(CompletionListCities)) {
        let params: [String: Any] = [
            MyConstants.citySearchKey: value,
            MyConstants.limitSearchKey: 5,
            MyConstants.apiIdKey: MyConstants.apiWeatherId
        ]
        let headers: [String: String] = [:]
        self.apiRequest(path: MyConstants.pathSearchCity,
                        method: .get,
                        params: params,
                        headers: headers,
                        responseType: CityLocationResponse.self) { res, error in
            guard res != nil else {
                return
            }
            completion(true, res, error)
        }
    }
}
