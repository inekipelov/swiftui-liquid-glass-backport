import SwiftUI

@available(iOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native button styles.")
@available(macOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native button styles.")
@available(tvOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native button styles.")
@available(watchOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native button styles.")
public extension Backport where Content: PrimitiveButtonStyle {
    /// A backport of SwiftUI's prominent glass button style.
    @MainActor
    var glassProminent: some PrimitiveButtonStyle {
        #if os(visionOS)
        return .backport.borderedProminent
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            return .glassProminent
        } else {
            return .backport.borderedProminent
        }
        #endif
    }
}
