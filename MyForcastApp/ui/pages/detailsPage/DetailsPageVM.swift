//
//  DetailsPageVM.swift
//
//

import Foundation
import RxSwift

class DetailsPageVM {
    
    var model: DetailsPageModel
    var mService: DetailsPageService
    
    var inputAction = PublishSubject<DetailsPageInputAction>()
    var outputAction = PublishSubject<DetailsPageOutputResult>()
    
    var disposeBag = DisposeBag()
    
    init(mService: DetailsPageService, model: DetailsPageModel) {
        self.mService = mService
        self.model = model
        
        self.initInputObservable()
        self.initServiceObservable()
    }
    
    // This function will be used to observe actions sent by the View
    func initInputObservable() {
        self.inputAction.subscribe { input in
            switch input {
            case .performAction:
                self.mService.noneService()

            }
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: disposeBag)
    }
    
    // This function will observe the response sent by Service
    func initServiceObservable() {
        self.mService.serviceOutput.subscribe { result in
            self.sendOutputResponse(result: result, error: nil)
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: disposeBag)
    }
    
    // This function will trait and send back data to View
    func sendOutputResponse(result: DetailsServiceOutputResult, error: Error?) {
        switch result {
        case .didFinish:
            break

        default:
            break
        }
        self.outputAction.onNext(.didFinish(result: true))
    }
}
