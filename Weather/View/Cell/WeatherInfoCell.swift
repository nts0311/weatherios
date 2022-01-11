//
//  WeatherInfoCell.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit

class WeatherInfoCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    let NUM_OF_SECTIONS = 3
    let SECTION_CURRENT_WEATHER = 0
    let SECTION_HOURLY_WEATHER = 1
    let SECTION_DAILY_WEATHER = 2
    
    @IBOutlet weak var tableView: UITableView!
    let weatherRepo = WeatherRepo2.shared
    var data: WeatherModel?
    var currentLocation: LocationModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: K.CurrentWeatherCell, bundle: nil), forCellReuseIdentifier: K.CurrentWeatherCell)
        tableView.register(UINib(nibName:
            K.DailyWeatherCell, bundle: nil), forCellReuseIdentifier: K.DailyWeatherCell)
        tableView.register(UINib(nibName: K.HourlyWeatherCell, bundle: nil), forCellReuseIdentifier: K.HourlyWeatherCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
    }
    
    func loadWeatherData(location: LocationModel) {
        let forceRefresh = currentLocation == nil ? true : false
        currentLocation = location
        weatherRepo.getWeatherData(location: location, forceRefresh: forceRefresh, onCompleteHandler: onLoadDataComplete)
    }
    
    func onLoadDataComplete(model: WeatherModel?) {
        if(model != nil){
            self.data = model!
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_OF_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section < SECTION_DAILY_WEATHER){
            return 1
        }
        else {
            return data?.daily.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == SECTION_CURRENT_WEATHER) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CurrentWeatherCell, for: indexPath) as! CurrentWeatherCell
            if(data != nil){
                cell.setData(data: data!.current)
            }
            return cell
        }
        else if (indexPath.section == SECTION_HOURLY_WEATHER) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.HourlyWeatherCell, for: indexPath) as! HourlyWeatherCell
            if(data != nil){
                cell.setData(data: Array(data!.hourly))
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.DailyWeatherCell, for: indexPath) as! DailyWeatherCell
            if let data = data {
                cell.setData(data: data.daily[indexPath.row])
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

