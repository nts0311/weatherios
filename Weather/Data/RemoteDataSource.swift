//
//  NetworkFetcher.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation

class RemoteDataSource<T: Decodable> {
    func performRequest(urlStr: String, onCompletedHandler: @escaping (T?, Error?) -> Void){
        guard let url = URL(string: urlStr) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) {data, _, error in
            if(error != nil){
                onCompletedHandler(nil, error!)
                return
            }
            
            if let data = data {
                if let decodedData = self.decodeJson(data: data, onCompletedHandler: onCompletedHandler){
                    onCompletedHandler(decodedData, nil)
                }
            }
        }.resume()
    }
    
    func decodeJson(data: Data, onCompletedHandler: (T?, Error?) -> Void) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch  {
            onCompletedHandler(nil, error)
            return nil
        }
    }
}
