//
//  WeatherRepo.swift
//  Weather
//
//  Created by nguyen huy on 1/10/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherRepo {
    let remoteSource = WeatherRemoteDataSource()
    let realm = try! Realm()
    var fetched: [String: Bool] = [:]
    var isFetching = false
    
    func getWeatherData(location: LocationModel, forceRefresh: Bool = false, onComplete: @escaping (WeatherModel?) -> Void) {
        if(isFetching) {return}
        
        isFetching = true
        
        if(fetched[location.uuid] != true){
            fetchRemoteData(location: location, onComplete: onComplete)
        }
        else {
            if(forceRefresh){
                fetchRemoteData(location: location, onComplete: onComplete)
            }
            else {
                fetchCachedData(location: location, onComplete: onComplete)
            }
        }
    }
    
    private func fetchRemoteData(location: LocationModel, onComplete: @escaping (WeatherModel?) -> Void){
        print("fetch:remote")
        remoteSource.fetchData(lat: location.lat, long: location.long){data, error in
            guard let data = data, error == nil else {
                print(error)
                onComplete(nil)
                return
            }
            
            DispatchQueue.main.async {
                //success fetch new data
                let oldData = self.getCachedData(location: location)
                
                //delete old data
                if(oldData != nil){
                    self.realmWrite {
                        self.realm.delete(oldData!)
                    }
                }
                
                let newData = CachedWeatherData()
                newData.createDate = Date().timeIntervalSince1970
                newData.locationUuid = location.uuid
                newData.data = self.encodeJson(data)
                
                self.realmWrite {
                    self.realm.add(newData)
                }
                
                onComplete(data)
                self.fetched[location.uuid] = true
                self.isFetching = false
            }
        }
    }
    
    private func fetchCachedData(location: LocationModel, onComplete: @escaping (WeatherModel?) -> Void){
        print("fetch:cached")
        if let cachedData = getCachedData(location: location){
            if let data = decodeJson(cachedData.data){
                onComplete(data)
                return
            }
        }
        onComplete(nil)
    }
    
    private func encodeJson(_ data: WeatherModel) -> String {
        let encoder = JSONEncoder()
        do {
            return String(decoding: try encoder.encode(data), as: UTF8.self)
        } catch {
            print(error)
            return ""
        }
    }
    
    private func decodeJson(_ json: String) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(WeatherModel.self, from: Data(json.utf8))
        } catch {
            print(error)
            return nil
        }
    }
    
    private func getCachedData(location: LocationModel) -> CachedWeatherData? {
        self.realm.objects(CachedWeatherData.self).filter {data in
            return data.locationUuid == location.uuid
        }.first
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
