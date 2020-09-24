//
//  WeatherManager.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import GoogleMaps
import SwiftUI

class WeatherManager: ObservableObject {
    
    let dataFetcher: DataFetcher
    
    @Published var localWeather: CurrentWeatherModel?
    @Published var placesWeather: [WeatherModel] = []
    @Published var sortedWeather: [SortedWeather] = []
    
    @Published var startDate = Date()
    @Published var finishDate = Date()
    
    init(dataFetcher: DataFetcher = DataFetcherService()) {
        self.dataFetcher = dataFetcher
    }
    
    
    func parseLocalWeather() {
        
        let app = AppSettings.shared
        let urlString = app.currentWeatherUrlString + "&lat=\(app.coordinates.latitude)" + "&lon=\(app.coordinates.longitude)"
        print(urlString)
        dataFetcher.fetchJSONData(urlString: urlString) { (data) in
            self.localWeather = CurrentWeatherModel(currentWeatherDataModel: data)
        }
    }
    
    func parsePlaceWeather(coordinates: CLLocationCoordinate2D, name: String) {
        
        getPlaces(coordinates: coordinates) { (data) in
            data?.forEach({ (weather) in
                var record = WeatherModel(weatherDataModel: weather)!
                record.name = name
                self.placesWeather.append(record)
            })
        }
    }
    
    func getPlaces(coordinates: CLLocationCoordinate2D, completion: @escaping ([WeatherDataModel]?) -> () ) {
        
        let app = AppSettings.shared
        let urlString = app.placeWeatherUrlString + "&lat=\(coordinates.latitude)" + "&lon=\(coordinates.longitude)" + "&start_time=\(startDate.toYmd())T23:59:00Z&end_time=\(finishDate.toYmd())T15:00:00Z"
        dataFetcher.fetchJSONData(urlString: urlString, response: completion)
    }
    
    
    func sort() {
        sortedWeather.removeAll()
        placesWeather.forEach { (record) in
            if !sortedWeather.contains(where: { (sorted) -> Bool in
                sorted.name == record.name
            }){
                sortedWeather.append(SortedWeather(name: record.name, startDate: startDate, finishDate: finishDate, midTemp: 0, midWind: 0, midPrecip: 0))
            }
        }
        
        for (i,sorted) in sortedWeather.enumerated() {
            var count = 0
            var temp = 0
            var wind = 0
            var precip = 0
            placesWeather.forEach {
                if sorted.name == $0.name {
                    count += 1
                    temp += Int($0.midTemp.rounded())
                    wind += Int($0.midWind.rounded())
                    precip += $0.midPrecip
                }
                if count != 0 {
                    sortedWeather[i].midTemp = temp / count
                    sortedWeather[i].midWind = wind / count
                    sortedWeather[i].midPrecip = precip / count
                }
            }
        }
        
        sortedWeather.append(SortedWeather(name: AppSettings.shared.localCity, startDate: startDate, finishDate: finishDate, midTemp: localWeather?.curentTemp ?? 0, midWind: localWeather?.windSpeed ?? 0, midPrecip: 0))
        
        setToLocal()
    }
    
    private func setToLocal() {
        do {
            try UserDefaults.standard.setObject(self.sortedWeather, forKey: "SortedWeather")
        } catch {
            print("userDefaults: ", error.localizedDescription)
        }
    }
    
}

