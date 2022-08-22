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
    
    /*
     This function will fill weather's data to the cell's view
     */
    func initView(model: WeatherResponse) {
        self.model = model
        self.lbCityName.text = self.model?.cityName ?? ""
        self.lbDistrictName.text = self.model?.districtName ?? ""
        self.lbTempView.text = "\(self.model?.current?.temp ?? 0)° C"
        
        let windSpeed = model.current?.windSpeed ?? 0
        self.lbTimeView.text = "\(windSpeed) mph"
        
        self.contentView.setOnClickListener(target: self, action: #selector(onClickCell))
        
        if let firstWeather = self.model?.current?.weather.first {
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
    
    /*
     This function will handle click on cell content
     */
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
