//
//  HomePageVC.swift
//
//

import UIKit
import RxSwift

class HomePageVC: BasePageVC {

    @IBOutlet weak var mBtnView: UIButton!
    @IBOutlet weak var mTextField: UITextField!
    
    var viewModel: HomePageVM!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOutputObservable()
        self.initSubViews()
    }
    
    // This function will be used to init actions of views with code
    func initSubViews() {
        self.initTapButtons()
        self.initTextFieldsChanged()
    }
    
    // This function will init textFields actions
    func initTextFieldsChanged() {
    }
    
    // This function will init buttons actions
    func initTapButtons() {
    }
    
    // This function will observe actions given by the ViewModel
    func initOutputObservable() {
        self.viewModel.outputAction.subscribe { result in
            switch result {
            case .next(let res):
                self.handleViewModelActions(action: res)
                break
            case .error(let err):
                print("error found: \(err)")
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    // This function will handle the actions sent by the VM
    func handleViewModelActions(action:  HomePageOutputResult) {
        switch action {
        case .loadingState(let state):
            print("setLoading to state: \(state)")
            if state {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            break
        case .didFinish(let result):
            print("handle result: \(result)")
            break

        case .didFailed(error: let error):
            print("show popup error: \(error.localizedCapitalized)")
        }
    }
}
