//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alessandro Schioppetti on 27/03/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: BaseViewController {
    
    var labelTitolo: UILabel = UILabel()
    var labelResult: UILabel = UILabel()
    var buttonConfirm: UIButton = UIButton()
    var buttonMyLocation: UIButton = UIButton()
    var imageWeather: UIImageView = UIImageView()
    var textFieldInputCity: UITextField = UITextField()
    
    let locationManager = CLLocationManager()
    var weatherManagerObj = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldInputCity.delegate = self
        weatherManagerObj.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        defineAndAddViews()
    }
    
    func defineAndAddViews() {
        view.backgroundColor = .white
        
        labelTitolo.text = "Insert a City"
        labelTitolo.textColor = .black
        labelTitolo.textAlignment = .center
        labelTitolo.backgroundColor = .red
        labelTitolo.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldInputCity.placeholder = "Search"
        textFieldInputCity.borderStyle = .line
        textFieldInputCity.translatesAutoresizingMaskIntoConstraints = false
        
        buttonConfirm.backgroundColor = .blue
        buttonConfirm.setTitle("Confirm", for: .normal)
        buttonConfirm.setTitleColor(.yellow, for: .normal)
        buttonConfirm.addTarget(self, action: #selector(buttonChangeTouchUpInside(_:)), for: .touchUpInside)
        buttonConfirm.translatesAutoresizingMaskIntoConstraints = false
        
        labelResult.text = "wait for current location.."
        labelResult.textColor = .black
        labelResult.textAlignment = .center
        labelResult.backgroundColor = .yellow
        labelResult.translatesAutoresizingMaskIntoConstraints = false
        
        imageWeather.translatesAutoresizingMaskIntoConstraints = false
        
        buttonMyLocation.backgroundColor = .darkGray
        buttonMyLocation.setTitle("Check your Location", for: .normal)
        buttonMyLocation.setTitleColor(.cyan, for: .normal)
        buttonMyLocation.addTarget(self, action: #selector(buttonMyLocationTouchUpInside(_:)), for: .touchUpInside)
        buttonMyLocation.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(labelTitolo)
        view.addSubview(textFieldInputCity)
        view.addSubview(buttonConfirm)
        view.addSubview(labelResult)
        view.addSubview(imageWeather)
        view.addSubview(buttonMyLocation)
        
        addConstraint()
        
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            // labelTitolo
            labelTitolo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelTitolo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelTitolo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            // textFieldInputCity
            textFieldInputCity.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textFieldInputCity.topAnchor.constraint(equalTo: labelTitolo.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            textFieldInputCity.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            // buttonConfirm
            buttonConfirm.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 120),
            buttonConfirm.topAnchor.constraint(equalTo: textFieldInputCity.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            buttonConfirm.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -120),
            // labelResult
            labelResult.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelResult.topAnchor.constraint(equalTo: buttonConfirm.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            labelResult.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            // imageWeather
            imageWeather.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 170),
            imageWeather.topAnchor.constraint(equalTo: labelResult.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            imageWeather.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -170),
            // buttonMyLocation
            buttonMyLocation.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            buttonMyLocation.topAnchor.constraint(equalTo: imageWeather.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            buttonMyLocation.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
        ])
    }
    
    @objc
    func buttonChangeTouchUpInside(_ sender: UIButton?) {
        print(#function)
        textFieldInputCity.endEditing(true)
    }
    
    @objc
    func buttonMyLocationTouchUpInside(_ sender: UIButton?) {
        print(#function)
        locationManager.requestLocation()
    }
    
    
    
}

//MARK: - UItextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        guard let cityName = textField.text else {
            print("city name empty, something went wrong")
            return
        }
//        weatherManagerObj.fetchWeather(cityName: cityName)
        
        weatherManagerObj.fetchWeather(cityName: cityName) { error, weather in
            
            if let error = error {
                print(error)
            }
            
            if let weather = weather {
                DispatchQueue.main.async {
                    self.labelResult.text = "\(weather.cityName): \(weather.tempString)°C"
                    self.imageWeather.image = UIImage(systemName: weather.conditionName)
                }
            }
        }
    }
    
}

//MARK: - WeatherManagerDelegate

extension MainViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: weatherModel) {
        DispatchQueue.main.async {
            self.labelResult.text = "\(weather.cityName): \(weather.tempString)°C"
            self.imageWeather.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude.round(to: 2)
            let lon = location.coordinate.longitude.round(to: 2)
            weatherManagerObj.fetchWeather(lat, lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - Double

extension Double {
    func round(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        var num = self
        num = num * multiplier
        num.round()
        num = num / multiplier
        return num
    }
}

