//
//  SelectTempView.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import SwiftUI

struct SelectTempView: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    
    @State var nextStep = false
    @State var likeTemp: Double = 20
    @State var likePrecip: Double = 0
    @State var likeWind: Double = 0
    
    var body: some View {
        VStack {
            List {
                currentWeatherSection
                selectTempSection
                selectWindSection
                selectPrecipSection
            }
            .listStyle(GroupedListStyle())
            
            NavigationLink(destination: ResultsView(likeTemp: $likeTemp, likePrecip: $likePrecip, likeWind: $likeWind), isActive: $nextStep, label: { showVariantsButton })
        }
        .navigationBarTitle(Text("Шаг 2"))
    }
    
    var currentWeatherSection: some View {
        Section(header: Text("Сейчас в " + AppSettings.shared.localCity).font(.system(.headline))) {
            
            if (weatherManager.localWeather != nil) {
                VStack(alignment: .leading) {
                    Text("Температура \(self.weatherManager.localWeather!.curentTemp) º")
                    Text("Скорость ветра \(self.weatherManager.localWeather!.windSpeed) м/с")
                }.font(.system(.headline))
            }
        }
    }
    
    var selectTempSection: some View {
        Section(header: Text("Выберите желаемые погодные условия"), footer: Text("Температура (\(Int(likeTemp)) º)")) {
            Slider(value: $likeTemp, in: -30...40, step: 1).padding(.horizontal)
        }
    }
    
    var selectPrecipSection: some View {
        Section(footer: Text("Вероятность осадков (\(Int(likePrecip)) %)")) {
            Slider(value: $likePrecip, in: 0...100, step: 1).padding(.horizontal)
        }
    }
    
    var selectWindSection: some View {
        Section(footer: Text("Ветренность (\(Int(likeWind)) м/с)")) {
            Slider(value: $likeWind, in: 0...50, step: 1).padding(.horizontal)
        }
    }
    
    var showVariantsButton: some View {
        Button(action: {
            self.nextStep = true
            weatherManager.sort()
        }, label: {
            Text("Показать варианты")
        })
    }
    
}
