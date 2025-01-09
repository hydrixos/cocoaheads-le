import SwiftUI

struct NotesDetailView: View {
	@Environment(\.databaseStore) var databaseStore
	
	var noteId: Note.ID?
	@State private var editedNote: Note?
	
	var body: some View {
		Group {
			if let editedNote = Binding($editedNote) {
				NoteEditor(note: editedNote)
					.onChange(of: editedNote.wrappedValue) {
						try! databaseStore?.write { transaction in
							try editedNote.wrappedValue.save(using: transaction)
						}
					}
			} else {
				ContentUnavailableView {
					Text("No note selected.")
				}
			}
		}
		.toolbar { NotesDetailToolbar(note: editedNote) }
		.onChange(of: noteId, initial: true) { _,_ in loadNote() }
	}
	
	func loadNote() {
		if let noteId {
			editedNote = try! databaseStore?.read { transaction in
				try Note.fetch(id: noteId, using: transaction)
			}
		} else {
			editedNote = nil
		}
	}
}

#Preview("Active") {
	NotesDetailView(noteId: 2)
		.databaseStore(DatabaseStore.makeSampleDatabase())
}

#Preview("Empty") {
	NotesDetailView(noteId: nil)
}
