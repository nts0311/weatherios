//
//  WeatherModel.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let lat, lon: Double
    let timezone: String
    let current: HourlyWeather
    let hourly: [HourlyWeather]
    let daily: [Daily]
}

// MARK: - Current
struct HourlyWeather: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feels_like: Double
    let pressure, humidity: Int
    let dew_point, uvi: Double
    let clouds, visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double?
    let weather: [Weather]
    let pop: Double?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    func getConditionName() -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moon_phase: Double
    let temp: Temp
    let pressure, humidity: Int
    let dew_point, wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double?
    let weather: [Weather]
    let clouds: Int
    let pop: Double?
    let uvi: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

