import SwiftUI

// يعرض كيف وقّع المتجر التطبيق فعلاً: المعرّف الحقيقي، ونوع الشهادة، والصلاحيات.
func provisionInfo(_ url: URL) -> String {
    guard let d = try? Data(contentsOf: url) else { return "لا يوجد embedded.mobileprovision" }
    let s = String(decoding: d, as: UTF8.self)
    guard let a = s.range(of: "<?xml"), let b = s.range(of: "</plist>") else { return "تعذر قراءة الملف" }
    let xml = String(s[a.lowerBound..<b.upperBound])
    guard let p = try? PropertyListSerialization.propertyList(from: Data(xml.utf8), format: nil) as? [String: Any] else { return "تعذر التحليل" }
    var out: [String] = []
    out.append("Name: \(p["Name"] ?? "-")")
    out.append("TeamName: \(p["TeamName"] ?? "-")")
    out.append("TeamID: \((p["TeamIdentifier"] as? [String])?.joined(separator: ",") ?? "-")")
    out.append("ProvisionsAllDevices (Enterprise): \(p["ProvisionsAllDevices"] ?? "no")")
    out.append("Devices: \((p["ProvisionedDevices"] as? [Any])?.count ?? 0)")
    out.append("Expiration: \(p["ExpirationDate"] ?? "-")")
    if let e = p["Entitlements"] as? [String: Any] {
        out.append("Entitlements:")
        for k in e.keys.sorted() { out.append("  \(k) = \(e[k]!)") }
    }
    return out.joined(separator: "\n")
}

@main
struct GlassTestApp: App {
    var body: some Scene {
        WindowGroup {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("معلومات التوقيع").font(.title2.bold())
                    Text("App ID: \(Bundle.main.bundleIdentifier ?? "-")")
                    let ax = Bundle.main.builtInPlugInsURL?.appendingPathComponent("GlassWidget.appex")
                    Text("Widget ID: \(ax.flatMap { Bundle(url: $0)?.bundleIdentifier } ?? "-")")
                    Text("— التطبيق —").bold()
                    Text(provisionInfo(Bundle.main.bundleURL.appendingPathComponent("embedded.mobileprovision")))
                    Text("— الويدجت —").bold()
                    Text(ax.map { provisionInfo($0.appendingPathComponent("embedded.mobileprovision")) } ?? "-")
                }
                .font(.system(size: 12, design: .monospaced))
                .textSelection(.enabled)
                .padding()
            }
        }
    }
}
