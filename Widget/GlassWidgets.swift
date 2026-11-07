import SwiftUI
import WidgetKit
import AppIntents

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


struct GIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "تجربة"
    init() {}
}
struct AP: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> E { E(date: .now) }
    func snapshot(for configuration: GIntent, in context: Context) async -> E { E(date: .now) }
    func timeline(for configuration: GIntent, in context: Context) async -> Timeline<E> {
        Timeline(entries: [E(date: .now)], policy: .after(.now.addingTimeInterval(3600)))
    }
}

// 20) نفس جلاسيفاي بالضبط: AppIntentConfiguration + Color.clear + بدون هوامش
struct W20: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "k20", intent: GIntent.self, provider: AP()) { _ in
            Label2(num: "20", title: "Glassify copy")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .containerBackground(Color.clear, for: .widget)
        }
        .configurationDisplayName("20 مثل جلاسيفاي")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
        .containerBackgroundRemovable(true)
    }
}

// 21) Static + Color.clear
struct W21: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "k21", provider: P()) { _ in
            VStack { Label2(num: "21", title: "static clear"); Text(Bundle.main.bundleIdentifier ?? "-").font(.system(size: 9)).foregroundStyle(.white) }
                .containerBackground(Color.clear, for: .widget)
        }
        .configurationDisplayName("21 شفاف")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// 22) زجاج سيري مثل جلاسيفاي: خلفية شفافة + طبقة Material داخل المحتوى
struct W22: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "k22", intent: GIntent.self, provider: AP()) { _ in
            ZStack {
                Rectangle().fill(.ultraThinMaterial)
                Label2(num: "22", title: "clear + material")
            }
            .containerBackground(Color.clear, for: .widget)
        }
        .configurationDisplayName("22 سيري")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

@main
struct GlassBundle: WidgetBundle {
    var body: some Widget { W20(); W21(); W22() }
}
