import SwiftUI

@available(
    iOS,
    deprecated: 26.0,
    obsoleted: 27.0,
    message: "Use SwiftUI's native background extension effect."
)
@available(
    macOS,
    deprecated: 26.0,
    obsoleted: 27.0,
    message: "Use SwiftUI's native background extension effect."
)
@available(
    tvOS,
    deprecated: 26.0,
    obsoleted: 27.0,
    message: "Use SwiftUI's native background extension effect."
)
@available(
    watchOS,
    deprecated: 26.0,
    obsoleted: 27.0,
    message: "Use SwiftUI's native background extension effect."
)
@available(
    visionOS,
    deprecated: 26.0,
    obsoleted: 27.0,
    message: "Use SwiftUI's native background extension effect."
)
public extension Backport where Content: View {
    /// Backport of SwiftUI `View.backgroundExtensionEffect()`.
    ///
    /// On Apple OS 26+ this forwards to SwiftUI's native background extension
    /// effect. On earlier OS versions it leaves the content unchanged.
    @MainActor
    @ViewBuilder
    func backgroundExtensionEffect() -> some View {
        if #available(
            iOS 26.0,
            macOS 26.0,
            tvOS 26.0,
            watchOS 26.0,
            visionOS 26.0,
            *
        ) {
            content.backgroundExtensionEffect()
        } else {
            content
        }
    }

    /// Backport of SwiftUI `View.backgroundExtensionEffect(isEnabled:)`.
    ///
    /// On Apple OS 26+ this forwards to SwiftUI's native background extension
    /// effect. On earlier OS versions it leaves the content unchanged.
    @MainActor
    @ViewBuilder
    func backgroundExtensionEffect(isEnabled: Bool) -> some View {
        if #available(
            iOS 26.0,
            macOS 26.0,
            tvOS 26.0,
            watchOS 26.0,
            visionOS 26.0,
            *
        ) {
            content.backgroundExtensionEffect(isEnabled: isEnabled)
        } else {
            content
        }
    }
}
