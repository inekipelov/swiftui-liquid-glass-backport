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

@Test("Internal button style fallbacks remain available to glass styles")
@MainActor
func internalButtonStyleFallbacksRemainAvailable() {
    _ = Button("Borderless") {}
        .buttonStyle(.backport.borderless)
    _ = Button("Bordered") {}
        .buttonStyle(.backport.bordered)
    _ = Button("Prominent") {}
        .buttonStyle(.backport.borderedProminent)
}

@Test("Button style backport exposes glass styles")
@MainActor
func buttonStyleBackportExposesGlassStyles() {
    _ = Button("Glass") {}
        .buttonStyle(.backport.glass)
    _ = Button("Prominent") {}
        .buttonStyle(.backport.glassProminent)
    _ = Button("Configured") {}
        .buttonStyle(
            .backport.glass(.regular.interactive(true).tint(.blue))
        )
}

private struct GlassEffectIDTestIdentifier: Hashable, Sendable {
    let rawValue: Int
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct GlassEffectIDCallSite: View {
    @Namespace private var namespace

    var body: some View {
        VStack {
            Text("String")
                .backport.glassEffectID("string", in: namespace)
            Text("Custom")
                .backport.glassEffectID(
                    GlassEffectIDTestIdentifier(rawValue: 1),
                    in: namespace
                )

            let identifier: String? = nil
            Text("Nil")
                .backport.glassEffectID(identifier, in: namespace)
        }
    }
}

@Test("Backport glassEffectID(_:in:) accepts supported identifiers")
@MainActor
func glassEffectIDBackportAcceptsSupportedIdentifiers() {
    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
        _ = GlassEffectIDCallSite()
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct GlassEffectUnionCallSite: View {
    @Namespace private var namespace

    var body: some View {
        VStack {
            Text("String")
                .backport.glassEffectUnion(id: "string", namespace: namespace)
            Text("Custom")
                .backport.glassEffectUnion(
                    id: GlassEffectIDTestIdentifier(rawValue: 1),
                    namespace: namespace
                )

            let identifier: String? = nil
            Text("Nil")
                .backport.glassEffectUnion(id: identifier, namespace: namespace)
        }
    }
}

@Test("Backport glassEffectUnion(id:namespace:) accepts supported identifiers")
@MainActor
func glassEffectUnionBackportAcceptsSupportedIdentifiers() {
    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
        _ = GlassEffectUnionCallSite()
    }
}

@Test("Backport glassEffectTransition(_:) supports all transition variants")
@MainActor
func glassEffectTransitionBackportSupportsAllVariants() {
    let transitions: [Backported.GlassEffectTransition] = [
        .identity,
        .matchedGeometry,
        .materialize
    ]

    for transition in transitions {
        let view = Text("Liquid Glass")
            .backport.glassEffect()
            .backport.glassEffectTransition(transition)

        _ = view
    }

    _ = Text("Matched Geometry")
        .backport.glassEffectTransition(.matchedGeometry)
    _ = Text("Materialize")
        .backport.glassEffectTransition(.materialize)
}
#endif
