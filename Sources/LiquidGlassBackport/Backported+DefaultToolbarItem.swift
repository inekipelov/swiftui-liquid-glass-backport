import SwiftUI

@available(iOS, introduced: 17.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.DefaultToolbarItem.")
@available(macOS, introduced: 14.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.DefaultToolbarItem.")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, introduced: 1.0, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.DefaultToolbarItem.")
public extension Backported {
    /// Backport of SwiftUI `DefaultToolbarItem` for package-owned item kinds.
    ///
    /// On supported Apple OS 26 releases this forwards to SwiftUI. On earlier
    /// systems it inserts empty toolbar content instead of emulating search UI.
    struct DefaultToolbarItem: ToolbarContent {
        private let kind: ToolbarDefaultItemKind
        private let placement: ToolbarItemPlacement

        public init(
            kind: ToolbarDefaultItemKind,
            placement: ToolbarItemPlacement = .automatic
        ) {
            self.kind = kind
            self.placement = placement
        }

        @ToolbarContentBuilder
        public var body: some ToolbarContent {
            #if os(iOS) || os(macOS) || os(visionOS)
            if #available(iOS 26.0, macOS 26.0, visionOS 26.0, *) {
                SwiftUI.DefaultToolbarItem(
                    kind: kind.toolbarDefaultItemKind,
                    placement: placement
                )
            } else {
                ToolbarItem(placement: placement) {
                    EmptyView()
                }
            }
            #else
            ToolbarItem(placement: placement) {
                EmptyView()
            }
            #endif
        }
    }
}
