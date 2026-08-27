import Cocoa
import SwiftUI

final class DockOwlView: NSView {
    private var start = Date()
    var isDaytime = false { didSet { needsDisplay = true } }

    override var isFlipped: Bool { false }
    override var isOpaque: Bool { false }

    func tick() {
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        let context = NSGraphicsContext.current!.cgContext
        let scale = min(bounds.width, bounds.height) / 1024
        context.saveGState()
        context.clear(bounds)
        context.translateBy(x: (bounds.width - 1024 * scale) / 2, y: (bounds.height - 1024 * scale) / 2)
        context.scaleBy(x: scale, y: scale)

        // Dock tiles are physically small, so the motion needs to read more strongly
        // than it would in a full-size window: one relaxed breath every ~3 seconds.
        let elapsed = Date().timeIntervalSince(start)
        let phase = elapsed * 2.08
        let breath = (sin(phase) + 1) / 2
        let drift = CGFloat((elapsed.truncatingRemainder(dividingBy: 3.1)) / 3.1)

        // Keep the Dock itself visible. A soft halo is enough to make the owl legible
        // without turning it into a little app-shaped card.
        (isDaytime ? NSColor(calibratedRed: 0.95, green: 0.74, blue: 0.35, alpha: 0.23) : NSColor(calibratedRed: 0.18, green: 0.25, blue: 0.40, alpha: 0.23)).setFill()
        NSBezierPath(ovalIn: NSRect(x: 116, y: 105, width: 790, height: 780)).fill()
        (isDaytime ? NSColor(calibratedRed: 1, green: 0.77, blue: 0.24, alpha: 0.82) : NSColor(calibratedRed: 0.94, green: 0.88, blue: 0.72, alpha: 0.66)).setFill()
        NSBezierPath(ovalIn: NSRect(x: 735, y: 790, width: 112, height: 112)).fill()
        NSColor(calibratedRed: 0.43, green: 0.32, blue: 0.37, alpha: 0.32).setFill()
        NSBezierPath(ovalIn: NSRect(x: 783, y: 832, width: 86, height: 86)).fill()

        context.saveGState()
        context.translateBy(x: 512, y: 500)
        context.scaleBy(x: 1.42, y: 1.42)
        context.translateBy(x: -512, y: -500)

        let branch = NSBezierPath()
        branch.move(to: NSPoint(x: 118, y: 246)); branch.curve(to: NSPoint(x: 900, y: 260), controlPoint1: NSPoint(x: 340, y: 285), controlPoint2: NSPoint(x: 665, y: 213))
        branch.lineWidth = 42; branch.lineCapStyle = .round
        NSColor(calibratedRed: 0.76, green: 0.60, blue: 0.49, alpha: 0.86).setStroke(); branch.stroke()

        let bodyHeight = 448 * (0.91 + breath * 0.13)
        let bodyY = 254 - (bodyHeight - 448) / 2 + CGFloat(breath * 18)
        NSColor(calibratedRed: 0.38, green: 0.22, blue: 0.27, alpha: 1).setFill()
        triangle(NSPoint(x: 315, y: 622), NSPoint(x: 372, y: 838), NSPoint(x: 474, y: 633)).fill()
        triangle(NSPoint(x: 710, y: 622), NSPoint(x: 652, y: 838), NSPoint(x: 550, y: 633)).fill()
        let body = NSBezierPath(ovalIn: NSRect(x: 258, y: bodyY, width: 510, height: bodyHeight))
        (isDaytime ? NSColor(calibratedRed: 0.74, green: 0.43, blue: 0.25, alpha: 1) : NSColor(calibratedRed: 0.64, green: 0.39, blue: 0.30, alpha: 1)).setFill(); body.fill()

        NSColor(calibratedRed: 0.84, green: 0.62, blue: 0.45, alpha: 0.98).setFill()
        NSBezierPath(ovalIn: NSRect(x: 363, y: bodyY + 30, width: 300, height: 235 * (0.97 + breath * 0.05))).fill()
        NSColor(calibratedRed: 0.45, green: 0.26, blue: 0.28, alpha: 0.85).setFill()
        NSBezierPath(ovalIn: NSRect(x: 245, y: 380, width: 150, height: 230)).fill()
        NSBezierPath(ovalIn: NSRect(x: 630, y: 380, width: 150, height: 230)).fill()

        if isDaytime {
            NSColor(calibratedRed: 1, green: 0.92, blue: 0.68, alpha: 1).setFill()
            NSBezierPath(ovalIn: NSRect(x: 307, y: 518, width: 185, height: 185)).fill()
            NSBezierPath(ovalIn: NSRect(x: 532, y: 518, width: 185, height: 185)).fill()
            NSColor(calibratedRed: 0.19, green: 0.12, blue: 0.16, alpha: 1).setFill()
            NSBezierPath(ovalIn: NSRect(x: 360, y: 548, width: 85, height: 112)).fill()
            NSBezierPath(ovalIn: NSRect(x: 585, y: 548, width: 85, height: 112)).fill()
            NSColor.white.setFill()
            NSBezierPath(ovalIn: NSRect(x: 379, y: 614, width: 27, height: 31)).fill()
            NSBezierPath(ovalIn: NSRect(x: 604, y: 614, width: 27, height: 31)).fill()
        } else {
            let eye = NSBezierPath()
            eye.move(to: NSPoint(x: 347, y: 593)); eye.curve(to: NSPoint(x: 470, y: 593), controlPoint1: NSPoint(x: 380, y: 551), controlPoint2: NSPoint(x: 437, y: 551))
            eye.move(to: NSPoint(x: 554, y: 593)); eye.curve(to: NSPoint(x: 677, y: 593), controlPoint1: NSPoint(x: 587, y: 551), controlPoint2: NSPoint(x: 644, y: 551))
            eye.lineWidth = 26; eye.lineCapStyle = .round
            NSColor(calibratedRed: 0.20, green: 0.12, blue: 0.16, alpha: 1).setStroke(); eye.stroke()
        }
        NSColor(calibratedRed: 0.84, green: 0.39, blue: 0.24, alpha: 1).setFill()
        triangle(NSPoint(x: 512, y: 555), NSPoint(x: 475, y: 507), NSPoint(x: 549, y: 507)).fill()

        if !isDaytime {
            let zLift = drift * 142
            let zAlpha = CGFloat(max(0, 0.88 - drift * 0.72))
            drawText("z", at: NSPoint(x: 744 + drift * 16, y: 600 + zLift), size: 75, alpha: zAlpha * 0.76)
            drawText("z", at: NSPoint(x: 802 + drift * 25, y: 680 + zLift), size: 99, alpha: zAlpha)
        }
        context.restoreGState()
        context.restoreGState()
    }

    private func triangle(_ a: NSPoint, _ b: NSPoint, _ c: NSPoint) -> NSBezierPath {
        let path = NSBezierPath(); path.move(to: a); path.line(to: b); path.line(to: c); path.close(); return path
    }

    private func drawText(_ text: String, at point: NSPoint, size: CGFloat, alpha: CGFloat) {
        let attributes: [NSAttributedString.Key: Any] = [.font: NSFont(name: "Georgia-Italic", size: size) ?? NSFont.systemFont(ofSize: size), .foregroundColor: NSColor(calibratedWhite: 1, alpha: alpha)]
        (text as NSString).draw(at: point, withAttributes: attributes)
    }
}

enum TranslationDirection: String, CaseIterable, Identifiable {
    case jaToEn, enToJa
    var id: Self { self }
    var label: String { self == .jaToEn ? "Japanese → English" : "English → Japanese" }
    var sourceLanguage: String { self == .jaToEn ? "ja" : "en" }
    var targetLanguage: String { self == .jaToEn ? "en" : "ja" }
}

struct ShisaResponse: Decodable {
    struct Choice: Decodable { struct Message: Decodable { let content: String }; let message: Message }
    let choices: [Choice]
}

enum ShisaError: LocalizedError {
    case missingKey, invalidResponse
    var errorDescription: String? {
        switch self { case .missingKey: return "Shisa key unavailable. Run from this project with npm run mac:run."; case .invalidResponse: return "Shisa returned an unreadable response." }
    }
}

enum Shisa {
    static func key() -> String? {
        if let key = ProcessInfo.processInfo.environment["SHISA_API_KEY"], !key.isEmpty { return key }
        var folder = Bundle.main.bundleURL
        for _ in 0..<3 {
            folder.deleteLastPathComponent()
            let envURL = folder.appendingPathComponent(".env")
            if let contents = try? String(contentsOf: envURL, encoding: .utf8), let line = contents.split(separator: "\n").first(where: { $0.hasPrefix("SHISA_API_KEY=") }) {
                return String(line.dropFirst("SHISA_API_KEY=".count)).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return nil
    }

    static func translate(_ text: String, direction: TranslationDirection) async throws -> String {
        guard let apiKey = key() else { throw ShisaError.missingKey }
        let boundary = "NightOwlBoundary"
        var request = URLRequest(url: URL(string: "https://api.shisa.ai/translate/")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart(["text": text, "source_lang": direction.sourceLanguage, "target_lang": direction.targetLanguage, "stream": "false"], boundary: boundary)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else { throw ShisaError.invalidResponse }
        guard let translated = try? JSONDecoder().decode(ShisaResponse.self, from: data).choices.first?.message.content else { throw ShisaError.invalidResponse }
        return translated
    }

    private static func multipart(_ values: [String: String], boundary: String) -> Data {
        var body = Data()
        for (name, value) in values {
            body.append("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"\r\n\r\n\(value)\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

@MainActor final class ControlCenterModel: ObservableObject {
    @Published var isDaytime = false { didSet { setDaytime(isDaytime) } }
    @Published var direction: TranslationDirection = .jaToEn
    @Published var sourceText = "おはよう。ゆっくり起きよう。"
    @Published var translatedText = ""
    @Published var isTranslating = false
    @Published var errorText = ""
    private let setDaytime: (Bool) -> Void

    init(setDaytime: @escaping (Bool) -> Void) { self.setDaytime = setDaytime }

    func swap() {
        direction = direction == .jaToEn ? .enToJa : .jaToEn
        sourceText = direction == .jaToEn ? "おはよう。ゆっくり起きよう。" : "Good morning. Let's wake up slowly."
        translatedText = ""; errorText = ""
    }

    func translate() {
        guard !sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isTranslating = true; translatedText = ""; errorText = ""
        let text = sourceText; let selectedDirection = direction
        Task {
            do { translatedText = try await Shisa.translate(text, direction: selectedDirection) }
            catch { errorText = error.localizedDescription }
            isTranslating = false
        }
    }
}

struct ControlCenterView: View {
    @StateObject private var model: ControlCenterModel
    init(setDaytime: @escaping (Bool) -> Void) { _model = StateObject(wrappedValue: ControlCenterModel(setDaytime: setDaytime)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack { VStack(alignment: .leading, spacing: 3) { Text("Night Owl").font(.system(size: 25, weight: .semibold)); Text("Control Center").foregroundStyle(.secondary) }; Spacer(); Text(model.isDaytime ? "DAYTIME" : "10 PM").font(.caption.weight(.bold)).foregroundStyle(model.isDaytime ? .orange : .indigo) }
            VStack(alignment: .leading, spacing: 10) {
                Text("Dock mood").font(.headline)
                Picker("Dock mood", selection: $model.isDaytime) { Text("☀︎ Awake").tag(true); Text("☾ Sleepy").tag(false) }.pickerStyle(.segmented)
                Text(model.isDaytime ? "Wide-eyed and ready for a gentle morning." : "Heavy, melted, and quietly breathing on the Dock.").font(.caption).foregroundStyle(.secondary)
            }.padding(14).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 10) {
                HStack { Text("シーサー").font(.headline); Spacer(); Text(model.direction.label).font(.caption).foregroundStyle(.secondary) }
                TextField(model.direction == .jaToEn ? "Japanese line" : "English line", text: $model.sourceText).textFieldStyle(.roundedBorder).onSubmit(model.translate)
                HStack { Button("⇄", action: model.swap).buttonStyle(.bordered); Spacer(); Button(model.isTranslating ? "Listening…" : "Translate", action: model.translate).buttonStyle(.borderedProminent).disabled(model.isTranslating) }
                if !model.translatedText.isEmpty { Text(model.translatedText).font(.system(size: 16, weight: .medium)).padding(10).frame(maxWidth: .infinity, alignment: .leading).background(Color.orange.opacity(0.13), in: RoundedRectangle(cornerRadius: 9)) }
                if !model.errorText.isEmpty { Text(model.errorText).font(.caption).foregroundStyle(.red) }
            }.padding(14).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
            Spacer()
        }.padding(24).frame(width: 470, height: 430).background(LinearGradient(colors: [Color(red: 0.12, green: 0.17, blue: 0.28), Color(red: 0.22, green: 0.17, blue: 0.25)], startPoint: .topLeading, endPoint: .bottomTrailing)).foregroundStyle(.white)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let tile = NSApp.dockTile
    private var timer: Timer?
    private var owl: DockOwlView?
    private var controlWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let owl = DockOwlView(frame: NSRect(origin: .zero, size: tile.size))
        self.owl = owl
        owl.autoresizingMask = [.width, .height]
        tile.contentView = owl
        let animationTimer = Timer(timeInterval: 1.0 / 20.0, repeats: true) { [weak self, weak owl] _ in
            owl?.tick(); self?.tile.display()
        }
        RunLoop.main.add(animationTimer, forMode: .common)
        timer = animationTimer
        showControlCenter()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showControlCenter()
        return true
    }

    private func showControlCenter() {
        if let controlWindow { controlWindow.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps: true); return }
        let view = ControlCenterView { [weak self] isDaytime in
            self?.owl?.isDaytime = isDaytime
            self?.tile.display()
        }
        let window = NSWindow(contentViewController: NSHostingController(rootView: view))
        window.title = "Night Owl Control Center"
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(nil)
        controlWindow = window
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
