import SwiftUI

@available(iOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
@available(macOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
@available(tvOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
@available(watchOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI Liquid Glass APIs directly.")
public extension Backport where Content: View {
    /// Backport of SwiftUI `View.glassEffectUnion(id:namespace:)`.
    ///
    /// On Apple OS 26+ this forwards union metadata to native Liquid Glass.
    /// On earlier OS versions and visionOS it leaves the content unchanged.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @MainActor
    @ViewBuilder
    func glassEffectUnion<ID: Hashable & Sendable>(
        id: ID?,
        namespace: Namespace.ID
    ) -> some View {
        #if os(visionOS)
        content
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            content.glassEffectUnion(id: id, namespace: namespace)
        } else {
            content
        }
        #endif
    }
}
