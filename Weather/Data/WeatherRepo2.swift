//
//  WeatherRepo2.swift
//  Weather
//
//  Created by nguyen huy on 1/11/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherRepo2 {
    typealias WeatherHandler = (WeatherModel?) -> Void
    
    private let realm = try! Realm()
    private var memoryCached = [String: WeatherModel]()
    private let remoteSource = WeatherRemoteDataSource()
    
    private init() {}
    
    func getWeatherData(location: LocationModel, forceRefresh: Bool = false, onCompleteHandler: @escaping WeatherHandler)  {
        if(forceRefresh){
            fetchRemoteData(location: location, onComplete: onCompleteHandler)
        }
        else {
            if let cachedData = getCachedData(location: location) {
                log("\(location.name) memory cached")
                onCompleteHandler(cachedData)
            }
            else {
                fetchRemoteData(location: location, onComplete: onCompleteHandler)
            }
        }
    }
    
    private func getCachedData(location: LocationModel) -> WeatherModel?{
        return memoryCached[location.uuid]
    }
    
    private func fetchRemoteData(location: LocationModel, onComplete: @escaping WeatherHandler){
        log("\(location.name) remote")
        remoteSource.fetchData(lat: location.lat, long: location.long){data, error in
            guard let data = data, error == nil else {
                print(error)
                DispatchQueue.main.async {
                    self.loadDataFromDisk(location: location, onComplete: onComplete)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.saveDataToDisk(location: location, data: data)
                self.memoryCached[location.uuid] = data
                onComplete(data)
            }
        }
    }
    
    private func saveDataToDisk(location: LocationModel, data: WeatherModel) {
        log("\(location.name) save to disk")
        if let oldData = self.getRealmData(location: location){
            self.realmWrite {
                self.realm.delete(oldData)
            }
        }
        
        let newData = CachedWeatherData()
        newData.createDate = Date().timeIntervalSince1970
        newData.locationUuid = location.uuid
        newData.data = self.encodeJson(data)
        
        self.realmWrite {
            self.realm.add(newData)
        }
    }
    
    private func loadDataFromDisk(location: LocationModel, onComplete: @escaping WeatherHandler){
        log("\(location.name) disk")
        if let dataFromDisk = getRealmData(location: location){
            if let data = decodeJson(dataFromDisk.data){
                self.memoryCached[location.uuid] = data
                onComplete(data)
                return
            }
        }
        onComplete(nil)
    }
    
    private func getRealmData(location: LocationModel) -> CachedWeatherData? {
        self.realm.objects(CachedWeatherData.self).filter {data in
            return data.locationUuid == location.uuid
        }.first
    }
    
    public static let shared = WeatherRepo2()
}

extension WeatherRepo2 {
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
    
    private func realmWrite(block: () -> Void) -> Bool {
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
    
    private func log(_ str: String){
        print("WeatherRepo2: \(str)")
    }
}
