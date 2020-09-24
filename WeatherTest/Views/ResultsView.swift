//
//  ResultsView.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 24.09.2020.
//

import SwiftUI

struct ResultsView: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    
    @Binding var likeTemp: Double
    @Binding var likePrecip: Double
    @Binding var likeWind: Double
    
    @State var sortBy = 0
    
    var weatherArray: [SortedWeather] {
        switch sortBy {
        case 0:
            return weatherManager.sortedWeather.sorted { (p1, p2) -> Bool in
                p1.midTemp > p2.midTemp
            }
        case 1:
            return weatherManager.sortedWeather.sorted { (p1, p2) -> Bool in
                p1.midWind > p2.midWind
            }
        case 2:
            return weatherManager.sortedWeather.sorted { (p1, p2) -> Bool in
                p1.midPrecip > p2.midPrecip
            }
        default:
            break
        }
        return weatherManager.sortedWeather
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            segmentPickerView
            placesListView
        }
        .navigationBarTitle(Text("Варианты для отпуска"), displayMode: .inline)
        .navigationBarItems(trailing: shareButton)
        
    }
    
    var headerView: some View {
        Text("Средние показатели погоды на период с \(weatherArray.first!.startDate.toDm()) по \(weatherArray.first!.finishDate.toDm()) ").padding()
    }
    
    var segmentPickerView: some View {
        Picker("", selection: $sortBy) {
            Text("Температура").tag(0)
            Text("Ветер").tag(1)
            Text("Осадки").tag(2)
        }
        .padding([.horizontal, .bottom])
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var placesListView: some View {
        List {
            ForEach(weatherArray, id: \.name) { place in
                Section(header: Text(place.name).foregroundColor(place.name == AppSettings.shared.localCity ? .blue : .black)) {
                    VStack(alignment: .leading) {
                        Text("Температура \(place.midTemp) º")
                        Text("Скорость ветра \(place.midWind) м/с")
                        Text("Вероятность осадков \(place.midPrecip) %")
                    }
                    .font(.system(.headline))
                    .foregroundColor(place.name == AppSettings.shared.localCity ? .blue : .black)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    var shareButton: some View {
        Button(action: {
            var places = ""
            weatherArray.map {$0.name}.forEach {
                places += "\n\($0)"
            }
            self.share(items: ["Вырианты для отпуска: \(places)"])
        }, label: {
            Image(systemName: "square.and.arrow.up")
        })
    }
    
    
    func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil){
        guard let source = UIApplication.shared.windows.last?.rootViewController else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        vc.excludedActivityTypes = excludedActivityTypes
        vc.popoverPresentationController?.sourceView = source.view
        source.present(vc, animated: true)
    }
}
