//
//  WeatherServiceProtocol.swift
//  WeatherAppIos
//
//  Created by Siti Hasnani on 18/01/2025.
//
import Foundation
import Combine

protocol WeatherServiceProtocol {
    
    func fetchWeather(city: String) -> AnyPublisher<WeatherModel, Error>

}
