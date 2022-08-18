//
//  LoginPageService.swift
//
//

import Foundation
import RxSwift

protocol HomePageServiceProtocol {
    func noneService()
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
}
