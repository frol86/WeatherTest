//
//  PlaceModel.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 24.09.2020.
//

import Foundation

struct Place {
    let name: String
    let lat: Double
    let log: Double
    let temp: Int? = 0
    let precip: Int? = 0
    let windSpeed: Int? = 0
}

struct SortedWeather: Codable {
    var name: String
    var startDate: Date
    var finishDate: Date
    var midTemp: Int
    var midWind: Int
    var midPrecip: Int
    var likeTemp: Double = 20
    var likePrecip: Double = 0
    var likeWind: Double = 0
}
