//
//  LocationDataSource.swift
//  Weather
//
//  Created by nguyen huy on 1/8/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class LocationDataSource {
    let realm = try! Realm()
    var locations: Results<LocationModel>
    
    private init () {
        locations = realm.objects(LocationModel.self)
        var arr = Array(locations)
    }
       
    func loadLocations() -> Results<LocationModel>{
        locations = realm.objects(LocationModel.self)
        return locations
    }
    
    func updateUserLocation(_ location: CLLocation, completedListener: @escaping () -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            guard error == nil, let placemark = placemark else {
                completedListener()
                return
            }

            if placemark.count > 0 {
                let place = placemark[0]
                
                var userLocation = self.locations.filter { return $0.isUserLocation }.first
                var saved = false
                if(userLocation != nil) {
                    saved = self.realmWrite {
                        userLocation?.lat = location.coordinate.latitude
                        userLocation?.long = location.coordinate.longitude
                        userLocation?.name = place.name ?? ""
                        userLocation?.nation = place.country ?? ""
                    }
                }
                else {
                    userLocation = LocationModel()
                    userLocation!.lat = location.coordinate.latitude
                    userLocation!.long = location.coordinate.longitude
                    userLocation!.name = place.name ?? ""
                    userLocation!.nation = place.country ?? ""
                    userLocation!.isUserLocation = true
                    userLocation!.uuid = UUID().uuidString
                    saved = self.realmWrite {
                        self.realm.add(userLocation!)
                    }
                }
                
                if(saved){
                    completedListener()
                }
            }
        }
    }
    
    func addLocation(_ location: LocationModel) -> Bool {
        return realmWrite {
            realm.add(location)
        }
    }
    
    func deleteLocation(_ location: LocationModel) -> Bool {
        return realmWrite {
            realm.delete(location)
        }
    }
    
    func realmWrite(block: () -> Void) -> Bool {
        do {
            try realm.write {
                block()
            }
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    static let shared = LocationDataSource()
}
