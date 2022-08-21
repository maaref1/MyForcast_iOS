//
//  LoginPageService.swift
//
//

import Foundation
import RxSwift

protocol DetailsPageServiceProtocol {
    func noneService()
}

class DetailsPageService: DetailsPageServiceProtocol {
    
    var serviceOutput = PublishSubject<DetailsServiceOutputResult>()
    
    var apiClient: SearchPageRepository
    
    init(api: SearchPageRepository) {
        self.apiClient = api
    }
    
    /*
     This function will represent an empty Service as default service with no action
     */
    func noneService() {
        self.serviceOutput.onNext(.didFinish(result: true))
    }
}
