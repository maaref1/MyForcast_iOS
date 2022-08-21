//
//  LoginPageService.swift
//
//

import Foundation
import RxSwift

protocol SearchPageServiceProtocol {
    func noneService()
    func searchForCityByName(value: String)
}

class SearchPageService: SearchPageServiceProtocol {
    
    var serviceOutput = PublishSubject<SearchServiceOutputResult>()
    
    var apiClient: SearchPageRepository
    
    init(api: SearchPageRepository) {
        self.apiClient = api
    }
    
    func noneService() {
        self.serviceOutput.onNext(.didFinish(result: true))
    }
    
    func searchForCityByName(value: String) {
        self.performApiSearchCity(value: value)
    }
    
    func performApiSearchCity(value: String, completion: (() -> Void)? = nil) {
        self.apiClient.searchListCitiesByName(value: value) { _, model, error in
            guard model != nil else {
                self.serviceOutput.onNext(.didFailed(error: error ?? "Failed to respond"))
                completion?()
                return
            }
            self.serviceOutput.onNext(.didFinish(result: model!))
            completion?()
        }
    }
}
