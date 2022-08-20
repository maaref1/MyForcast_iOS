//
//  WeatherHomeCell.swift
//  MyForcastApp
//
//  Created by MacBook Air on 19/08/2022.
//

import UIKit
import SDWebImage

protocol WeatherItemCellDelegate: AnyObject {
    func onClickItemCell(model: WeatherResponse?)
}

class WeatherHomeCell: UITableViewCell {
    @IBOutlet weak var lbCityName: UILabel!
    @IBOutlet weak var lbDistrictName: UILabel!
    @IBOutlet weak var lbTempView: UILabel!
    @IBOutlet weak var lbTimeView: UILabel!
    @IBOutlet weak var imgIconWeather: UIImageView!
    
    static let nibName: String = "WeatherHomeCell"
    
    weak var delegate: WeatherItemCellDelegate?
    
    var model: WeatherResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initView(model: WeatherResponse) {
        self.model = model
        self.lbCityName.text = self.model?.cityName ?? ""
        self.lbDistrictName.text = self.model?.districtName ?? ""
        self.lbTempView.text = "\(self.model?.current?.temp ?? 0)° C"
        
        if let firstWeather = self.model?.current?.weather.first {
            let imgPath = MyConstants.pathImgIcon.replacingOccurrences(of: "**_**", with: firstWeather.icon)
            self.imgIconWeather.sd_setImage(with: URL(string: imgPath),
                                            placeholderImage: UIImage(named: ""),
                                            options: .waitStoreCache) {  _, _, _, _ in
            }
        }
        let windSpeed = model.current?.windSpeed ?? 0
        self.lbTimeView.text = "\(windSpeed) Km/h"
        
        self.contentView.setOnClickListener(target: self, action: #selector(onClickCell))
    }
    
    @objc func onClickCell(_ tap: UITapGestureRecognizer) {
        self.delegate?.onClickItemCell(model: self.model)
    }
    
    /*
     get Nib of Cell
     */
    static func nib() -> UINib {
        return UINib(nibName: WeatherHomeCell.nibName, bundle: nil)
    }
    
}
