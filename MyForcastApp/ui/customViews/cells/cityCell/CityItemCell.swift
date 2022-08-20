//
//  CityItemCell.swift
//  MyForcastApp
//
//  Created by MacBook Air on 20/08/2022.
//

import UIKit

protocol CityItemCellDelegate: AnyObject {
    func onClickItemCell(model: ResultCity?)
}

class CityItemCell: UITableViewCell {
    static let nibName: String = "CityItemCell"
    
    @IBOutlet weak var lbNameCity: UILabel!
    @IBOutlet weak var lbNameDesc: UILabel!
    
    weak var delegate: CityItemCellDelegate?

    var model: ResultCity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initView(model: ResultCity) {
        self.model = model
        self.lbNameCity.text = "\(model.name) [\(model.country)]"
        self.lbNameDesc.text = model.state
        
        self.contentView.setOnClickListener(target: self, action: #selector(onClickCell))
    }
    
    @objc func onClickCell(_ tap: UITapGestureRecognizer) {
        self.delegate?.onClickItemCell(model: self.model)
    }
    
    /*
        get Nib of Cell
     */
    static func nib() -> UINib {
        return UINib(nibName: CityItemCell.nibName, bundle: nil)
    }
}
