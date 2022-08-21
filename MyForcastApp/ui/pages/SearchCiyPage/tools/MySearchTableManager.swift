//
//  MySearchTableManager.swift
//  MyForcastApp
//
//  Created by MacBook Air on 20/08/2022.
//

import Foundation
import UIKit

protocol MySearchTableManagerProtocol: UITableViewDataSource,
                                     UITableViewDelegate {
    func onClickCityItemCell(model: ResultCity?)
}

class MySearchTableManager: NSObject,
                            MySearchTableManagerProtocol {
    
    var viewModel: SearchPageVM
    
    init(viewModel: SearchPageVM) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.getListCount()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.viewModel.getItemsByIndex(index: indexPath.row),
              let mCell = tableView.dequeueReusableCell(withIdentifier: CityItemCell.nibName,
                                                        for: indexPath) as? CityItemCell else {
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
            print("delete this item at index: \(indexPath.row)")
        default:
            break
        }
    }
}

/*
 This extension will handle the cell's actions
 */
extension MySearchTableManager: CityItemCellDelegate {
    func onClickCityItemCell(model: ResultCity?) {
        guard model != nil else {
            return
        }
        self.viewModel.inputAction.onNext(.selectCityFromTable(model: model!))
    }
}
