//
//  HomePageVCTest.swift
//  MyForcastAppTests
//
//  Created by MacBook Air on 21/08/2022.
//

import XCTest
@testable import MyForcastApp

class HomePageVCTest: XCTestCase {
    
    var vcPage = HomePageVC()
    
    override func setUp() async throws {
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        DispatchQueue.main.async {
            let mWindow = UIWindow()
            let myCoordinator = MYCoordinator(window: mWindow, typeVC: .homeVC)
            let apiRepo = MyBaseRepository(session: URLSession.shared)
            if let page = MyVCGenerator(api: apiRepo).generateVC(typeVc: .homeVC, coordinator: myCoordinator) as? HomePageVC {
                self.vcPage = page
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testPageVC() {
        vcPage.loadViewIfNeeded()
        let weatherModel = WeatherResponse(cityName: "", districtName: "")
        // let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        vcPage.handleViewModelActions(action: .didFinish(result: true))
        vcPage.handleViewModelActions(action: .didDeleteItemWeather)
        vcPage.handleViewModelActions(action: .didSelectWeatherItem(result: weatherModel))
        vcPage.handleViewModelActions(action: .didFailed(error: ""))
        vcPage.handleViewModelActions(action: .loadingState(state: true))
        vcPage.handleViewModelActions(action: .loadingState(state: false))
        
        vcPage.textFieldEditingDidChange(UITextField())
        vcPage.searchForKeyDelayed()
        vcPage.myCoordinator?.showSearchPageVCPopup(delegate: vcPage)
        vcPage.viewDidDisappear(false)
    }
    
    func testTableManager() {
        vcPage.loadViewIfNeeded()
        let modelCity = ResultCity(name: "",
                                   localNames: [:],
                                   lat: 0,
                                   lon: 0,
                                   country: "",
                                   state: "")
        
        self.vcPage.viewModel.model.listCities = [
            modelCity
        ]
        self.vcPage.tableManager.tableView(self.vcPage.mTableView,
                                           cellForRowAt: IndexPath(row: 0, section: 0))
        
        self.vcPage.tableManager.tableView?(self.vcPage.mTableView,
                                            commit: .delete,
                                            forRowAt: IndexPath(row: 0, section: 0))
        self.vcPage.tableManager.tableView?(self.vcPage.mTableView,
                                            commit: .insert,
                                            forRowAt: IndexPath(row: 0, section: 0))
        
        _ = self.vcPage.tableManager.tableView?(self.vcPage.mTableView,
                                                canEditRowAt: IndexPath(row: 0, section: 0))
        _ = self.vcPage.tableManager.tableView(self.vcPage.mTableView, numberOfRowsInSection: 0)
        
    }
    
    func testPageService() {
        let arrCity: [ResultCity] = [
            .init(name: "Paris", localNames: [:], lat: 0, lon: 0, country: "", state: "")
        ]
        self.vcPage.viewModel.mService.noneService()
        self.vcPage.viewModel.mService.loadWeatherForCities(cities: [])
        
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        self.vcPage.viewModel.mService.performGetWeatherFromApi(cities: arrCity) {
            expectation.fulfill()
        }
        self.vcPage.viewModel.mService.sendSavedListIfExists(cities: arrCity)
        wait(for: [expectation], timeout: 10)
    }
    
    func testRepository() {
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        self.vcPage.viewModel.mService.apiClient.callGetListWeathersLonLat(lon: "32",
                                                                           lat: "-4") { success, _, _ in
            XCTAssert(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
