import SwiftUI

@main
struct GlassTestApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 16) {
                Text("تجربة زجاج الويدجت").font(.title.bold())
                Text("أضف ويدجتات «تجربة الزجاج» الخمس من الشاشة الرئيسية والشاشة على الوضع الافتراضي، ثم صوّر الشاشة.")
                    .multilineTextAlignment(.center)
            }
            .padding()
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
