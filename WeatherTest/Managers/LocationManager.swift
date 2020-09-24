//
//  LocationManager.swift
//  WeatherTest
//
//  Created by Oleg Frolov on 23.09.2020.
//

import Combine
import GoogleMaps
import GooglePlaces
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    
    let mapGoogleKey = "AIzaSyCG7unlxJ6_5hkeoqssGAxpiXIj0DjygSw"
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    private let locationManager = CLLocationManager()
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
        
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        GMSServices.provideAPIKey(mapGoogleKey)
        GMSPlacesClient.provideAPIKey(mapGoogleKey)
    }
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                AppSettings.shared.coordinates = address.coordinate
                
                if let city = address.locality {
                    AppSettings.shared.localCity = city
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print(location.coordinate)
        self.lastLocation = location
        reverseGeocodeCoordinate(coordinate: location.coordinate)
        manager.stopUpdatingLocation()
    }
    
}
