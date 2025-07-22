//
//  CalorieViewModel.swift
//  kcal-watch
//
//  Created by Bartosz Rychlicki on 22/07/2025.
//


import Foundation
import Combine

class CalorieViewModel: ObservableObject {
    @Published var caloriesLeftToday: Int? = nil

    func fetchCalories() {
        guard let url = URL(string: "https://kcal-api-server.vercel.app/api/calories") else {
            print("❌ Invalid URL")
            return
        }

        print("🌐 Fetching from \(url)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error)")
            }

            if let data = data,
               let result = try? JSONDecoder().decode(CalorieData.self, from: data) {
                DispatchQueue.main.async {
                    self.caloriesLeftToday = result.caloriesLeftToday
                    print("✅ Calories loaded: \(result.caloriesLeftToday)")
                }
            } else {
                print("⚠️ Failed to decode response")
            }
        }.resume()
    }
}
