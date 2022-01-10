//
//  WeatherRemoteDataSource.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation

class WeatherRemoteDataSource: RemoteDataSource<WeatherModel> {
    let baseUrl = "https://api.openweathermap.org/data/2.5/onecall?appid=8c90b4ac293e4f11683921441e152339&units=metric"
    
    func fetchData(lat: Double, long: Double, onCompleteHandler: @escaping (WeatherModel? ,Error?) -> Void){
        let requestUrl = "\(baseUrl)&lat=\(lat)&lon=\(long)"
        performRequest(urlStr: requestUrl) {data, error in
            if(error != nil){
                onCompleteHandler(nil, error!)
                return
            }
            onCompleteHandler(data, nil)
        }
    }
}
