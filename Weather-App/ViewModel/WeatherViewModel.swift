//
//  WeatherViewModel.swift
//  Weather-App
//
//  Created by Ayesha Shaikh on 9/24/24.
//

import Combine
import Foundation
import UIKit

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    // Image cache to prevent re-downloading
    private var imageCache = NSCache<NSString, UIImage>()
    
    func fetchWeather(for city: String, state: String, country: String) {
        let apiKey = "430c15455218515329eb5ebe73de5895"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city),\(state),\(country)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] weatherResponse in
                self?.weather = weatherResponse
            })
            .store(in: &cancellables)
    }

    // Function to fetch and cache weather icons
    func fetchWeatherIcon(for iconCode: String, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: NSString(string: iconCode)) {
            completion(cachedImage)
            return
        }
        
        let iconURLString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        
        guard let url = URL(string: iconURLString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            // Cache the image
            self.imageCache.setObject(image, forKey: NSString(string: iconCode))
            completion(image)
        }.resume()
    }
}
