//
//  ContentView.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    
    @State var showPlacePicker = false
    @State var places: [Place] = []
    @State var nextStep = false
    @State var showHistory = false
    
    var body: some View {
        VStack {
            List {
                selectDateSection
                selectPlaceSection
            }
            .listStyle(GroupedListStyle())
            
            if !weatherManager.sortedWeather.isEmpty {
                showHistoryButton
                Divider()
            }
            NavigationLink(destination: SelectTempView(), isActive: $nextStep, label: { selectWeatherButton })
                .disabled(places.isEmpty)
            Divider()
        }
        .navigationBarItems(trailing: EditButton().disabled(places.isEmpty))
        .navigationBarTitle(Text("Шаг 1"))
    }
    
    
    
    var selectDateSection: some View {
        Section(header: Text("Выберите даты отпуска"), footer: Text("Сервер отдает максимум 15 дней от текущего дня")) {
            DatePicker("Начало", selection: $weatherManager.startDate, in: Date()..., displayedComponents: .date)
            DatePicker("Конец", selection: $weatherManager.finishDate, in: weatherManager.startDate..., displayedComponents: .date)
        }
    }
    
    var selectPlaceSection: some View {
        Section(header: Text("Места для отдыха")) {
            Button(action: {
                showPlacePicker.toggle()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                    Spacer()
                }
            }.sheet(isPresented: $showPlacePicker) {
                PlacePicker(places: $places)
            }
            
            ForEach(places, id: \.name) { place in
                Text("\(place.name)")
            }.onDelete(perform: deleteItems)
        }
    }
    
    var selectWeatherButton: some View {
        Button(action: {
            weatherManager.parseLocalWeather()
            self.nextStep = true
        }, label: {
            Text("Выбрать погодные условия")
        }).disabled(places.isEmpty)
    }
    
    var showHistoryButton: some View {
        NavigationLink(destination:
                        ResultsView(
                            likeTemp: .constant(weatherManager.sortedWeather.first!.likeTemp),
                            likePrecip: .constant(weatherManager.sortedWeather.first!.likePrecip),
                            likeWind: .constant(weatherManager.sortedWeather.first!.likeWind)
                        ),isActive: $showHistory, label: {
            Button(action: {
                self.showHistory = true
            }, label: {
                Text("Последний результат")
            })
        })
        
    }
    
    func deleteItems(at offsets: IndexSet) {
        places.remove(atOffsets: offsets)
        
        places.forEach { place in
            weatherManager.placesWeather.removeAll { (sorted) -> Bool in
                place.name != sorted.name
            }
        }
    }
    
}
