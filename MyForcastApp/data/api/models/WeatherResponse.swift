//
//  WeatherResponse.swift
//  MyForcastApp
//
//  Created by MacBook Air on 19/08/2022.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    var cityName: String = ""
    var districtName: String = ""
    var lat, lon: Double?
    var timezone: String?
    var timezoneOffset: Int?
    var current: Current?
    var hourly: [Current]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly
    }
}

// MARK: - Current
struct Current: Codable {
    var valDt: Int?
    var sunrise, sunset: Int?
    var temp, feelsLike: Double?
    var pressure, humidity: Int?
    var dewPoint: Double?
    var clouds: Int?
    var visibility: Int?
    var windSpeed: Double?
    var windDeg: Int?
    var weather: [Weather]
    var windGust: Double?

    enum CodingKeys: String, CodingKey {
        case valDt = "dt"
        case sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
    }
}

// MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
