//
//  WeatherTestApp.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import SwiftUI


@main
struct WeatherTestApp: App {
    
    var locationManager = LocationManager()
    let weatherManager = WeatherManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .onAppear() {
                do {
                    weatherManager.sortedWeather = try UserDefaults.standard.getObject(forKey: "SortedWeather", castTo: [SortedWeather].self)
                    
                } catch {
                    print("userDefaults: ", error.localizedDescription)
                }
            }
            .environmentObject(weatherManager)
        }
    }
}

