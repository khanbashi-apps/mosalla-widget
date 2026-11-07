import SwiftUI
import WidgetKit

// تجربة صغيرة: خمس طرق رسمية لخلفية الويدجت، مبنية بـ Xcode 26 الحقيقي.

struct E: TimelineEntry { let date: Date }

struct P: TimelineProvider {
    func placeholder(in context: Context) -> E { E(date: .now) }
    func getSnapshot(in context: Context, completion: @escaping (E) -> Void) { completion(E(date: .now)) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<E>) -> Void) {
        completion(Timeline(entries: [E(date: .now)], policy: .after(.now.addingTimeInterval(3600))))
    }
}

struct Label2: View {
    let num: String
    let title: String
    @Environment(\.widgetRenderingMode) var mode
    var body: some View {
        VStack(spacing: 4) {
            Text(num).font(.system(size: 34, weight: .bold))
            Text(title).font(.system(size: 13, weight: .semibold))
            Text(modeName).font(.system(size: 10))
        }
        .foregroundStyle(.white)
        .shadow(radius: 2)
    }
    var modeName: String {
        switch mode {
        case .fullColor: "fullColor"
        case .accented: "accented"
        case .vibrant: "vibrant"
        default: "other"
        }
    }
}

// 1) خلفية شفافة Color.clear
struct W1: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g1", provider: P()) { _ in
            Label2(num: "1", title: "Color.clear")
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("1 شفاف")
        .description("containerBackground Color.clear")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// 2) خلفية ضبابية ultraThinMaterial
struct W2: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g2", provider: P()) { _ in
            Label2(num: "2", title: "ultraThinMaterial")
                .containerBackground(.ultraThinMaterial, for: .widget)
        }
        .configurationDisplayName("2 ضبابي")
        .description("containerBackground ultraThinMaterial")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// 3) زجاج شفاف glassEffect(.clear)
struct W3: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g3", provider: P()) { _ in
            Label2(num: "3", title: "glass .clear")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .glassEffect(.clear, in: .rect(cornerRadius: 20))
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("3 زجاج شفاف")
        .description("glassEffect clear")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// 4) زجاج عادي glassEffect(.regular)
struct W4: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g4", provider: P()) { _ in
            Label2(num: "4", title: "glass .regular")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("4 زجاج سيري")
        .description("glassEffect regular")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// 5) خلفية ملونة عادية (للمقارنة)
struct W5: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g5", provider: P()) { _ in
            Label2(num: "5", title: "لون عادي")
                .containerBackground(for: .widget) { Color(red: 0.22, green: 0.29, blue: 0.2) }
        }
        .configurationDisplayName("5 لون")
        .description("containerBackground color")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct GlassBundle: WidgetBundle {
    var body: some Widget { W1(); W2(); W3(); W4(); W5() }
}
