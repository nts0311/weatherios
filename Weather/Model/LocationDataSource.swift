//
//  LocationDataSource.swift
//  Weather
//
//  Created by nguyen huy on 1/8/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation
import RealmSwift

class LocationDataSource {
    let realm = try! Realm()
       
    func loadLocations() -> Results<LocationModel>{
        return realm.objects(LocationModel.self)
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
}
