//
//  CityDetailViewController.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    private var props = Properties()
    private var pageViewController: DetailPageViewController?
    var cityID: Int?
    var currentWeatherData: CurrentWeatherResponse?
    var metric: String? {
        didSet { pageViewController?.metric = metric }
    }
    var forecastData: Array<ForecastResponse.Forecast>?
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageURL = self.props.IMAGES_PATH + (self.currentWeatherData?.weather![0].icon)! + ".png"
        self.fetchImage(url: imageURL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("OMG! at: CityDetailViewController")
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailPageViewController" {
            pageViewController = segue.destination as? DetailPageViewController
            pageViewController?.cityID = cityID
            pageViewController?.currentWeatherData = currentWeatherData
            pageViewController?.metric = metric
        }
    }
    
    
    // MARK: - Custom functions
    
    private func configureCurrentWeatherView() {
        cityNameLabel.text = "\(currentWeatherData?.name ?? "null"), \(currentWeatherData?.sys?.country ?? "null")"
        weatherLabel.text = "\(currentWeatherData?.weather![0].main ?? "null")"
        guard let temperature = currentWeatherData?.main?.temp else {
            mainTempLabel?.text = "--"
            return
        }
        
        switch metric {
        case "celsius":
            mainTempLabel?.text = "\(temperature.toString(format: "."))°C"
        case "fahrenheit":
            mainTempLabel?.text = "\(props.celsiusToFahrenheit(celsius: temperature).toString(format: "."))°F"
        default:
            mainTempLabel?.text = "\(temperature.toString(format: "."))°C"
        }
    }
    
    
    private func fetchImage(url requestURL: String) {
        let request = URLRequest(url: URL(string: requestURL)!)
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.weatherImage.image = UIImage(data: data)
                }
            } else {
                print("Error while getting image data.")
            }
            DispatchQueue.main.async {
                self.configureCurrentWeatherView()
            }
        }.resume()
    }
}

