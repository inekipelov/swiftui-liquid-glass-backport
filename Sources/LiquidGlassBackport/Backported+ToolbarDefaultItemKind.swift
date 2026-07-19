import SwiftUI

@available(iOS, introduced: 17.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.ToolbarDefaultItemKind.")
@available(macOS, introduced: 14.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.ToolbarDefaultItemKind.")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, introduced: 1.0, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.ToolbarDefaultItemKind.")
public extension Backported {
    /// A backport value identifying a system-provided toolbar item.
    struct ToolbarDefaultItemKind: Sendable {
        private enum Variant: Sendable {
            case search
        }

        private let variant: Variant

        private init(variant: Variant) {
            self.variant = variant
        }

        /// The default item associated with searchable content.
        public static let search = Self(variant: .search)

        #if os(iOS) || os(macOS) || os(visionOS)
        @available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
        var toolbarDefaultItemKind: SwiftUI.ToolbarDefaultItemKind {
            switch variant {
            case .search:
                .search
            }
        }
        #endif
    }
}
