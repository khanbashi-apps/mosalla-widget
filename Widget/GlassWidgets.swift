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


struct W6: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g6", provider: P()) { _ in
            Label2(num: "6", title: "AccessoryBG")
                .containerBackground(for: .widget) { AccessoryWidgetBackground() }
        }
        .configurationDisplayName("6 Accessory")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct W7: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g7", provider: P()) { _ in
            Label2(num: "7", title: "style .background")
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("7 background")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct W8: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g8", provider: P()) { _ in
            Label2(num: "8", title: "style .fill")
                .containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("8 fill")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct W9: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g9", provider: P()) { _ in
            Label2(num: "9", title: "glass in bg")
                .containerBackground(for: .widget) { Rectangle().fill(.clear).glassEffect(.clear, in: .rect) }
        }
        .configurationDisplayName("9 glass in bg")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct W10: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g10", provider: P()) { _ in
            Label2(num: "10", title: "glass reg in bg")
                .containerBackground(for: .widget) { Rectangle().fill(.clear).glassEffect(.regular, in: .rect) }
        }
        .configurationDisplayName("10 glass reg bg")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct W11: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g11", provider: P()) { _ in
            Label2(num: "11", title: "EmptyView bg")
                .containerBackground(for: .widget) { EmptyView() }
        }
        .configurationDisplayName("11 empty")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct W12: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g12", provider: P()) { _ in
            Label2(num: "12", title: "no containerBG")
                .padding(0)
        }
        .configurationDisplayName("12 none")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct W13: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "g13", provider: P()) { _ in
            Label2(num: "13", title: "style .tint")
                .containerBackground(.tint, for: .widget)
        }
        .configurationDisplayName("13 tint")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct GlassBundle: WidgetBundle {
    var body: some Widget { W6(); W7(); W8(); W9(); W10(); W11(); W12(); W13() }
}
