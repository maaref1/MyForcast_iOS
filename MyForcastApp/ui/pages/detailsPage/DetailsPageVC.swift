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
    
    var viewModel: DetailsPageVM!
    var disposeBag = DisposeBag()
    
    var model: WeatherResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOutputObservable()
        self.initSubViews()
        
        self.initView(model: self.model)
    }

    func initView(model: WeatherResponse?) {
        guard let model = model,
              let cityWeather = model.current else {
            return
        }
        self.model = model
        self.lbCityName.text = self.model?.cityName ?? ""
        self.lbDistrictName.text = self.model?.districtName ?? ""
        self.lbTempView.text = "\(cityWeather.temp)° C"
        
        if let firstWeather = cityWeather.weather.first {
            let imgPath = MyConstants.pathImgIcon.replacingOccurrences(of: "**_**", with: firstWeather.icon)
            self.imgIconWeather.sd_setImage(with: URL(string: imgPath),
                                            placeholderImage: UIImage(named: ""),
                                            options: .waitStoreCache) {  _, _, _, _ in
            }
        }
        let windSpeed = model.current?.windSpeed ?? 0
        
        self.lbWindView.text = "\(windSpeed) mph"
        self.lbHumidityView.text = "\(cityWeather.humidity) %"
        self.lbPressureView.text = "\(cityWeather.pressure) mb"
        self.lbCloudView.text = "\(cityWeather.clouds) %"
    }
    
    func initSubViews() {
        self.initTapButtons()
        self.initTextFieldsChanged()
    }
    
    func initTextFieldsChanged() {
    }
    
    func initTapButtons() {
    }
    
    @IBAction func onBackButtonClick(_ sender: UIButton) {
        self.myCoordinator?.dismissCurrentVC()
    }
    
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
