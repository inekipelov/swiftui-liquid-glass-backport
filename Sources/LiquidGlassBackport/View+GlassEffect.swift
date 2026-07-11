import SwiftUI

public extension Backport where Content: View {
    /// Backport of SwiftUI `View.glassEffect(_:in:)`.
    ///
    /// On Apple OS 26+ this forwards to native Liquid Glass.
    /// On earlier OS versions it applies a material-based fallback in the same shape.
    @MainActor
    @ViewBuilder
    func glassEffect<S: Shape>(
        _ glass: Backported.Glass = .regular,
        in shape: S = Capsule()
    ) -> some View {
        #if os(visionOS)
        if #available(visionOS 26.0, *) {
            content.glassEffect(in: shape)
        } else {
            content.legacyGlassEffect(glass, in: shape)
        }
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            content.glassEffect(glass.glass, in: shape)
        } else {
            content.legacyGlassEffect(glass, in: shape)
        }
        #endif
    }
}

private extension View {
    @MainActor
    @ViewBuilder
    func legacyGlassEffect<S: Shape>(_ glass: Backported.Glass, in shape: S) -> some View {
        if glass.isIdentity {
            self
        } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            if let material = glass.material {
                background {
                    shape
                        .fill(material)
                        .overlay(shape.fill(glass.color))
                }
                .clipShape(shape)
                .overlay(shape.stroke(glass.edgeColor, lineWidth: 0.5))
                .shadow(color: glass.shadowColor, radius: 8, y: 2)
            } else {
                self
            }
        } else {
            background(glass.color)
                .clipShape(shape)
                .overlay(shape.stroke(glass.edgeColor, lineWidth: 0.5))
                .shadow(color: glass.shadowColor, radius: 8, y: 2)
        }
    }
}

private extension Backported.Glass {
    var isIdentity: Bool {
        if case .identity = variant {
            true
        } else {
            false
        }
    }
}
