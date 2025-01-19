//
//  WeatherModel.swift
//  WeatherAppIos
//
//  Created by Siti Hasnani on 18/01/2025.
//
import Foundation

struct WeatherModel: Codable {
    let temperature: Double
    let description: String
    let humidity: Int
    let windSpeed: Double
    let cityName: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case wind
        case cityName = "name"
        case sys
    }

    enum MainKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
    }

    enum WeatherKeys: String, CodingKey {
        case description
    }

    enum WindKeys: String, CodingKey {
        case speed
    }

    enum SysKeys: String, CodingKey {
        case country
    }

    // Default initializer for mock data
    init(temperature: Double, description: String, humidity: Int, windSpeed: Double, cityName: String, country: String) {
        self.temperature = temperature
        self.description = description
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.cityName = cityName
        self.country = country
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Main data
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temperature = try mainContainer.decode(Double.self, forKey: .temperature)
        humidity = try mainContainer.decode(Int.self, forKey: .humidity)

        // Weather description
        var weatherArray = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherDetails = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
        description = try weatherDetails.decode(String.self, forKey: .description)

        // Wind speed
        let windContainer = try container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        windSpeed = try windContainer.decode(Double.self, forKey: .speed)

        // City name and country from sys
        let sysContainer = try container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        country = try sysContainer.decode(String.self, forKey: .country)

        cityName = try container.decode(String.self, forKey: .cityName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        var mainContainer = container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        try mainContainer.encode(temperature, forKey: .temperature)
        try mainContainer.encode(humidity, forKey: .humidity)

        var weatherArray = container.nestedUnkeyedContainer(forKey: .weather)
        var weatherDetails = weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
        try weatherDetails.encode(description, forKey: .description)

        var windContainer = container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        try windContainer.encode(windSpeed, forKey: .speed)

        var sysContainer = container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        try sysContainer.encode(country, forKey: .country)

        try container.encode(cityName, forKey: .cityName)
    }
}




