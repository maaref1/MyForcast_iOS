//
//  DetailsPageVCTest.swift
//  MyForcastAppTests
//
//  Created by MacBook Air on 21/08/2022.
//

import XCTest
@testable import MyForcastApp

class DetailsPageVCTest: XCTestCase {
    
    var vcPage = DetailsPageVC()
    
    override func setUp() async throws {
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        DispatchQueue.main.async {
            let mWindow = UIWindow()
            let myCoordinator = MYCoordinator(window: mWindow, typeVC: .homeVC)
            let apiRepo = MyBaseRepository(session: URLSession.shared)
            if let page = MyVCGenerator(api: apiRepo).generateVC(typeVc: .detailsVC, coordinator: myCoordinator) as? DetailsPageVC {
                self.vcPage = page
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testPageVC() {
        vcPage.loadViewIfNeeded()
        let weatherModel = WeatherResponse(cityName: "",
                                           districtName: "",
                                           current: .init(weather: [
                                            .init(id: 0,
                                                  main: "",
                                                  weatherDescription: "",
                                                  icon: "")
                                           ]))
        // let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        vcPage.handleViewModelActions(action: .didFinish(result: true))
        vcPage.handleViewModelActions(action: .didFailed(error: ""))
        vcPage.handleViewModelActions(action: .loadingState(state: true))
        vcPage.handleViewModelActions(action: .loadingState(state: false))
        vcPage.initView(model: weatherModel)
        vcPage.onBackButtonClick(UITapGestureRecognizer())
        
        vcPage.myCoordinator?.redirectoToHome()
        vcPage.viewDidDisappear(false)
    }
    
    func testPageService() {
        let expectation = XCTestExpectation(description: MyConstants.msgInvalid)
        self.vcPage.viewModel.mService.noneService()
        /*self.vcPage.viewModel.mService.performGetWeatherFromApi(cities: []) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)*/
    }
}
