//
//  CitySearchTableViewController.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import UIKit


// MARK: - Delegation protocol for this view controller

protocol CitySearchTableViewControllerDelegate: class {
    
    // Classes that conform this protocol MUST fulfill these conditions.
    var cityIDs: Array<Int> { get set}
    func didAddCity(_ sender: CitySearchTableViewController)
    func doesCityAlreadyExist(_ sender: CitySearchTableViewController)
}

class CitySearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    // MARK: - Properties
    
    private var searchController: UISearchController!
    private var props = Properties()
    private var citySearcher: CitySearcher!
    internal var cityList = Array<CityNameLikeResponse.City>()
    weak var delegate: CitySearchTableViewControllerDelegate?
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        citySearcher = CitySearcher()
        citySearcher.delegate = self
        configureSearchController()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("OMG! at: CitySearchTableViewController")
    }
    
    
    // MARK: - Custom functions
    
    func configureSearchController() {
        
        // Initializing UISearchController with nil searchResultsController
        // because we want to use the same view to display the results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Istanbul"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func searchCity(for cityName: String) {
        var fixedCityName = cityName
        if let index = cityName.firstIndex(of: " ") {
            let after = cityName.index(after: index)
            let first = cityName[..<index]
            let second = cityName[after...]
            fixedCityName = first + "%20" + second
        }
        let requestURL = props.BASE_API_URL
            + props.callByCityName(like: fixedCityName.lowercased())
            + props.API_KEY
            + props.LANG
            + props.UNITS
        self.citySearcher.search(url: requestURL)
    }
    
    
    // MARK: - Delegation functions
    
    func cityAdded() {
        delegate?.didAddCity(self)
    }
    
    
    func cityAlreadyExists() {
        delegate?.doesCityAlreadyExist(self)
    }
}


// MARK: - CitySearcherDelegate protocols

extension CitySearchTableViewController: CitySearcherDelegate {
    
    func didSearchFinish(_ sender: CitySearcher) {
        cityList = sender.cityList
        if cityList.isEmpty {
            print("No result for this search.")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func didErrorOccurWhileSearching(_ sender: CitySearcher) {
        print("CitySearchTableViewController: Error occured while searching.")
    }
}


// MARK: - UISearchResultsUpdating protocols

extension CitySearchTableViewController: UISearchResultsUpdating {
    
    // From Documentation:
    // This method is automatically called whenever the search bar becomes the first responder
    // or changes are made to the text in the search bar.
    // Perform any required filtering and updating inside of this method.
    func updateSearchResults(for searchController: UISearchController) {
        if let cityName = searchController.searchBar.text?.lowercased(), !cityName.isEmpty {
            searchCity(for: cityName)
        } else if !cityList.isEmpty {
            // If searchBar text is empty clear cityList and reload table view data
            // only if there was any data
            cityList.removeAll()
            tableView.reloadData()
        }
    }
}


// MARK: - Table view data source functions

extension CitySearchTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let city = cityList[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.sys?.country
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityID = cityList[indexPath.row].id else {
            print("Error at CitySearchTableViewController: Could not found cityID")
            return
        }
        
        if let doesContain = delegate?.cityIDs.contains(where: {
            if $0 == cityID {
                return true
            }
            return false
        }), !doesContain {
            delegate?.cityIDs.append(cityID)
            cityAdded()
        } else {
            cityAlreadyExists()
        }
        searchController.isActive = false
        self.navigationController?.popToViewController(delegate as! UIViewController, animated: true)
    }
}
