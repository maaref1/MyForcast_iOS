//
//  SearchPageVC.swift
//
//

import UIKit
import RxSwift

protocol SearchCityVCDelegate: AnyObject {
    func onSelectItemCity(city: ResultCity?)
}

class SearchPageVC: BasePageVC {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mTextFieldSearch: UITextField!
    
    var viewModel: SearchPageVM!
    
    var disposeBag = DisposeBag()
    
    weak var delegate: SearchCityVCDelegate?
    
    // Timer used to wait for user to end editing to search the city
    var timer: Timer?
    // store the inserted value to search on APi when timer is done
    var searchValue: String = ""
    
    // tableManager is used to handle all the tableView's actions
    lazy var tableManager: MySearchTableManagerProtocol = {
        return MySearchTableManager(viewModel: self.viewModel)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOutputObservable()
        self.initSubViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate?.onSelectItemCity(city: nil)
        super.viewDidDisappear(animated)
    }
    
    func initSubViews() {
        self.initTextFieldsChanged()
        self.initTableView()
    }
    
    // This function will init tableView config
    func initTableView() {
        self.mTableView.register(CityItemCell.nib(), forCellReuseIdentifier: CityItemCell.nibName)
        self.mTableView.delegate = self.tableManager
        self.mTableView.dataSource = self.tableManager
    }
    
    // This function will init textFields actions
    func initTextFieldsChanged() {        
        self.mTextFieldSearch.delegate = self
        self.mTextFieldSearch.addTarget(self,
                                        action: #selector(textFieldEditingDidChange(_:)),
                                        for: .editingChanged)
    }
    
    // This function will observe actions given by the ViewModel
    func initOutputObservable() {
        self.viewModel.outputAction.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { result in
                switch result {
                case .next(let res):
                    self.handleViewModelActions(action: res)
                    
                case .error(let err):
                    print("error found: \(err)")
                    
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    // This function will handle the actions sent by the VM
    func handleViewModelActions(action: SearchPageOutputResult) {
        switch action {
        case .loadingState(let state):
            print("setLoading to state: \(state)")
            if state {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            
        case .didFinish(let result):
            print("handle result: \(result)")
            DispatchQueue.main.async {
                self.mTableView.reloadData()
            }
        case.didCitySelected(let model):
            print("dissmiss and redirect to home: \(model)")
            DispatchQueue.main.async {
                self.delegate?.onSelectItemCity(city: model)
                self.myCoordinator?.dismissCurrentVC()
            }
            
        case .didFailed(error: let error):
            print("show popup error: \(error.localizedCapitalized)")
        }
    }
}

/*
 This extension is to handle the TextField's changes
 */
extension SearchPageVC: UITextFieldDelegate {
    
    /*
     This function is used to handle textChanging
     */
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        if let textField = sender as? UITextField {
            let value = textField.text ?? ""
            timer?.invalidate()
            self.searchValue = value
            timer = Timer.scheduledTimer(timeInterval: 0.5,
                                         target: self,
                                         selector: #selector(searchForKeyDelayed),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    /*
     This function will be executed after delay (0.5 seconds) of the last character written
     */
    @objc func searchForKeyDelayed() {
        print("search for city: \(self.searchValue)")
        self.viewModel.inputAction.onNext(.searchForCity(name: self.searchValue))
    }
    
}
