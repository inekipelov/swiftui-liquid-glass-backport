#if DEBUG && os(iOS)
import SwiftUI

@available(iOS 17.0, *)
private struct CustomViewsPreview: View {
    @State private var isExpanded = true
    @Namespace private var namespace

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Backported.GlassEffectContainer(spacing: 20) {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        badge(
                            "sun.max.fill",
                            id: "sun",
                            tint: .orange
                        )

                        if isExpanded {
                            badge(
                                "cloud.rain.fill",
                                id: "rain",
                                tint: .blue
                            )
                            badge(
                                "wind",
                                id: "wind",
                                tint: .mint
                            )
                        }
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Label(
                            isExpanded ? "Collapse" : "Expand",
                            systemImage: isExpanded
                                ? "rectangle.compress.vertical"
                                : "rectangle.expand.vertical"
                        )
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .backport.glassEffect(
                        .regular.tint(.purple).interactive(),
                        in: Capsule()
                    )
                    .backport.glassEffectID("toggle", in: namespace)
                    .backport.glassEffectTransition(.matchedGeometry)
                }
            }
        }
    }

    private func badge(
        _ systemImage: String,
        id: String,
        tint: Color
    ) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: 30, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 72, height: 72)
            .backport.glassEffect(
                .regular.tint(tint),
                in: RoundedRectangle(cornerRadius: 20)
            )
            .backport.glassEffectID(id, in: namespace)
            .backport.glassEffectTransition(.matchedGeometry)
    }
}

#Preview("Custom views") {
    if #available(iOS 17.0, *) {
        CustomViewsPreview()
    } else {
        Text("Requires iOS 17 or later")
    }
}
#endif
