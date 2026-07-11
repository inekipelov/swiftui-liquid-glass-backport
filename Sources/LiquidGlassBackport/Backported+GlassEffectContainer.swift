import SwiftUI

public extension Backported {
    @MainActor
    @preconcurrency
    struct GlassEffectContainer<ContainerContent: View>: View {
        private let spacing: CGFloat?
        private let content: ContainerContent

        public init(
            spacing: CGFloat? = nil,
            @ViewBuilder content: () -> ContainerContent
        ) {
            self.spacing = spacing
            self.content = content()
        }

        @ViewBuilder
        public var body: some View {
            #if os(visionOS)
            content
            #else
            if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
                SwiftUI.GlassEffectContainer(spacing: spacing) {
                    content
                }
            } else {
                content
            }
            #endif
        }
    }
}
