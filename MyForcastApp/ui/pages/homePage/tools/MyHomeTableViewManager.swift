//
//  MyHomeTableViewManager.swift
//  MyForcastApp
//
//  Created by MacBook Air on 19/08/2022.
//

import Foundation
import UIKit

protocol MyHomeTableManagerProtocol: UITableViewDataSource,
                                     UITableViewDelegate {
}

class MyHomeTableManager: NSObject,
                          MyHomeTableManagerProtocol {
    
    var viewModel: HomePageVM
    
    init(viewModel: HomePageVM) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.getCountListFiltred()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.viewModel.getItemsByIndex(index: indexPath.row),
              let mCell = tableView.dequeueReusableCell(withIdentifier: WeatherHomeCell.nibName,
                                                        for: indexPath) as? WeatherHomeCell else {
            return UITableViewCell()
        }
        mCell.delegate = self
        mCell.initView(model: model)
        return mCell
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.viewModel.inputAction.onNext(.deleteItemAt(index: indexPath.row))
        default:
            break
        }
    }
}

extension MyHomeTableManager: WeatherItemCellDelegate {
    func onClickItemCell(model: WeatherResponse?) {
        guard model != nil else {
            return
        }
        print("item selected: \(model?.cityName ?? "")")
        self.viewModel.inputAction.onNext(.didSelectWeatherItem(model: model!))
    }
}
