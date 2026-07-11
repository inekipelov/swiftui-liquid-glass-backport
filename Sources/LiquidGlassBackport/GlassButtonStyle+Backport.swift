import SwiftUI

public extension Backport where Content: PrimitiveButtonStyle {
    /// A backport of SwiftUI's default glass button style.
    @MainActor
    var glass: some PrimitiveButtonStyle {
        #if os(visionOS)
        return bordered
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            return .glass
        } else {
            return bordered
        }
        #endif
    }

    /// A backport of SwiftUI's configurable glass button style.
    @MainActor
    func glass(_ glass: Backported.Glass) -> some PrimitiveButtonStyle {
        #if os(visionOS)
        return .backport.bordered
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            return .glass(glass.glass)
        } else {
            return .backport.bordered
        }
        #endif
    }
}
