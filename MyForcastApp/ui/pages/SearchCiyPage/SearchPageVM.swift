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
    
    // This function will be used to observe actions sent by the View
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
    
    // This function will observe the response sent by Service
    func initServiceObservable() {
        self.mService.serviceOutput.subscribe { result in
            self.sendOutputResponse(result: result, error: nil)
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: disposeBag)
    }
    
    // This function will trait and send back data to View
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
    
    // This function will save selected city to DB and redirect to home to reload List
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
    // This function will get item city by index
    func getItemsByIndex(index: Int) -> ResultCity? {
        guard index >= 0 && index < self.model.listCities.count else {
            return nil
        }
        return self.model.listCities[index]
    }
    
    // This function will get count list cities
    func getListCount() -> Int {
        return self.model.listCities.count
    }
    
    // This function will get the list of cities
    func getListCities() -> [ResultCity] {
        return self.model.listCities
    }
}
