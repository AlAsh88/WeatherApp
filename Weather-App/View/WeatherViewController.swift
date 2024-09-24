//
//  ViewController.swift
//  Weather-App
//
//  Created by Ayesha Shaikh on 9/23/24.
//

//import UIKit
//import SwiftUI

import UIKit
import Combine
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    private let viewModel: WeatherViewModel
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    private let cityTextField = UITextField()
    private let stateTextField = UITextField()
    private let countryTextField = UITextField()
    private let fetchWeatherButton = UIButton(type: .system)
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let weatherIconImageView = UIImageView()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadLastSearchedLocation()
        requestLocationAccess()
        bindViewModel()
    }
    
    private func setupViews() {
        view.backgroundColor = .cyan
        
        // Configure text fields and labels
        cityTextField.placeholder = "City"
        cityTextField.accessibilityIdentifier = "cityTextField"
        cityTextField.accessibilityLabel = "City input"

        stateTextField.placeholder = "State"
        stateTextField.accessibilityIdentifier = "stateTextField"
        stateTextField.accessibilityLabel = "State input"

        countryTextField.placeholder = "Country"
        countryTextField.accessibilityIdentifier = "countryTextField"
        countryTextField.accessibilityLabel = "Country input"

        temperatureLabel.text = NSLocalizedString("Temperature", comment: "Label for displaying temperature")
        temperatureLabel.accessibilityIdentifier = "temperatureLabel"

        descriptionLabel.text = NSLocalizedString("Description", comment: "Label for displaying weather description")
        descriptionLabel.accessibilityIdentifier = "descriptionLabel"

        // Configure weather icon ImageView
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.accessibilityIdentifier = "weatherIconImageView"
        
        // Configure button
        fetchWeatherButton.setTitle(NSLocalizedString("Fetch Weather", comment: "Button to fetch weather data"), for: .normal)
        fetchWeatherButton.backgroundColor = .systemBlue
        fetchWeatherButton.setTitleColor(.white, for: .normal)
        fetchWeatherButton.addTarget(self, action: #selector(fetchWeather), for: .touchUpInside)
        fetchWeatherButton.accessibilityIdentifier = "fetchWeatherButton"
        fetchWeatherButton.accessibilityLabel = "Fetch weather"
        fetchWeatherButton.accessibilityHint = "Double tap to fetch the weather for the entered location."
        
        fetchWeatherButton.isAccessibilityElement = true
        fetchWeatherButton.accessibilityTraits = .button

        weatherIconImageView.isAccessibilityElement = true
        weatherIconImageView.accessibilityTraits = .image
        
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        temperatureLabel.adjustsFontForContentSizeCategory = true

        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true

        // Create a vertical stack view to arrange all elements
        let stackView = UIStackView(arrangedSubviews: [
            cityTextField,
            stateTextField,
            countryTextField,
            temperatureLabel,
            descriptionLabel,
            weatherIconImageView,
            fetchWeatherButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stack view to the main view
        view.addSubview(stackView)
        
        // Set up constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Set explicit constraints for weatherIconImageView size
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 100),  // Set height
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 100)    // Set width
        ])
    }

    private func bindViewModel() {
        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                guard let weather = weather else { return }
                let tempCelsius = weather.main.temp
                let tempFahrenheit = (tempCelsius * 9/5) + 32
//                temperatureLabel.text = NSLocalizedString("Temperature", comment: "Label for temperature")
                self?.temperatureLabel.text = NSLocalizedString("Temperature: ", comment: "Label for temperature") + String(format: "%.1f °F", tempFahrenheit)
                self?.descriptionLabel.text = "Description: \(weather.weather.first?.description ?? "")"

                if let iconCode = weather.weather.first?.icon {
                    self?.viewModel.fetchWeatherIcon(for: iconCode) { image in
                        DispatchQueue.main.async {
                            self?.weatherIconImageView.image = image
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else { return }
                self?.showAlert(message: error)
            }
            .store(in: &cancellables)
    }

    @objc private func fetchWeather() {
        let city = cityTextField.text ?? ""
        let state = stateTextField.text ?? ""
        let country = countryTextField.text ?? ""
        
        viewModel.fetchWeather(for: city, state: state, country: country)
        
        // After successful fetch, save the location
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
        UserDefaults.standard.set(state, forKey: "lastSearchedState")
        UserDefaults.standard.set(country, forKey: "lastSearchedCountry")
    }
    
    private func loadLastSearchedLocation() {
        let lastCity = UserDefaults.standard.string(forKey: "lastSearchedCity") ?? ""
        let lastState = UserDefaults.standard.string(forKey: "lastSearchedState") ?? ""
        let lastCountry = UserDefaults.standard.string(forKey: "lastSearchedCountry") ?? ""

        cityTextField.text = lastCity
        stateTextField.text = lastState
        countryTextField.text = lastCountry
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func requestLocationAccess() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle the case when permission is denied
            print("Location access denied")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Stop updating to save battery life
        locationManager.stopUpdatingLocation()
        
        // Use the location coordinates to fetch weather data
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        fetchWeatherData(lat: latitude, lon: longitude)
    }
    
    private func fetchWeatherData(lat: Double, lon: Double) {
        let apiKey = "430c15455218515329eb5ebe73de5895" // API key
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error fetching weather data: \(error)")
                return
            }
            
            // Check for valid response and data
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                  let data = data else {
                print("Invalid response or no data")
                return
            }
            
            // Parse the JSON data
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.updateUI(with: weatherResponse)
                }
            } catch {
                print("Error decoding weather data: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func updateUI(with weatherResponse: WeatherResponse) {
        let tempCelsius = weatherResponse.main.temp
        let tempFahrenheit = (tempCelsius * 9/5) + 32
        // Update temperature label
        temperatureLabel.text = String(format: "%.1f °F", tempFahrenheit)
        
        // Update description label
        if let weather = weatherResponse.weather.first {
            descriptionLabel.text = "Description: \(weather.description)"
            
            // Load weather icon
            loadWeatherIcon(iconName: weather.icon)
        }
    }
    
    private func loadWeatherIcon(iconName: String) {
        let iconUrlString = "https://openweathermap.org/img/wn/\(iconName)@2x.pn"
        guard let iconUrl = URL(string: iconUrlString) else { return }

        // Fetch the icon image
        let task = URLSession.shared.dataTask(with: iconUrl) { data, response, error in
            if let error = error {
                print("Error fetching icon: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Could not load image from data")
                return
            }

            DispatchQueue.main.async {
                self.weatherIconImageView.image = image // Update the UIImageView with the fetched icon
            }
        }
        
        task.resume() // Start the API call for the icon
    }

}

extension WeatherViewController {
    func accessibilityCustomActions() -> [UIAccessibilityCustomAction]? {
        let fetchAction = UIAccessibilityCustomAction(name: "Fetch Weather", target: self, selector: #selector(fetchWeather))
        return [fetchAction]
    }
}
