//
//  CurrentWeatherCell.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var labelMainCondition: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelFeelsLike: UILabel!
    
    
    @IBOutlet weak var labelWindInfo: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelUv: UILabel!
    @IBOutlet weak var labelPressure: UILabel!
    @IBOutlet weak var labelVisibility: UILabel!
    @IBOutlet weak var labelDew: UILabel!
    @IBOutlet weak var labelLastUpdate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: HourlyWeather){
        conditionImage.image = UIImage(systemName: (data.weather.first?.getConditionName())!)
        labelMainCondition.text = data.weather.first?.main
        labelDescription.text = data.weather.first?.description
        labelTemp.text = "\(Int(data.temp)) °C"
        labelFeelsLike.text = "Feels like \(Int(data.feels_like)) °C"
        
        labelWindInfo.text = "Wind: \(data.wind_speed)m/s"
        labelHumidity.text = "Humidity: \(data.humidity)%"
        labelUv.text = "UV Index: \(data.uvi)"
        labelPressure.text = "Pressure: \(data.pressure)hPa"
        labelVisibility.text = "Visibility: \(data.visibility / 1000)km"
        labelDew.text = "Dew point: \(Int(data.dew_point))°C"
        
        let lastUpdate = epochToStr(TimeInterval(exactly: data.dt)!)
        labelLastUpdate.text = "Last update: \(lastUpdate)"
    }
    
    func epochToStr(_ epoch: TimeInterval) -> String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        df.timeZone = TimeZone.current
        return df.string(from: Date(timeIntervalSince1970: epoch))
    }
}
