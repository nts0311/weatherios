//
//  DailyWeatherCell.swift
//  Weather
//
//  Created by nguyen huy on 1/7/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit

class DailyWeatherCell: UITableViewCell {
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var imageCondition: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(data: Daily) {
        let df = DateFormatter()
        df.dateFormat = "E MMM dd"
        let date = NSDate(timeIntervalSince1970: TimeInterval(exactly: data.dt)!)
        labelDate.text = df.string(from: date as Date)
        labelTemp.text = "\(Int(data.temp.max)) / \(Int(data.temp.min)) °C"
        imageCondition.image = UIImage(systemName: data.weather.first!.getConditionName())
    }
}
