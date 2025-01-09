import SwiftUI

struct NotesDetailToolbar: ToolbarContent {
	@Environment(\.databaseStore) var databaseStore
	var note: Note?
	
	var body: some ToolbarContent {
		ToolbarItem(placement: .automatic) {
			Button {
				_ = try! databaseStore?.write { transaction in
					try note?.delete(using: transaction)
				}
			} label: {
				Image(systemName: "trash")
			}
			.disabled( note == nil )
		}
	}
}

#Preview {
	NavigationSplitView {
		List { }
	} detail: {
		VStack { }
		.toolbar {
			NotesDetailToolbar(note: Note.sampleNotes.first)
		}
	}
}
