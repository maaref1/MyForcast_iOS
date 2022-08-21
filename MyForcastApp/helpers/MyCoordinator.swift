//
//  MyCoordinator.swift
//  MyForcastApp
//
//  Created by MacBook Air on 18/08/2022.
//

import Foundation
import UIKit

/*
 This class is used to coordinate and redirect between pages of the app
 */
struct MYCoordinator {
    private var api: MyBaseRepository
    private var window: UIWindow
    private var vcGenerator: VCGeneratorProtocol
    private var currentPresentedVC: UIViewController?
    
    init(window: UIWindow, typeVC: PageVCType) {
        self.api = MyBaseRepository(session: URLSession.shared)
        
        self.vcGenerator = MyVCGenerator(api: api)
        self.window = window
        if let vcPage = vcGenerator.generateVC(typeVc: typeVC, coordinator: self) as? HomePageVC {
            self.currentPresentedVC = vcPage
            self.window.rootViewController = vcPage
        }
    }
    
    /*
     this function will change the currently displayed VC saved instance
     */
    mutating func setCurrentlyPresentedVC(vcPage: UIViewController) {
        self.currentPresentedVC = vcPage
    }
    
    /*
     This function will dismiss the currently presented VC
     */
    func dismissCurrentVC() {
        self.currentPresentedVC?.dismiss(animated: true)
    }
    
    /*
     This function to redirect to HomePage
     */
    mutating func redirectoToHome() {
        guard let vcPage = vcGenerator.generateVC(typeVc: .homeVC,
                                                  coordinator: self) as? HomePageVC else {
            return
        }
        vcPage.modalPresentationStyle = .fullScreen
        vcPage.modalTransitionStyle = .coverVertical
        self.currentPresentedVC?.present(vcPage, animated: false)
        self.currentPresentedVC = vcPage
    }
    
    /*
     This function to redirect to DetailsPage
     */
    mutating func redirectoToDetails(model: WeatherResponse) {
        guard let vcPage = vcGenerator.generateVC(typeVc: .detailsVC,
                                                  coordinator: self) as? DetailsPageVC else {
            return
        }
        vcPage.modalPresentationStyle = .fullScreen
        vcPage.modalTransitionStyle = .coverVertical
        vcPage.model = model
        self.currentPresentedVC?.present(vcPage, animated: false)
        self.currentPresentedVC = vcPage
    }
    
    /*
     This function to popup SearchPageVC
     */
    mutating func showSearchPageVCPopup(delegate: SearchCityVCDelegate) {
        guard let vcPage = vcGenerator.generateVC(typeVc: .searchVC,
                                                  coordinator: self) as? SearchPageVC else {
            return
        }
        vcPage.modalPresentationStyle = .fullScreen
        vcPage.modalTransitionStyle = .coverVertical
        
        vcPage.modalTransitionStyle = .coverVertical
        vcPage.modalPresentationStyle = .popover
        vcPage.delegate = delegate
        self.currentPresentedVC?.present(vcPage, animated: true)
        self.currentPresentedVC = vcPage
    }
}
