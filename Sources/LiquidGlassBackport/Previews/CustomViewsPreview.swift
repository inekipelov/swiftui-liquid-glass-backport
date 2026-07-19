#if DEBUG && os(iOS)
import SwiftUI

@available(iOS 17.0, *)
private struct CustomViewsPreview: View {
    @State private var isExpanded = true
    @Namespace private var namespace

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .pink, .orange, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Backported.GlassEffectContainer(spacing: 40.0) {
                    HStack(spacing: 40.0) {
                        Image(systemName: "scribble.variable")
                            .frame(width: 80.0, height: 80.0)
                            .font(.system(size: 36))
                            .backport.glassEffect()
                            .backport.glassEffectID("pencil", in: namespace)


                        if isExpanded {
                            Image(systemName: "eraser.fill")
                                .frame(width: 80.0, height: 80.0)
                                .font(.system(size: 36))
                                .backport.glassEffect()
                                .backport.glassEffectID("eraser", in: namespace)
                        }
                    }
                }

                Button("Toggle") {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .buttonStyle(.backport.glass)
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
