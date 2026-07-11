import Testing
@testable import LiquidGlassBackport

#if canImport(SwiftUI)
import SwiftUI

@Test("Backport glassEffect(_:in:) is available on View.backport")
@MainActor
func glassEffectBackportIsCallable() {
    let shape = RoundedRectangle(cornerRadius: 12)

    for glass in [
        Backported.Glass.regular.tint(.blue).interactive(true),
        .clear,
        .identity
    ] {
        _ = glass.color
        _ = glass.edgeColor
        _ = glass.shadowColor
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            _ = glass.material
        }

        let view = Text("Liquid Glass")
            .padding(12)
            .backport.glassEffect(glass, in: shape)

        _ = view
    }
}
#endif
