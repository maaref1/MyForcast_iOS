//
//  DetailsPageVC.swift
//
//

import UIKit
import RxSwift

class DetailsPageVC: BasePageVC {

    @IBOutlet weak var imgIconWeather: UIImageView!
    @IBOutlet weak var lbCityName: UILabel!
    @IBOutlet weak var lbDistrictName: UILabel!
    @IBOutlet weak var lbTempView: UILabel!
    @IBOutlet weak var lbWindView: UILabel!
    
    @IBOutlet weak var lbHumidityView: UILabel!
    @IBOutlet weak var lbPressureView: UILabel!
    @IBOutlet weak var lbCloudView: UILabel!
    
    @IBOutlet weak var imgBackBtn: UIImageView!
    
    var viewModel: DetailsPageVM!
    var disposeBag = DisposeBag()
    
    var model: WeatherResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOutputObservable()
        self.initSubViews()
    }
    
    // This function will be used to init actions of views with code
    func initSubViews() {
        self.initTapButtons()
        self.initView(model: self.model)
    }
    
    // This function will init buttons actions
    func initTapButtons() {
        self.imgBackBtn.setOnClickListener(target: self, action: #selector(onBackButtonClick))
    }
    
    // This function will fill the weather's data into the page's views
    func initView(model: WeatherResponse?) {
        guard let model = model,
              let cityWeather = model.current else {
            return
        }
        self.model = model
        self.lbCityName.text = self.model?.cityName ?? ""
        self.lbDistrictName.text = self.model?.districtName ?? ""
        self.lbTempView.text = "\(cityWeather.temp ?? 0)° C"
        
        let windSpeed = model.current?.windSpeed ?? 0
        
        self.lbWindView.text = "\(windSpeed) mph"
        self.lbHumidityView.text = "\(cityWeather.humidity ?? 0) %"
        self.lbPressureView.text = "\(cityWeather.pressure ?? 0) mb"
        self.lbCloudView.text = "\(cityWeather.clouds ?? 0) %"
        
        if let firstWeather = cityWeather.weather.first {
            let iconName = firstWeather.icon ?? ""
            let imgPath = MyConstants.pathImgIcon.replacingOccurrences(of: "**_**", with: iconName)
            
            let img = UIImage(named: iconName)
            guard let url = URL(string: imgPath),
                  img == nil else {
                self.imgIconWeather.image = img
                return
            }
            self.imgIconWeather.load(url: url)
        }
    }
    
    // This function will handle the click on the backButton
    @objc func onBackButtonClick(_ tap: UITapGestureRecognizer) {
        self.myCoordinator?.dismissCurrentVC()
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
    func handleViewModelActions(action: DetailsPageOutputResult) {
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
                // self.mTableView.reloadData()
            }
            
        case .didFailed(error: let error):
            print("show popup error: \(error.localizedCapitalized)")
        }
    }
}
