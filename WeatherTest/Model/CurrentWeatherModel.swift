//
//  CurrentWeatherModel.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 24.09.2020.
//

import Foundation

struct CurrentWeatherModel {
    let curentTemp: Int
    let windSpeed: Int
    
    init?(currentWeatherDataModel: CurrentWeatherDataModel?){
        curentTemp = Int(currentWeatherDataModel?.temp.value ?? 0)
        windSpeed = Int(currentWeatherDataModel?.windSpeed.value ?? 0)
    }
}
