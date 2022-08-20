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
        self.initObservablesActions()
    }
    
    // This function will init observables to send and receive data from View&ViewModel&Service
    func initObservablesActions() {
        self.initInputObservable()
        self.initServiceObservable()
    }
    
    // This function will be used to observe actions sent by the View
    func initInputObservable() {
      
        self.inputAction.subscribe { input in
            switch input {
            case .loadListCities:
                self.loadListCitiesFromLocalDB()
                self.mService.loadWeatherForCities(cities: self.model.listCities)
                
            case .searchForCity(let name):
                self.filterListByCityName(name: name)
                
            case .didSelectWeatherItem(let model):
                self.outputAction.onNext(.didSelectWeatherItem(result: model))
                
            case .deleteItemAt(let index):
                self.removeItemAtIndex(index: index)
                
            }
        } onError: { _ in
            print("on error")
        } onCompleted: {
            print("completed")
        }.disposed(by: disposeBag)

    }
    
    // This function will observe the response sent by Service
    func initServiceObservable() {
        self.mService.serviceOutput.subscribe { res in
            if let res = res as? HomePageOutputResult {
                self.sendOutputResponse(result: res, error: nil)
            }
        } onError: { _ in
        } onCompleted: {
        }.disposed(by: disposeBag)
    }
    
    // This function will trait and send back data to View
    func sendOutputResponse(result: HomePageOutputResult, error: Error?) {
        switch result {
        case .didFinish(let result):
            if let listWeathers = result as? [WeatherResponse] {
                print("save this list and reload tableView : \(listWeathers.count)")
                self.model.fullListForcast = listWeathers
                self.model.filtredList = listWeathers
            }
            // save or do some treatment here

        default:
            break
        }
        self.outputAction.onNext(result)
    }
}

/*
 This extension to handle displayed list weathers
 */
extension HomePageVM {
    func getItemsByIndex(index: Int) -> WeatherResponse? {
        guard index >= 0 && index < self.model.filtredList.count else {
            return nil
        }
        return self.model.filtredList[index]
    }
    
    func getCountListFiltred() -> Int {
        return self.model.filtredList.count
    }
    
    func getFiltredList() -> [WeatherResponse] {
        return self.model.filtredList
    }
    
    func filterListByCityName(name: String) {
        guard !name.isEmpty else {
            self.model.filtredList = self.model.fullListForcast
            self.outputAction.onNext(.didFinish(result: true))
            return
        }
        let value = name.lowercased()
        self.model.filtredList = self.model.fullListForcast.filter({
            $0.cityName.lowercased().contains(value) || $0.districtName.lowercased().contains(value)
        })
        self.outputAction.onNext(.didFinish(result: true))
    }
}

/*
 This extension to manage cities add, edit, remove from localDB
 */
extension HomePageVM {
    func removeItemAtIndex(index: Int) {
        guard let item = self.getItemsByIndex(index: index) else {
            return
        }
        CoreDataManager.shared.removeCityFromLocalList(name: item.cityName)
        self.outputAction.onNext(.didDeleteItemWeather)
    }
    
    func loadListCitiesFromLocalDB() {
        self.model.listCities = []
        let listLocal = CoreDataManager.shared.getListCities()
        self.model.listCities = listLocal
    }
}
