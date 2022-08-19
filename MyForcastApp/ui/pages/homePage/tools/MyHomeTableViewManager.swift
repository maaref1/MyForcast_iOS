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
    func setListData(list: [Any])
}

class MyHomeTableManager: NSObject,
                          MyHomeTableManagerProtocol {
    
    var listItems: [Any] = []
    
    func setListData(list: [Any]) {
        self.listItems = list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.listItems.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mCell = tableView.dequeueReusableCell(withIdentifier: WeatherHomeCell.nibName,
                                                        for: indexPath) as? WeatherHomeCell else {
            return UITableViewCell()
        }
        // mCell.initView(model: <#T##WeatherResponse#>)
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
