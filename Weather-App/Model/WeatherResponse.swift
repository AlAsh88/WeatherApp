//
//  WeatherResponse.swift
//  Weather-App
//
//  Created by Ayesha Shaikh on 9/24/24.
//

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

