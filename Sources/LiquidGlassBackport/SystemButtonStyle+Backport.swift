import SwiftUI

extension Backport where Content: PrimitiveButtonStyle {
    /// A backport namespace entry for SwiftUI's borderless button style.
    @MainActor
    var borderless: some PrimitiveButtonStyle {
        #if os(tvOS)
        if #available(tvOS 17.0, *) {
            return .borderless
        } else {
            return .plain
        }
        #elseif os(watchOS)
        if #available(watchOS 8.0, *) {
            return .borderless
        } else {
            return .automatic
        }
        #else
        return .borderless
        #endif
    }

    /// A backport namespace entry for SwiftUI's bordered button style.
    @MainActor
    var bordered: some PrimitiveButtonStyle {
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 15.0, *) {
            return .bordered
        } else {
            return .backport.borderless
        }
        #elseif os(iOS)
        if #available(iOS 15.0, *) {
            return .bordered
        } else {
            return .backport.borderless
        }
        #elseif os(macOS)
        if #available(macOS 12.0, *) {
            return .bordered
        } else {
            return .backport.borderless
        }
        #elseif os(tvOS) || os(visionOS)
        return .bordered
        #elseif os(watchOS)
        if #available(watchOS 7.0, *) {
            return .bordered
        } else {
            return .automatic
        }
        #else
        return .bordered
        #endif
    }

    /// A backport namespace entry for SwiftUI's bordered prominent button style.
    @MainActor
    var borderedProminent: some PrimitiveButtonStyle {
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 15.0, *) {
            return .borderedProminent
        } else {
            return .borderless
        }
        #elseif os(iOS)
        if #available(iOS 15.0, *) {
            return .borderedProminent
        } else {
            return .borderless
        }
        #elseif os(macOS)
        if #available(macOS 12.0, *) {
            return .borderedProminent
        } else {
            return .borderless
        }
        #elseif os(tvOS)
        if #available(tvOS 15.0, *) {
            return .borderedProminent
        } else {
            return .bordered
        }
        #elseif os(watchOS)
        if #available(watchOS 8.0, *) {
            return .borderedProminent
        } else {
            return .automatic
        }
        #elseif os(visionOS)
        return .borderedProminent
        #else
        return .borderedProminent
        #endif
    }
}
