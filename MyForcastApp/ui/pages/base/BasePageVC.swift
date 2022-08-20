//
//  BasePageVC.swift
//  MyForcastApp
//
//  Created by MacBook Air on 18/08/2022.
//

import Foundation
import UIKit

class BasePageVC: UIViewController {
    
    var myCoordinator: MYCoordinator?
    
    func showLoading(containerView: UIView? = nil) {
        print("show loading")
    }
    
    func hideLoading() {
        print("hide loading")
    }
    
    func configureVC(api: MyBaseRepository) -> UIViewController {
        return self
    }
}
