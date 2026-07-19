#if DEBUG && os(iOS)
import SwiftUI

@available(iOS 17.0, *)
private struct ButtonStylesPreview: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .cyan, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Explore Landmarks")
                        .font(.largeTitle.bold())
                    Text("Use glass styles for actions that float above content.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 14) {
                    Button {} label: {
                        Label("Learn More", systemImage: "book")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.backport.glass)

                    Button {} label: {
                        Label("Get Started", systemImage: "arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.backport.glassProminent)

                    Button {} label: {
                        Label("Add to Favorites", systemImage: "heart.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(
                        .backport.glass(
                            .regular.tint(.orange).interactive()
                        )
                    )
                }
                .controlSize(.large)
            }
            .padding(28)
            .frame(maxWidth: 420)
        }
    }
}

#Preview("Button styles") {
    if #available(iOS 17.0, *) {
        ButtonStylesPreview()
    } else {
        Text("Requires iOS 17 or later")
    }
}
#endif
