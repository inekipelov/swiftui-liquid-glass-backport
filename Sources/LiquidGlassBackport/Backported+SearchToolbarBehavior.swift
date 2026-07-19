import SwiftUI

@available(iOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(macOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(tvOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(watchOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
@available(visionOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native search toolbar behavior.")
public extension Backported {
    /// A backport value that controls how searchable content appears in a toolbar.
    struct SearchToolbarBehavior: Hashable, Sendable {
        private enum Variant: Hashable, Sendable {
            case automatic
            case minimize
        }

        private let variant: Variant

        private init(variant: Variant) {
            self.variant = variant
        }

        /// The system chooses the search presentation behavior.
        public static var automatic: Self { Self(variant: .automatic) }

        /// The search field minimizes when the user scrolls.
        @available(macOS, unavailable)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        public static var minimize: Self { Self(variant: .minimize) }

        @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
        var searchToolbarBehavior: SwiftUI.SearchToolbarBehavior {
            switch variant {
            case .automatic:
                .automatic
            case .minimize:
                #if os(iOS) || os(visionOS)
                .minimize
                #else
                .automatic
                #endif
            }
        }
    }
}
