//
//  CurrentWeatherDataModel.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 24.09.2020.
//

import Foundation

struct CurrentWeatherDataModel: Codable {
    let temp: Value
    let windSpeed: Value
    
    enum CodingKeys: String, CodingKey {
        case temp
        case windSpeed = "wind_speed"
    }

}

struct Value: Codable {
    let value: Float
}
