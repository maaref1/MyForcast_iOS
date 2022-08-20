//
//  MyVCGenerator.swift
//  MyForcastApp
//
//  Created by MacBook Air on 18/08/2022.
//

import Foundation
import UIKit

protocol VCGeneratorProtocol {
    func generateVC(typeVc: PageVCType, coordinator: MYCoordinator?) -> UIViewController?
}

/*
 This class is used to generate VCs initialising View, ViewModel, Model and Service
 */
class MyVCGenerator: VCGeneratorProtocol {
    
    var api: MyBaseRepository
    
    init(api: MyBaseRepository) {
        self.api = api
    }
    
    /*
     This function will generate VC by typeVC initialising View, ViewModel, Model, Service and Coordinator
     */
    func generateVC(typeVc: PageVCType, coordinator: MYCoordinator? = nil) -> UIViewController? {
        switch typeVc {
        case .homeVC:
            let mService = HomePageService(api: self.api)
            let model = HomePageModel()
            let mViewModel = HomePageVM(mService: mService,
                                        model: model)
            let pageVc = HomePageVC()
            pageVc.myCoordinator = coordinator
            pageVc.viewModel = mViewModel
            return pageVc
            
        case .searchVC:
            let mService = SearchPageService(api: self.api)
            let model = SearchPageModel()
            let mViewModel = SearchPageVM(mService: mService,
                                          model: model)
            let pageVc = SearchPageVC()
            pageVc.myCoordinator = coordinator
            pageVc.viewModel = mViewModel
            return pageVc
        case .detailsVC:
            
            let mService = DetailsPageService(api: self.api)
            let model = DetailsPageModel()
            let mViewModel = DetailsPageVM(mService: mService,
                                           model: model)
            let pageVc = DetailsPageVC()
            pageVc.myCoordinator = coordinator
            pageVc.viewModel = mViewModel
            return pageVc
        }
    }
}

enum PageVCType {
    case homeVC
    case searchVC
    case detailsVC
}
