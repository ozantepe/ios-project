//
//  DetailPageViewController.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit

class DetailPageViewController: UIPageViewController {
    
    
    // MARK: - Properties
    
    var forecastViewController: ForecastTableViewController?
    var otherDetailsViewController: OtherDetailsTableViewController?
    var orderedViewControllers = Array<UIViewController?>()
    var cityID: Int?
    var currentWeatherData: CurrentWeatherResponse? {
        didSet {
            generateViewControllers()
            if let firstVC = orderedViewControllers.first {
                setViewControllers([firstVC!], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    var metric: String? {
        didSet { forecastViewController?.metric = metric }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    
    
    // MARK: - Custom functions
    
    private func generateViewControllers() {
        forecastViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForecastTableViewController") as? ForecastTableViewController
        forecastViewController?.cityID = cityID
        forecastViewController?.metric = metric
        otherDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtherDetailsTableViewController") as? OtherDetailsTableViewController
        otherDetailsViewController?.currentWeatherData = currentWeatherData
        orderedViewControllers.append(forecastViewController!)
        orderedViewControllers.append(otherDetailsViewController!)
    }
}


// MARK: - UIPageViewController data source

extension DetailPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? OtherDetailsTableViewController else {
            return nil
        }
        
        // Find the current view controller index
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: vc) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        let totalPageCount = orderedViewControllers.count
        
        // Check if there any pages before current one
        guard previousIndex >= 0, totalPageCount > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? ForecastTableViewController else {
            return nil
        }
        
        // Find the current view controller index
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: vc) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let totalPageCount = orderedViewControllers.count
        
        // Check if there any page after current one
        guard totalPageCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
