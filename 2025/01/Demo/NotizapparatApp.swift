import SwiftUI

@main
struct NotizapparatApp: App {
    var body: some Scene {
        WindowGroup {
            NotesViewer()
                .databaseStore(try! DatabaseStore.loadProductionDatabase())
                .navigationTitle("")
        }
    }
}

// MARK: - Database access

extension EnvironmentValues {
    @Entry var databaseStore: DatabaseStore? = nil
}

extension View {
    func databaseStore(_ databaseStore: DatabaseStore) -> some View {
        self.environment(\.databaseStore, databaseStore)
    }
}
