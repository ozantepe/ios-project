//
//  OtherDetailsTableViewController.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit

class OtherDetailsTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    var currentWeatherData: CurrentWeatherResponse?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
}

extension OtherDetailsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Weather Description"
        case 1:
            return "Sunrise"
        case 2:
            return "Sunset"
        default:
            return ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherDetailsCell", for: indexPath) as! OtherDetailsViewCell
        
        if currentWeatherData != nil {
            switch indexPath.section {
            case 0:
                cell.configure(data: currentWeatherData!, for: 0)
            case 1:
                cell.configure(data: currentWeatherData!, for: 1)
            case 2:
                cell.configure(data: currentWeatherData!, for: 2)
            default:
                cell.configure(data: currentWeatherData!, for: -1)
            }
        }
        return cell
    }
}
