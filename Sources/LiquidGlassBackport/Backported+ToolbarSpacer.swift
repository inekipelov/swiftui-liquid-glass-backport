import Foundation
import SwiftUI

@available(iOS, introduced: 17.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.ToolbarSpacer.")
@available(macOS, introduced: 14.5, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI.ToolbarSpacer.")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public extension Backported {
    /// Backport of SwiftUI `ToolbarSpacer`.
    ///
    /// On iOS 26 and macOS 26 this forwards to SwiftUI. On earlier systems it
    /// inserts empty customizable toolbar content.
    struct ToolbarSpacer: ToolbarContent, CustomizableToolbarContent {
        private let sizing: SpacerSizing
        private let placement: ToolbarItemPlacement
        private let fallbackID: String

        public init(
            _ sizing: SpacerSizing = .flexible,
            placement: ToolbarItemPlacement = .automatic
        ) {
            self.sizing = sizing
            self.placement = placement
            fallbackID = UUID().uuidString
        }

        @ToolbarContentBuilder
        public var body: some CustomizableToolbarContent {
            #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 26.0, *) {
                SwiftUI.ToolbarSpacer(
                    sizing.spacerSizing,
                    placement: placement
                )
            } else {
                ToolbarItem(id: fallbackID, placement: placement) {
                    EmptyView()
                }
            }
            #else
            ToolbarItem(id: fallbackID, placement: placement) {
                EmptyView()
            }
            #endif
        }
    }
}
