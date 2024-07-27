import AppKit
import SwiftUI

private let iconSize: CGFloat = 1024

extension NSImage {
    @MainActor func applyBadge(text: String) -> NSImage? {
        // initialize the Icon struct you just creataed in the previous section, and set its frame to 1024x1024.
        let icon = Icon(image: self, badgeText: text)
            .frame(width: iconSize, height: iconSize)
        // use the icon to initialize an ImageRenderer instance.
        let renderer = ImageRenderer(content: icon)
        // return the NSImage that the renderer creates from the icon contents.
        return renderer.nsImage
    }
}

struct Icon: View {
    let image: NSImage
    let badgeText: String

    var body: some View {
        ZStack {
            Image(nsImage: image)
            
            VStack {
                Spacer()
                Text(badgeText)
                    .font(.system(size: 140, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 100)
                    .background(Color.yellow.opacity(0.7))
            }
        }
        .background(.white)
    }
}
