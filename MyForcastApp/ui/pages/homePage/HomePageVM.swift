//
//  HomePageVM.swift
//
//

import Foundation
import RxSwift

class HomePageVM {
    
    var model: HomePageModel
    var mService: HomePageService
    
    var inputAction = PublishSubject<HomePageInputAction>()
    var outputAction = PublishSubject<HomePageOutputResult>()
    
    var disposeBag = DisposeBag()
    
    init(mService: HomePageService, model: HomePageModel) {
        self.mService = mService
        self.model = model
    }
    
    // This function will init observables to send and receive data from View&ViewModel&Service
    func initObservablesActions() {
        self.initInputObservable()
        self.initServiceObservable()
    }
    
    // This function will be used to observe actions sent by the View
    func initInputObservable() {
        
        self.inputAction.subscribe { result in
            switch result {
            case.next(let input):
                switch input {
                case .performAction(let input):
                    print("will call service using this params: \(input)")
                    self.mService.noneService()
                    return
                }
                
            case .completed:
                print("completed")
                
            case .error(let err):
                print("error found : \(err)")

            }
        }.disposed(by: disposeBag)
    }
    
    // This function will observe the response sent by Service
    func initServiceObservable() {
        self.mService.serviceOutput.subscribe { result in
            switch result {
            case.next(let res):
                if let res = res as? HomePageOutputResult {
                    self.sendOutputResponse(result: res, error: nil)
                }

            case .completed:
                print("completed")

            case .error(let err):
                print("error found : \(err)")

            }
        }.disposed(by: disposeBag)
    }
    
    // This function will trait and send back data to View
    func sendOutputResponse(result: HomePageOutputResult, error: Error?) {
        switch result {
        case .didFinish(let result):
            print("result : \(result)")
            // save or do some treatment here

        default:
            break
        }
        self.outputAction.onNext(result)
    }
}
