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
    
    func initInputObservable() {
        self.inputAction.subscribe { input in
            switch input {
            case .performAction(let inputs):
                self.mService.noneService()
                break
            }
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: disposeBag)
    }
    
    func initServiceObservable() {
        self.mService.serviceOutput.subscribe { result in
            self.sendOutputResponse(result: result, error: nil)
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: disposeBag)
    }
    
    func sendOutputResponse(result: DetailsServiceOutputResult, error: Error?) {
        switch result {
        case .didFinish(let result):
            break

        default:
            break
        }
        self.outputAction.onNext(.didFinish(result: true))
    }
}