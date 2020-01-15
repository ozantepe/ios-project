//
//  ForecastTableViewController.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    var forecastData: Array<ForecastResponse.Forecast>?
    var props = Properties()
    var cityID: Int? {
        didSet { fetchForecastData(for: cityID) }
    }
    var metric: String?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
    
    
    // MARK: - Custom functions
    
    func fetchForecastData(for cityID: Int?) {
        let requestURL = URL(string: props.FORECAST_API_URL + props.callByCityID(for: cityID!) + props.API_KEY + props.UNITS)!
        let request = URLRequest(url: requestURL)
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Request failed")
                return
            }
            do {
                self.forecastData = try JSONDecoder().decode(ForecastResponse.self, from: data).list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error at DetailFetcher.fetchCurrentWeatherData() decoding json data:\n", error)
            }
        }.resume()
    }
}


// MARK: - Table view data source

extension ForecastTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  forecastData?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastViewCell", for: indexPath) as! ForecastViewCell
        guard let forecast = forecastData?[indexPath.row] else {
            print("Could not get forecastData.")
            return cell
        }
        cell.configure(for: forecast, with: metric)
        return cell
    }
}
