import SwiftUI

@available(iOS, introduced: 17.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.SpacerSizing.")
@available(macOS, introduced: 14.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.SpacerSizing.")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public extension Backported {
    /// A backport value that controls how a toolbar spacer uses available space.
    struct SpacerSizing: Sendable {
        private enum Variant: Sendable {
            case fixed
            case flexible
        }

        private let variant: Variant

        private init(variant: Variant) {
            self.variant = variant
        }

        /// A spacer with a system-defined fixed size.
        public static let fixed = Self(variant: .fixed)

        /// A spacer that expands to consume available toolbar space.
        public static let flexible = Self(variant: .flexible)

        #if os(iOS) || os(macOS)
        @available(iOS 26.0, macOS 26.0, *)
        var spacerSizing: SwiftUI.SpacerSizing {
            switch variant {
            case .fixed:
                .fixed
            case .flexible:
                .flexible
            }
        }
        #endif
    }
}
