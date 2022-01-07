//
//  WeatherInfoCell.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit

class WeatherInfoCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let dataSource = WeatherRemoteDataSource()
    var data: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: K.CurrentWeatherCell, bundle: nil), forCellReuseIdentifier: K.CurrentWeatherCell)
        tableView.register(UINib(nibName:
            K.DailyWeatherCell, bundle: nil), forCellReuseIdentifier: K.DailyWeatherCell)
        tableView.register(UINib(nibName: K.HourlyWeatherCell, bundle: nil), forCellReuseIdentifier: K.HourlyWeatherCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        
        dataSource.delegate = self
        dataSource.fetchData(lat: 21.027813, long: 105.794271)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section < 2){
            return 1
        }
        else {
            return data?.daily.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CurrentWeatherCell, for: indexPath) as! CurrentWeatherCell
            if(data != nil){
                cell.setData(data: data!.current)
            }
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.HourlyWeatherCell, for: indexPath) as! HourlyWeatherCell
            if(data != nil){
                cell.setData(data: data!.hourly)
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

extension WeatherInfoCell: WeatherRemoteSourceDelegate {
    func onSuccess(data: WeatherModel) {
        DispatchQueue.main.async {
            self.data = data
            self.tableView.reloadData()
        }
    }
    
    func onError(error: Error) {
        DispatchQueue.main.async {
            print(error)
        }
    }
}

