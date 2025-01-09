import SwiftUI

struct NotesViewer: View {
	@Environment(\.databaseStore) var databaseStore
	
	var body: some View {
		NotesNavigation(database: databaseStore!)
	}
}

private struct NotesNavigation: View {
	@Environment(\.databaseStore) var databaseStore
	
	@State private var notes: DatabaseStore.ObservableModel<[Note]>
	@State private var selectedNote: Note.ID?
	
	init(database: DatabaseStore) {
		let observable = try! database.observe(defaultValue: []) { transaction in
			try Note.fetchAll(using: transaction)
		}
		
		_notes = State(initialValue: observable)
	}
	
	var body: some View {
		NavigationSplitView {
			NotesListView(notes: notes.value, selection: $selectedNote)
				.navigationSplitViewColumnWidth(200)
		} detail: {
			NotesDetailView(noteId: selectedNote)
				.navigationTitle("")
		}
	}
}

#Preview {
	NotesViewer()
		.databaseStore(DatabaseStore.makeSampleDatabase())
}
