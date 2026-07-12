import SwiftUI

public extension Backported {
    /// A backport value for configuring Liquid Glass effect transitions.
    struct GlassEffectTransition: Sendable {
        private enum Variant: Sendable {
            case identity
            case matchedGeometry
            case materialize
        }

        private let variant: Variant

        private init(variant: Variant) {
            self.variant = variant
        }

        /// The identity transition specifying no changes.
        public static var identity: Self { Self(variant: .identity) }

        /// A transition that matches the geometry of compatible glass effects.
        public static var matchedGeometry: Self {
            Self(variant: .matchedGeometry)
        }

        /// A transition that materializes glass without geometry matching.
        public static var materialize: Self { Self(variant: .materialize) }

        #if !os(visionOS)
        @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
        var transition: SwiftUI.GlassEffectTransition {
            switch variant {
            case .identity:
                .identity
            case .matchedGeometry:
                .matchedGeometry
            case .materialize:
                .materialize
            }
        }
        #endif
    }
}
