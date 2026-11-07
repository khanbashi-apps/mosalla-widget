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


struct W14: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "h14", provider: P()) { _ in
            Label2(num: "14", title: "clear + notRemovable")
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("14 clear+fixed")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable(false)
    }
}

struct W15: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "h15", provider: P()) { _ in
            Label2(num: "15", title: "material + notRemovable")
                .containerBackground(.ultraThinMaterial, for: .widget)
        }
        .configurationDisplayName("15 material+fixed")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable(false)
    }
}

struct W16: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "h16", provider: P()) { _ in
            Label2(num: "16", title: "glassBG + notRemovable")
                .containerBackground(for: .widget) { Rectangle().fill(.clear).glassEffect(.clear, in: .rect) }
        }
        .configurationDisplayName("16 glass+fixed")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable(false)
    }
}

struct W17: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "h17", provider: P()) { _ in
            Label2(num: "17", title: "clear + noMargins")
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("17 clear+margins")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

struct W18: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "h18", provider: P()) { _ in
            Label2(num: "18", title: "clear + both")
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("18 clear+both")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable(false)
        .contentMarginsDisabled()
    }
}

struct W19: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "h19", provider: P()) { _ in
            Label2(num: "19", title: "none + notRemovable")
                .padding(0)
        }
        .configurationDisplayName("19 none+fixed")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable(false)
    }
}

@main
struct GlassBundle: WidgetBundle {
    var body: some Widget { W14(); W15(); W16(); W17(); W18(); W19() }
}
