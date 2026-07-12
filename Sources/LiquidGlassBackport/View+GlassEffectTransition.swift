import SwiftUI

public extension Backport where Content: View {
    /// Backport of SwiftUI `View.glassEffectTransition(_:)`.
    ///
    /// On Apple OS 26+ this forwards transition metadata to native Liquid Glass.
    /// On earlier OS versions and visionOS it leaves the content unchanged.
    @MainActor
    @ViewBuilder
    func glassEffectTransition(
        _ transition: Backported.GlassEffectTransition
    ) -> some View {
        #if os(visionOS)
        content
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            content.glassEffectTransition(transition.swiftUITransition)
        } else {
            content
        }
        #endif
    }
}
