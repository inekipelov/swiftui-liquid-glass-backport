#if DEBUG && os(iOS)
import SwiftUI

private struct PreviewMessage: Identifiable {
    let id: Int
    let sender: String
    let subject: String
    let systemImage: String
}

@available(iOS 17.5, *)
private struct SearchAPIPreview: View {
    @State private var query = ""

    private let messages = [
        PreviewMessage(
            id: 1,
            sender: "Apple Park",
            subject: "Welcome to Cupertino",
            systemImage: "building.2.fill"
        ),
        PreviewMessage(
            id: 2,
            sender: "Yosemite",
            subject: "Trail conditions",
            systemImage: "mountain.2.fill"
        ),
        PreviewMessage(
            id: 3,
            sender: "Ocean Beach",
            subject: "Sunset forecast",
            systemImage: "sun.horizon.fill"
        )
    ]

    private var filteredMessages: [PreviewMessage] {
        guard !query.isEmpty else {
            return messages
        }

        return messages.filter {
            $0.sender.localizedCaseInsensitiveContains(query)
                || $0.subject.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredMessages) { message in
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.sender)
                            .font(.headline)
                        Text(message.subject)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: message.systemImage)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .navigationTitle("Inbox")
            .searchable(text: $query, prompt: "Search messages")
            .backport.searchToolbarBehavior(.minimize)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Filter", systemImage: "line.3.horizontal.decrease") {}
                }

                Backported.ToolbarSpacer(
                    .flexible,
                    placement: .bottomBar
                )

                Backported.DefaultToolbarItem(
                    kind: .search,
                    placement: .bottomBar
                )

                Backported.ToolbarSpacer(
                    .fixed,
                    placement: .bottomBar
                )

                ToolbarItem(placement: .bottomBar) {
                    Button("Compose", systemImage: "square.and.pencil") {}
                }
            }
        }
    }
}

#Preview("Search API") {
    if #available(iOS 17.5, *) {
        SearchAPIPreview()
    } else {
        Text("Requires iOS 17.5 or later")
    }
}
#endif
