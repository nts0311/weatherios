//
//  WeatherRemoteDataSource.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation

protocol WeatherRemoteSourceDelegate {
    func onSuccess(data: WeatherModel)
    func onError(error: Error)
}

class WeatherRemoteDataSource: NetworkFetcher<WeatherModel> {
    let baseUrl = "https://api.openweathermap.org/data/2.5/onecall?appid=8c90b4ac293e4f11683921441e152339&units=metric"
    var delegate: WeatherRemoteSourceDelegate?
    
    func fetchData(lat: Double, long: Double){
        let requestUrl = "\(baseUrl)&lat=\(lat)&lon=\(long)"
        performRequest(urlStr: requestUrl)
    }
    
    override func onSucess(data: WeatherModel) {
        delegate?.onSuccess(data: data)
    }
    
    override func onError(error: Error) {
        delegate?.onError(error: error)
    }
}
