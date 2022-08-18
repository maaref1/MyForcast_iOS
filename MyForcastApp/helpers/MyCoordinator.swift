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
        if let vc = vcGenerator.generateVC(typeVc: typeVC, coordinator: self) as? HomePageVC {
            vc.myCoordinator = self
            self.currentPresentedVC = vc
            self.window.rootViewController = vc
        }
    }
    
    /*
     This function to redirect to HomePage
     */
    func redirectoToHome() {
        guard let vc = vcGenerator.generateVC(typeVc: .homeVC, coordinator: self) as? HomePageVC else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.currentPresentedVC?.present(vc, animated: false)
    }
}
