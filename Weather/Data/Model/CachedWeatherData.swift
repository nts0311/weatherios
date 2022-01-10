//
//  CachedWeatherData.swift
//  Weather
//
//  Created by nguyen huy on 1/10/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation
import RealmSwift

class CachedWeatherData: Object, Codable {
    @objc dynamic var locationUuid: String = ""
    @objc dynamic var data: String = ""
    @objc dynamic var createDate: Double = 0
}
