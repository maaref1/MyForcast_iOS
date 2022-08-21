//
//  HomePageVC.swift
//
//

import UIKit
import RxSwift

class HomePageVC: BasePageVC {
    
    @IBOutlet weak var mBtnAddCity: UIImageView!
    @IBOutlet weak var mTxtSearchCity: UITextField!
    @IBOutlet weak var mTableView: UITableView!
    
    var viewModel: HomePageVM!
    
    var disposeBag = DisposeBag()
    
    // tableManager is used to handle all the tableView's actions
    lazy var tableManager: MyHomeTableManagerProtocol = {
        return MyHomeTableManager(viewModel: self.viewModel)
    }()
    
    // Timer used to wait for user to end editing to search the city
    var timer: Timer?
    // store the inserted value to search on APi when timer is done
    var searchValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOutputObservable()
        self.initSubViews()
        
        print("will init data list")
        self.viewModel.inputAction.onNext(HomePageInputAction.loadListCities)
    }
    
    // This function will be used to init actions of views with code
    func initSubViews() {
        self.initTapButtons()
        self.initTextFieldsChanged()
        self.initTableView()
    }
    
    // This function will init tableView config
    func initTableView() {
        self.mTableView.delegate = self.tableManager
        self.mTableView.dataSource = self.tableManager
        self.mTableView.register(WeatherHomeCell.nib(),
                                 forCellReuseIdentifier: WeatherHomeCell.nibName)
        
        self.mTableView.reloadData()
    }
    
    // This function will init textFields actions
    func initTextFieldsChanged() {
        self.mTxtSearchCity.delegate = self
        self.mTxtSearchCity.addTarget(self,
                                      action: #selector(textFieldEditingDidChange(_:)),
                                      for: .editingChanged)
        self.addDoneButtonExitKeyboard()
    }
    
    // This function will init buttons actions
    func initTapButtons() {
        self.mBtnAddCity.setOnClickListener(target: self,
                                            action: #selector(onClickAddCity))
    }
    
    // This function will observe actions given by the ViewModel
    func initOutputObservable() {
        self.viewModel.outputAction.subscribe { result in
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
    func handleViewModelActions(action: HomePageOutputResult) {
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
            
        case .didSelectWeatherItem(let model):
            self.myCoordinator?.redirectoToDetails(model: model)
            
        case .didDeleteItemWeather:
            self.viewModel.inputAction.onNext(.loadListCities)
            
        case .didFailed(error: let error):
            print("show popup error: \(error.localizedCapitalized)")
        }
    }
}

/*
 This extension to handle the page's clicks
 */
extension HomePageVC {
    @objc func onClickAddCity(_ tap: UITapGestureRecognizer) {
        // todo: show SearchVC to select a new city from APi
        print("add new city")
        self.myCoordinator?.showSearchPageVCPopup(delegate: self)
    }
}

/*
 This extension is to handle the TextField's changes
 */
extension HomePageVC: UITextFieldDelegate {
    
    /*
     This function will add a button Done to close keyboard
     */
    func addDoneButtonExitKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        mTxtSearchCity.inputAccessoryView = doneToolbar
    }
    
    /*
     This function will hide keyboard
     */
    @objc func doneButtonAction() {
        mTxtSearchCity.resignFirstResponder()
    }
    
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
        self.viewModel.inputAction.onNext(HomePageInputAction.searchForCity(name: self.searchValue))
    }
}

extension HomePageVC: SearchCityVCDelegate {
    func onSelectItemCity(city: ResultCity?) {
        print("new city added, reload table")
        self.myCoordinator?.setCurrentlyPresentedVC(vcPage: self)
        guard city != nil else {
            return
        }
        self.viewModel.inputAction.onNext(.loadListCities)
    }
}
