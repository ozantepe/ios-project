//
//  MyCitiesTableViewController.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit

class MyCitiesTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var metricSwitch: UISwitch!
    
    private let props = Properties()
    
    private var timer: Timer?
    
    private var spinner: UIView?
    
    private var citySearchViewController: CitySearchTableViewController?
    
    private var cityDetailViewController: CityDetailViewController?
    
    private var metric: String? {
        didSet { cityDetailViewController?.metric = self.metric }
    }
    
    var cityIDs: Array<Int> = []
    
    var currentWeatherData: Array<CurrentWeatherResponse> = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() // Remove empty table view cells
        spinner = self.displaySpinner(onView: self.view) // Create spinner
        
        
        
        if loadUserDefaults() {
            // Timer for fetching data from api every 5 mins
            timer = Timer(timeInterval: 300, target: self, selector: #selector(fetchCurrentWeatherData), userInfo: nil, repeats: true)
        } else {
            self.removeSpinner(spinner: spinner!)
        }
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Invalidate timer to avoid reference cycle
        timer?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("OMG! at: MyCitiesTableViewController")
    }
    
    // MARK: - Custom functions
    
    @IBAction func changeMetric(_ sender: UISwitch) {
        if sender.isOn {
            metric = "celsius"
        } else {
            metric = "fahrenheit"
        }
        tableView.reloadData()
    }
    
    private func loadUserDefaults() -> Bool {
        if let savedCityIDs = UserDefaults.standard.object(forKey: "savedCityIDs") as? Array<Int>, !savedCityIDs.isEmpty {
            self.cityIDs = savedCityIDs
            fetchCurrentWeatherData()
            return true
        } else {
            print("There is no saved city to load from UserDefaults.")
            return false
        }
    }
    
    @objc private func fetchCurrentWeatherData() {
        
        // Create appropriate string version of cityIDs for API call
        var strCityIDs = ""
        for cityID in cityIDs {
            strCityIDs += "\(cityID),"
        }
        strCityIDs.removeLast()
        
        // Create requestURL and make the request
        let requestURL = URL(string: props.BASE_API_URL + props.callBySeveralCityIDs(for: strCityIDs) + props.API_KEY + props.UNITS)!
        let request = URLRequest(url: requestURL)
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Request failed")
                return
            }
            do {
                let response = try JSONDecoder().decode(SeveralCityIDsResponse.self, from: data)
                for city in response.list! {
                    let currentWeatherResponse = city
                    if (self.currentWeatherData.contains(where: {
                        $0.id == city.id
                    })) {
                        self.currentWeatherData.remove(at: (self.currentWeatherData.firstIndex(where: { $0.id! == city.id! }))!)

                    }
                    self.currentWeatherData.append(currentWeatherResponse)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.removeSpinner(spinner: (self.spinner)!)
                    }
                }
                self.saveUserDefaults()
            } catch let error {
                print("Error at MyCitiesTableViewController.fetchCurrentWeatherData() decoding json data:\n", error)
            }
        }.resume()
    }
    
    private func saveUserDefaults() {
        UserDefaults.standard.set(cityIDs, forKey: "savedCityIDs")
    }
    
    private func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    private func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCity" {
            citySearchViewController = segue.destination as? CitySearchTableViewController
            citySearchViewController?.delegate = self
        } else if segue.identifier == "ShowDetail" {
            let city = currentWeatherData[(tableView.indexPathForSelectedRow?.row)!]
            cityDetailViewController = segue.destination as? CityDetailViewController
            cityDetailViewController?.cityID = city.id
            cityDetailViewController?.currentWeatherData = city
            cityDetailViewController?.metric = self.metric
        }
    }
}

// MARK: - CitySearchTableViewController delegate extension

extension MyCitiesTableViewController: CitySearchTableViewControllerDelegate {
    
    func didAddCity(_ sender: CitySearchTableViewController) {
        self.fetchCurrentWeatherData()
    }
    
    func doesCityAlreadyExist(_ sender: CitySearchTableViewController) {
        print("Selected city already exists.")
    }
}

// MARK: - Table view delegate and data source extension

extension MyCitiesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeatherData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCityCell", for: indexPath)
        let currentWeather = currentWeatherData[indexPath.row]
        cell.textLabel?.text = "\(currentWeather.name ?? "null"), \(currentWeather.sys?.country ?? "null")"
        
        switch metric {
        case "celsius":
            cell.detailTextLabel?.text = "\(currentWeather.main?.temp?.toString(format: ".") ?? "null")°C"
        case "fahrenheit":
            cell.detailTextLabel?.text = "\(props.celsiusToFahrenheit(celsius: (currentWeather.main?.temp)!).toString(format: "."))°F"
        default:
            cell.detailTextLabel?.text = "\(currentWeather.main?.temp?.toString(format: ".") ?? "null")°C"
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cityIDs.remove(at: indexPath.row)
            currentWeatherData.remove(at: indexPath.row)
            saveUserDefaults()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        cityIDs.swapAt(fromIndexPath.row, to.row)
        currentWeatherData.swapAt(fromIndexPath.row, to.row)
        saveUserDefaults()
        tableView.moveRow(at: fromIndexPath, to: to)
    }
}

extension Double {
    
    func toString(format: String) -> String {
        return String(format: "%\(format )f", self)
    }
}
