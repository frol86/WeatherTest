//
//  AppSettings.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import GoogleMaps

final class AppSettings {
    
    static let shared = AppSettings()
    
    private init() {}
    
    private let key = "9B7oBB14RIguPFW1Df5gSXTZ3dH9q9gB"
    
    var currentWeatherUrlString: String { "https://api.climacell.co/v3/weather/realtime?apikey=\(key)&unit_system=si&fields=temp,wind_speed"
    }
    
    var placeWeatherUrlString: String { "https://api.climacell.co/v3/weather/forecast/daily?apikey=\(key)&unit_system=si&fields=temp,wind_speed,precipitation_probability"
    }
    
    
    var localCity = ""
    var coordinates: CLLocationCoordinate2D!
}
