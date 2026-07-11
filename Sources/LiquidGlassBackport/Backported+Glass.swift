import SwiftUI

public extension Backported {
    /// A backport value for configuring SwiftUI Liquid Glass.
    struct Glass: Sendable {
        enum Variant: Sendable {
            case regular
            case clear
            case identity
        }

        let variant: Variant
        let tintColor: Color?
        let isInteractive: Bool?

        private init(variant: Variant, tintColor: Color? = nil, isInteractive: Bool? = nil) {
            self.variant = variant
            self.tintColor = tintColor
            self.isInteractive = isInteractive
        }

        /// The standard Liquid Glass appearance.
        public static var regular: Self { Self(variant: .regular) }

        /// A less prominent Liquid Glass appearance.
        public static var clear: Self { Self(variant: .clear) }

        /// No Liquid Glass appearance.
        public static var identity: Self { Self(variant: .identity) }

        /// Returns a copy with the specified tint color.
        public func tint(_ color: Color?) -> Self {
            Self(variant: variant, tintColor: color, isInteractive: isInteractive)
        }

        /// Returns a copy with the specified interactivity setting.
        public func interactive(_ isEnabled: Bool = true) -> Self {
            Self(variant: variant, tintColor: tintColor, isInteractive: isEnabled)
        }

        /// Material used by the backport fallback on platforms without native Liquid Glass.
        @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
        public var material: Material? {
            switch variant {
            case .regular:
                .regularMaterial
            case .clear:
                .ultraThinMaterial
            case .identity:
                nil
            }
        }

        /// Tint overlay used by the backport fallback.
        public var color: Color {
            switch variant {
            case .regular:
                (tintColor ?? .white).opacity(tintColor == nil ? 0.06 : 0.18)
            case .clear:
                (tintColor ?? .white).opacity(tintColor == nil ? 0.025 : 0.10)
            case .identity:
                .clear
            }
        }

        /// Edge highlight used to separate the fallback surface from its background.
        public var edgeColor: Color {
            switch variant {
            case .regular:
                (tintColor ?? .white).opacity(tintColor == nil ? 0.28 : 0.32)
            case .clear:
                (tintColor ?? .white).opacity(tintColor == nil ? 0.16 : 0.20)
            case .identity:
                .clear
            }
        }

        /// Shadow used to preserve depth when native Liquid Glass is unavailable.
        public var shadowColor: Color {
            switch variant {
            case .regular:
                Color.black.opacity(0.14)
            case .clear:
                Color.black.opacity(0.08)
            case .identity:
                .clear
            }
        }

        #if !os(visionOS)
        @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
        public var glass: SwiftUI.Glass {
            let glass: SwiftUI.Glass = switch variant {
            case .regular: .regular
            case .clear: .clear
            case .identity: .identity
            }

            let interactiveGlass = if let isInteractive {
                glass.interactive(isInteractive)
            } else {
                glass
            }

            return interactiveGlass.tint(tintColor)
        }
        #endif
    }
}
