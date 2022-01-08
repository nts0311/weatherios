//
//  HourlyItemCell.swift
//  Weather
//
//  Created by nguyen huy on 1/7/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit

class HourlyItemCell: UICollectionViewCell {
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data: HourlyWeather) {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        let date = NSDate(timeIntervalSince1970: TimeInterval(exactly: data.dt)!)
        labelHour.text = "\(df.string(from: date as Date))"
        labelTemp.text = "\(Int(data.temp)) °C"
        image.image = UIImage(systemName: data.weather.first!.getConditionName())
    }
}
