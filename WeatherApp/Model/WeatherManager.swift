//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Alessandro Schioppetti on 27/03/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import Foundation

typealias WeatherCompletion = ((Error?, weatherModel?) -> ())?

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: weatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=54f5f0f1c3c651497eb0a54894e70cd7&units=metric"
    
    func fetchWeather(cityName: String, completion: WeatherCompletion)  {
        let urlString = "\(weatherURL)&q=\(cityName)"
        weather(with: urlString, completion: completion)
    }
    
    func fetchWeather(cityName: String)  {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(_ lat: Double, _ lon: Double) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // create URL object
        if let url = URL(string: urlString) {
            
            // create URL session
            let session = URLSession(configuration: .default)
            
            // give session a task
            let task = session.dataTask(with: url) { (Data, URLResponse, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let dataIn = Data {
                    if let weather = self.parseJSON( dataIn) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // start task
            task.resume()
        }
    }
    
    func weather(with urlString: String, completion: WeatherCompletion) {
        // create URL object
        if let url = URL(string: urlString) {
            
            // create URL session
            let session = URLSession(configuration: .default)
            
            // give session a task
            let task = session.dataTask(with: url) { (Data, URLResponse, error) in
                
                guard let completion = completion else { return }
                
                if error != nil {
                    completion(error, nil)
                    return
                }
                if let dataIn = Data {
                    if let weather = self.parseJSON( dataIn) {
                        completion(nil, weather)
                    }
                }
            }
            // start task
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> weatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let weatherObj = weatherModel(conditionId: id, cityName: name, temp: temp)
            return weatherObj
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
    
}
