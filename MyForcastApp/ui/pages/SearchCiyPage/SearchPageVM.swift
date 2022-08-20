//
//  SearchPageVM.swift
//
//

import Foundation
import RxSwift

class SearchPageVM {
    
    var model: SearchPageModel
    var mService: SearchPageService
    
    var inputAction = PublishSubject<SearchPageInputAction>()
    var outputAction = PublishSubject<SearchPageOutputResult>()
    
    var disposeBag = DisposeBag()
    
    init(mService: SearchPageService, model: SearchPageModel) {
        self.mService = mService
        self.model = model
        
        self.initInputObservable()
        self.initServiceObservable()
    }
    
    func initInputObservable() {
        self.inputAction.subscribe { input in
            switch input {
            case .searchForCity(let name):
                self.mService.searchForCityByName(value: name)
            case .selectCityFromTable(let selectedCity):
                self.saveCityAndRedirect(city: selectedCity)
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
    
    func sendOutputResponse(result: SearchServiceOutputResult, error: Error?) {
        switch result {
        case .didFinish(let result):
            print("result = \(result)")
            if let listCities = result as? CityLocationResponse {
                self.model.listCities = listCities
            }
            self.outputAction.onNext(.didFinish(result: result))
            
        case .didFailed(let error):
            print("error found, show popup : \(error)")
            self.outputAction.onNext(.didFailed(error: error))
            
        case .loadingState(let state):
            print("loading visible : \(state)")
            self.outputAction.onNext(.loadingState(state: state))
            
        }
    }
    
    func saveCityAndRedirect(city: ResultCity) {
        print("did select city to add : \(city)")
        CoreDataManager.shared.addCityToLocalList(city: city)
        self.outputAction.onNext(.didCitySelected(model: city))
    }
}

/*
 This extension to handle displayed list weathers
 */
extension SearchPageVM {
    func getItemsByIndex(index: Int) -> ResultCity? {
        guard index >= 0 && index < self.model.listCities.count else {
            return nil
        }
        return self.model.listCities[index]
    }
    
    func getListCount() -> Int {
        return self.model.listCities.count
    }
    
    func getListCities() -> [ResultCity] {
        return self.model.listCities
    }
}
