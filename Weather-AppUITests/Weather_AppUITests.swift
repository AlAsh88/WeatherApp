//
//  Weather_AppUITests.swift
//  Weather-AppUITests
//
//  Created by Ayesha Shaikh on 9/23/24.
//

import XCTest

class WeatherAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        // This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // This method is called after the invocation of each test method in the class.
        app = nil
        super.tearDown()
    }

    func testFetchingWeatherData() {
        // Assume the UI contains a text field to enter the city, state, and country.
        let cityTextField = app.textFields["cityTextField"]
        let stateTextField = app.textFields["stateTextField"]
        let countryTextField = app.textFields["countryTextField"]
        
        // Check if text fields exist
        XCTAssertTrue(cityTextField.exists)
        XCTAssertTrue(stateTextField.exists)
        XCTAssertTrue(countryTextField.exists)

        // Enter a sample city, state, and country
        cityTextField.tap()
        cityTextField.typeText("")
        
        stateTextField.tap()
        stateTextField.typeText("")
        
        countryTextField.tap()
        countryTextField.typeText("")
        
        // Tap the fetch weather button
        let fetchWeatherButton = app.buttons[""]
        fetchWeatherButton.tap()
        
        // Wait for the weather data to be fetched and displayed
        let temperatureLabel = app.staticTexts["temperatureLabel"]
        let descriptionLabel = app.staticTexts["descriptionLabel"]
        let weatherIconImageView = app.images["weatherIconImageView"]
        
        // Check if the temperature label updates
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: temperatureLabel, handler: nil)
        expectation(for: exists, evaluatedWith: descriptionLabel, handler: nil)
        expectation(for: exists, evaluatedWith: weatherIconImageView, handler: nil)
        
        // Wait for the expectations
        waitForExpectations(timeout: 5, handler: nil)

        // Check if the labels contain text after the fetch
        XCTAssertTrue(temperatureLabel.label.count > 0)
        XCTAssertTrue(descriptionLabel.label.count > 0)
        XCTAssertTrue(weatherIconImageView.exists)
    }

    func testLocationAccessPrompt() {
        // Tap on the button that requests location access (if implemented in your UI)
        let requestLocationButton = app.buttons["requestLocationButton"]
        requestLocationButton.tap()
        
        // Check for the existence of the location access prompt (note: this may not be directly testable)
        // Instead, test for UI behavior after location access is granted (if applicable).
    }
}
