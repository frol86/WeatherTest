//
//  WeatherModel.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import Foundation

struct WeatherModel {
    var name: String
    var date: String
    var minTemp: Float
    var maxTemp: Float
    var precip: Int
    var minWind: Float
    var maxWind: Float
    var lat, lon: Double
    
    var midWind: Float
    var midTemp: Float
    var midPrecip: Int
    
    init?(weatherDataModel: WeatherDataModel?) {
        self.name = ""
        self.date = weatherDataModel?.observationTime.value ?? ""
        self.minTemp = weatherDataModel?.temp.first?.min?.value ?? 0
        self.maxTemp = weatherDataModel?.temp.last?.max?.value ?? 0
        self.precip = weatherDataModel?.precip.value ?? 0
        self.minWind = weatherDataModel?.windSpeed.first?.min?.value ?? 0
        self.maxWind = weatherDataModel?.windSpeed.last?.max?.value ?? 0
        self.lat = weatherDataModel?.lat ?? 0
        self.lon = weatherDataModel?.lon ?? 0
        self.midWind = (self.minWind + self.maxWind) / 2
        self.midTemp = (self.minTemp + self.maxTemp) / 2
        self.midPrecip = self.precip
    }
}
