import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalorieViewModel()
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(spacing: 8) {
            if let value = viewModel.caloriesLeftToday {
                if value < 0 {
                    Text("Przekroczono o")
                        .font(.headline)
                        .foregroundColor(.red)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(abs(value))")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.red)
                        Text("kcal")
                            .font(.caption2)
                            .foregroundColor(.red.opacity(0.7))
                    }
                } else {
                    Text("Zostało")
                        .font(.headline)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(value)")
                            .font(.system(size: 36, weight: .bold))
                        Text("kcal")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchCalories()
        }
        .onReceive(timer) { _ in
            viewModel.fetchCalories()
        }
    }
}
