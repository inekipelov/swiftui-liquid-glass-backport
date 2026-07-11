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
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 1.0, *) {
            _ = glass.material
        }

        let view = Text("Liquid Glass")
            .padding(12)
            .backport.glassEffect(glass, in: shape)

        _ = view
    }
}

@Test("GlassEffectContainer supports default spacing")
@MainActor
func glassEffectContainerSupportsDefaultSpacing() {
    let container = Backported.GlassEffectContainer {
        Text("Glass")
            .backport.glassEffect()
    }

    _ = container
}

@Test("GlassEffectContainer supports explicit spacing and multiple children")
@MainActor
func glassEffectContainerSupportsSpacingAndMultipleChildren() {
    let container = Backported.GlassEffectContainer(spacing: 16) {
        Text("First")
            .backport.glassEffect()
        Text("Second")
            .backport.glassEffect()
    }

    _ = container
}

@Test("Button style backport exposes system fallback styles")
@MainActor
func buttonStyleBackportExposesSystemFallbackStyles() {
    _ = Button("Borderless") {}
        .buttonStyle(.backport.borderless)
    _ = Button("Bordered") {}
        .buttonStyle(.backport.bordered)
    _ = Button("Prominent") {}
        .buttonStyle(.backport.borderedProminent)
}
#endif
