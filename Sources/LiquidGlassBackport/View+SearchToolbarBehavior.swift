import SwiftUI

@available(iOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(macOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(tvOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(watchOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(visionOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
public extension Backport where Content: View {
    /// Backport of SwiftUI `View.searchToolbarBehavior(_:)`.
    ///
    /// On Apple OS 26+ this forwards to SwiftUI. On earlier systems it leaves
    /// the content unchanged.
    @MainActor
    @ViewBuilder
    func searchToolbarBehavior(
        _ behavior: Backported.SearchToolbarBehavior
    ) -> some View {
        if #available(
            iOS 26.0,
            macOS 26.0,
            tvOS 26.0,
            watchOS 26.0,
            visionOS 26.0,
            *
        ) {
            content.searchToolbarBehavior(behavior.searchToolbarBehavior)
        } else {
            content
        }
    }
}
