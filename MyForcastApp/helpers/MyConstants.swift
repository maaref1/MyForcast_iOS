//
//  MyConstants.swift
//  MyForcastApp
//
//  Created by MacBook Air on 19/08/2022.
//

import Foundation

class MyConstants {
    static let apiWeatherId         = "5d39406e9c6a057a30818ebece1667da"
    
    static let baseUrl              = "https://api.openweathermap.org/"
    static let pathImgIcon          = "https://openweathermap.org/img/wn/**_**@2x.png"
    static let getListWeathersPath  = baseUrl + "data/2.5/onecall"
    
    static let pathSearchCity       = baseUrl + "geo/1.0/direct"
    
    static let msgErrorServer       = "Erreur Server"
    
    static let latKey               = "lat"
    static let lonKey               = "lon"
    static let apiIdKey             = "appid"
    static let unitsKey             = "units"
    
    static let citySearchKey        = "q"
    static let limitSearchKey       = "limit"
}
