import SwiftUI

@available(iOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
@available(macOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
@available(tvOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
@available(watchOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
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
            content.glassEffectTransition(transition.transition)
        } else {
            content
        }
        #endif
    }
}
