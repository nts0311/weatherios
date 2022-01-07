//
//  NetworkFetcher.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation

class NetworkFetcher<T: Decodable> {
    func performRequest(urlStr: String){
        guard let url = URL(string: urlStr) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) {data, _, error in
            if(error != nil){
                self.onError(error: error!)
                return
            }
            
            if let data = data {
                if let decodedData = self.decodeJson(data: data){
                    self.onSucess(data: decodedData)
                }
            }
        }.resume()
    }
    
    func decodeJson(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch  {
            onError(error: error)
            return nil
        }
    }
    
    func onSucess(data: T) {}
    func onError(error: Error) {}
}
