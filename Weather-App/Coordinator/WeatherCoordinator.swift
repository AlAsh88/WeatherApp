//
//  WeatherCoordinator.swift
//  Weather-App
//
//  Created by Ayesha Shaikh on 9/24/24.
//

import UIKit

class WeatherCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherViewModel = WeatherViewModel()
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        navigationController.pushViewController(weatherViewController, animated: true)
    }
}

