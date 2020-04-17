//
//  weatherData.swift
//  WeatherApp
//
//  Created by Alessandro Schioppetti on 27/03/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let main: String
    let description: String
    let id: Int
}

struct Main: Codable {
    let temp: Double
}
