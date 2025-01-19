//
//  WeatherAppIosTests.swift
//  WeatherAppIosTests
//
//  Created by Siti Hasnani on 18/01/2025.
//

import Testing
import XCTest

@testable import WeatherAppIos

class WeatherViewModelTests: XCTestCase {

    //for fail response
    class MockWeatherServiceError: WeatherService {
        override func fethcWeather(city: String) async throws -> WeatherModel {
            throw NSError(domain: "test", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch weather"])
        }
    }

    // Mock WeatherService to simulate a successful response
    class MockWeatherService: WeatherService {
        override func fethcWeather(city: String) async throws -> WeatherModel {
            // Return mocked data directly without needing to decode
            return WeatherModel(
                temperature: 22.0,
                description: "Clear Sky",
                humidity: 60,
                windSpeed: 5.0,
                cityName: "London",
                country: "GB"
            )
        }
    }

    func testFetchWeatherwithError() async {
        let weatherViewModel = await WeatherViewModel(weatherService: MockWeatherServiceError())

        // Fetch weather with invalid city
        await weatherViewModel.fetchWeather(city: "Invalid City")

        print("Error Message: \(await weatherViewModel.errorMessage ?? "No error message")")

        // Assert that the weather is nil and errorMessage is set on the main thread
        await MainActor.run {
            XCTAssertNil(weatherViewModel.weather)
            XCTAssertNotNil(weatherViewModel.errorMessage)
            XCTAssertEqual(weatherViewModel.errorMessage, "Failed to fetch weather")
            }
    }

    func testFetchWeatherSuccessfully() async {
        let weatherViewModel = await WeatherViewModel(weatherService: MockWeatherService())

        await weatherViewModel.fetchWeather(city: "London")

        await MainActor.run {
            XCTAssertNotNil(weatherViewModel.weather)
            XCTAssertEqual(weatherViewModel.weather?.cityName, "London")
            XCTAssertEqual(weatherViewModel.weather?.country, "GB")
            XCTAssertEqual(weatherViewModel.weather?.temperature, 22.0)
            XCTAssertEqual(weatherViewModel.weather?.description, "Clear Sky")
        }
    }


}
