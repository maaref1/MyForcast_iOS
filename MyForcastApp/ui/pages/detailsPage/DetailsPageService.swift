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
    
    func noneService() {
        self.serviceOutput.onNext(.didFinish(result: true))
    }
}
