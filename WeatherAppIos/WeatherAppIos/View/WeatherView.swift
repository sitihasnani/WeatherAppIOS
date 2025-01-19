import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = "" // To hold the city name entered by the user

    var body: some View {
        VStack {
            TextField("Enter city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                Task {
                    await viewModel.fetchWeather(city: city)
                }
            }) {
                Text("Get Weather")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if let weather = viewModel.weather {
                Text("City: \(weather.cityName), \(weather.country)") // Display city and country
                Text("Temperature: \(weather.temperature)°C")
                Text("Description: \(weather.description)")
                Text("Humidity: \(weather.humidity)%")
                Text("Wind Speed: \(weather.windSpeed) m/s")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Loading weather...")
            }
        }
        .padding()
    }
}

#Preview {
    WeatherView()
}
