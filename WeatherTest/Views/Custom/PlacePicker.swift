//
//  PlacePicker.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import UIKit
import SwiftUI
import GooglePlaces

struct PlacePicker: UIViewControllerRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var weatherManager: WeatherManager
    @Binding var places: [Place]
    
    let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                UInt(GMSPlaceField.placeID.rawValue) |
                UInt(GMSPlaceField.coordinate.rawValue) |
                GMSPlaceField.addressComponents.rawValue |
                GMSPlaceField.formattedAddress.rawValue)!
    
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        
        let autocompleteController = GMSAutocompleteViewController()
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                    UInt(GMSPlaceField.placeID.rawValue) |
                    UInt(GMSPlaceField.coordinate.rawValue) |
                    GMSPlaceField.addressComponents.rawValue |
                    GMSPlaceField.formattedAddress.rawValue)!
        
        autocompleteController.placeFields = fields

        let filter = GMSAutocompleteFilter()
        filter.type = .region
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = context.coordinator
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {

        var parent: PlacePicker
        
        init(_ parent: PlacePicker) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            
            DispatchQueue.main.async {
                self.parent.places.append(Place(name: place.name!, lat: place.coordinate.latitude, log: place.coordinate.longitude))
                self.parent.weatherManager.parsePlaceWeather(coordinates: place.coordinate, name: place.name!)
            }
            self.parent.presentationMode.wrappedValue.dismiss()
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

}
