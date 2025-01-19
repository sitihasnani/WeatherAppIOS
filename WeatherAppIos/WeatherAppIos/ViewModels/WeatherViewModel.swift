//
//  WeatherViewModel.swift
//  WeatherAppIos
//
//  Created by Siti Hasnani on 18/01/2025.
//
import Foundation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherModel? = nil
    @Published var errorMessage: String?

    private var weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // Dependency Injection through the initializer
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }

    func fetchWeather(city: String) {
        weatherService.fetchWeather(city: city)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] weather in
                self?.weather = weather
            }
            .store(in: &cancellables)
        }

}
