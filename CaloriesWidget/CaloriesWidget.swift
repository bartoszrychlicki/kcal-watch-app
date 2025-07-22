import WidgetKit
import SwiftUI

struct CaloriesEntry: TimelineEntry {
    let date: Date
    let calories: Int
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CaloriesEntry {
        CaloriesEntry(date: Date(), calories: 1234)
    }

    func getSnapshot(in context: Context, completion: @escaping (CaloriesEntry) -> Void) {
        fetchCalories { value in
            completion(CaloriesEntry(date: Date(), calories: value))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CaloriesEntry>) -> Void) {
        fetchCalories { value in
            let entry = CaloriesEntry(date: Date(), calories: value)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(900))) // co 15 min
            completion(timeline)
        }
    }

    private func fetchCalories(completion: @escaping (Int) -> Void) {
        guard let url = URL(string: "https://kcal-api-server.vercel.app/api/calories") else {
            completion(0)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let result = try? JSONDecoder().decode(CalorieData.self, from: data) {
                completion(result.caloriesLeftToday)
            } else {
                completion(0)
            }
        }.resume()
    }
}
struct CaloriesWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 2) {
            Text("\(abs(entry.calories))")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(entry.calories < 0 ? .red : .primary)

            Text(entry.calories < 0 ? "przekroczono" : "kcal")
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}
@main
struct CaloriesWidget: Widget {
    let kind: String = "CaloriesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CaloriesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Kalorie")
        .description("Pozostałe kalorie dzisiaj.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
            .accessoryCorner
        ])    }
}
