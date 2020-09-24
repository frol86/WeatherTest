//
//  WeatherDataModel.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 24.09.2020.
//

import Foundation

struct WeatherDataModel: Codable {
    
    let temp: [TempArray]
    let precip: Precip
    let windSpeed: [WindArray]
    let observationTime: ObservationTime
    let lat, lon: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case precip = "precipitation_probability"
        case windSpeed = "wind_speed"
        case observationTime = "observation_time"
        case lat
        case lon
    }
    
}

struct TempArray: Codable {
    let min: Min?
    let max: Max?
}

struct Min: Codable {
    let value: Float
}

struct Max: Codable {
    let value: Float
}

struct Precip: Codable {
    let value: Int
}

struct WindArray: Codable {
    let min: Min?
    let max: Max?
}

struct WeatherCode: Codable {
    let value: String
}

struct ObservationTime: Codable {
    let value: String
}
