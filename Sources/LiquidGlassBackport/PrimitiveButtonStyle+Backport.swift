import SwiftUI

public extension PrimitiveButtonStyle where Self == DefaultButtonStyle {
    /// A namespace for `DefaultButtonStyle` backports.
    @MainActor @preconcurrency
    static var backport: Backport<Self> {
        Backport(DefaultButtonStyle())
    }
}
