//
//  ContentView.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import SwiftUI

struct StartView: View {
    
    @State var startDate = Date()
    @State var finishDate = Date()
    
    @State var showPlacePicker = false
    @State var places: [String] = []
    @State var nextStep = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                List {
                    Section(header: Text("Select date")) {
                        DatePicker("Start", selection: $startDate, displayedComponents: .date)
                        DatePicker("Finish", selection: $finishDate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("Select Country or City")) {
                        Button(action: {
                            showPlacePicker.toggle()
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                Spacer()
                            }
                        }.sheet(isPresented: $showPlacePicker) {
                            PlacePicker(country: $places)
                        }
                        ForEach(places, id: \.self) { place in
                            Text("\(place)")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                
                
                Spacer()
                
            }
            .navigationBarTitle(Text("Step 1"))
            .navigationBarItems(trailing:
                
                NavigationLink(destination: SelectTempView(), isActive: $nextStep, label: {
                    Button(action: {
//                        if !self.places.isEmpty && self.text != "Select date" {
                        self.weatherManager.parseLocalWeather(place: AppSettings.shared.localCity, date: "2020-07-29")
                            self.nextStep = true
//                        }
                    }, label: {
                        Image(systemName: "arrow.right")
                    })
                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
