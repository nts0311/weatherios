//
//  LocationModel.swift
//  Weather
//
//  Created by nguyen huy on 1/8/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import Foundation
import RealmSwift

class LocationModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var nation: String = ""
    @objc dynamic var lat: Double = 0
    @objc dynamic var long: Double = 0
}
