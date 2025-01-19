//
//  WeatherService.swift
//  WeatherAppIos
//
//  Created by Siti Hasnani on 18/01/2025.
//
import Foundation
import Combine

class WeatherService: WeatherServiceProtocol {
    
    private let apiKey = "7f390c66c61a9240b79d06f605c8d602"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather/"

    func fetchWeather(city: String) -> AnyPublisher<WeatherModel, Error> {
        let urlString = "\(baseUrl)?q=\(city)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .mapError { error in
                error as Error
            }
            .eraseToAnyPublisher()



    }
}

