//
//  SearchPageVCTest.swift
//  MyForcastAppTests
//
//  Created by MacBook Air on 21/08/2022.
//

import XCTest
@testable import MyForcastApp

class SearchPageVCTest: XCTestCase {
    
    var vcPage = SearchPageVC()
    
    override func setUp() async throws {
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        DispatchQueue.main.async {
            let mWindow = UIWindow()
            let myCoordinator = MYCoordinator(window: mWindow, typeVC: .homeVC)
            let apiRepo = MyBaseRepository(session: URLSession.shared)
            if let page = MyVCGenerator(api: apiRepo).generateVC(typeVc: .searchVC, coordinator: myCoordinator) as? SearchPageVC {
                self.vcPage = page
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testPageVC() {
        vcPage.loadViewIfNeeded()
        // let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        vcPage.handleViewModelActions(action: .didFinish(result: true))
        vcPage.handleViewModelActions(action: .didCitySelected(model: .init(name: "",
                                                                            localNames: [:],
                                                                            lat: 0,
                                                                            lon: 0,
                                                                            country: "",
                                                                            state: "")))
        vcPage.handleViewModelActions(action: .didFailed(error: ""))
        vcPage.handleViewModelActions(action: .loadingState(state: true))
        vcPage.handleViewModelActions(action: .loadingState(state: false))
        
        vcPage.textFieldEditingDidChange(UITextField())
        vcPage.searchForKeyDelayed()
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
        
        self.vcPage.tableManager.onClickCityItemCell(model: modelCity)
    }
    
    func testPageService() {
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        self.vcPage.viewModel.mService.searchForCityByName(value: "")
        self.vcPage.viewModel.mService.performApiSearchCity(value: "Paris") {
            expectation.fulfill()
        }
        self.vcPage.viewModel.mService.noneService()
        wait(for: [expectation], timeout: 10)
    }
}
