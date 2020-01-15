//
//  CitySearcher.swift
//  WeatherApp
//
//  Created by Ozan Tepe on 14.01.20.
//  Copyright © 2020 Ozan Tepe. All rights reserved.
//

import Foundation


// MARK: - Delegation protocol for this class

protocol CitySearcherDelegate: class {
    
    // Classes that conform this protocol MUST fulfill these conditions.
    var cityList: Array<CityNameLikeResponse.City> { get set }
    func didSearchFinish(_ sender: CitySearcher)
    func didErrorOccurWhileSearching(_ sender: CitySearcher)
}

class CitySearcher {
    
    private var requestCounter = 0
    private(set) var cityList = Array<CityNameLikeResponse.City>()
    weak var delegate: CitySearcherDelegate?
    
    
    // MARK: - Custom functions
    
    func search(url requestURL: String) {
        requestCounter = requestCounter + 1
        let requestID = requestCounter
        let request = URLRequest(url: URL(string: requestURL)!)
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        urlSession.dataTask(with: request) { (data, response, error) in
            if requestID == self.requestCounter {
                guard let data = data else {
                    print("Request failed")
                    return
                }
                do {
                    let response = try JSONDecoder().decode(CityNameLikeResponse.self, from: data)
                    
                    if let cityList = response.list {
                        self.cityList = cityList
                    } else {
                        print("City list could not retrieved for:\n \(String(describing: requestURL))")
                        self.cityList.removeAll()
                    }
                    
                    // Inform delegate
                    self.searchFinished()
                } catch let error {
                    print("Error at decoding json data:\n", error)
                    self.errorOccured()
                }
            }
        }.resume()
    }
    
    
    // MARK: - Delegation functions
    
    func searchFinished() {
        delegate?.didSearchFinish(self)
    }
    
    func errorOccured() {
        delegate?.didErrorOccurWhileSearching(self)
    }
}
