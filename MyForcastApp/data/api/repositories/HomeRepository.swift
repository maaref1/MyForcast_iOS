//
//  HomeRepository.swift
//  MyForcastApp
//
//  Created by MacBook Air on 18/08/2022.
//

import Foundation

protocol HomePageRepository {
    func getListWeather()
}

extension MyBaseRepository: HomePageRepository {
    func getListWeather() {
        print("call api for home")
    }
}
