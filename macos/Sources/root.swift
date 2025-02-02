import AppKit
import SwiftUI

var image : NSImage? = nil

struct ContentView: View {
    let height = 100
    let width = 100
    var body: some View {
        Image(nsImage: image!)
            .frame(width: 200, height: 200)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var contentView = ContentView()

    func applicationDidFinishLaunching(_ notifiaction: Notification) {
        self.window = NSWindow(
            contentRect: .zero,
            styleMask: [.closable, .resizable, .titled],
            backing: .buffered,
            defer: false
        )
        window.contentView = NSHostingView(rootView: contentView)

        self.window.makeKey()
        window.center()
        window.orderFrontRegardless()
    }
}

@_silgen_name("showImage")
public func showImage (c_buffer: UnsafeMutablePointer<UInt8>) {
    print("from swift: \(c_buffer[0])");
    let buffer = c_buffer + 1

    let planes = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 3)
    planes[0] = buffer
    planes[1] = buffer + 1024
    planes[2] = buffer + 2048

    let bitmapRep = NSBitmapImageRep(
        bitmapDataPlanes: planes,
        pixelsWide: 32,
        pixelsHigh: 32,
        bitsPerSample: 8,
        samplesPerPixel: 3,
        hasAlpha: false,
        isPlanar: true,
        colorSpaceName: .deviceRGB,
        bitmapFormat: .alphaNonpremultiplied,
        bytesPerRow: 32,
        bitsPerPixel: 8
    )

    if let cgImage = bitmapRep?.cgImage {
        image = NSImage(cgImage: cgImage, size: NSSize(width: 150, height: 150))
    }  else {
        print("Failed to retrieve CGImage")
    }

    let delegate = AppDelegate()
    let app = NSApplication.shared
    app.delegate = delegate
    app.setActivationPolicy(.regular)
    app.activate(ignoringOtherApps: true)
    app.run()
}
