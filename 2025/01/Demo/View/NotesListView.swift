import SwiftUI

struct NotesListView: View {
	var notes: [Note]
	@Binding var selection: Note.ID?
	
	var body: some View {
		ZStack {
			List(selection: $selection) {
				ForEach(notes) { note in
					HStack {
						Image(systemName: "note")
							.foregroundStyle(note.color.color)
						
						Text(note.title)
					}
				}
			}

			if notes.isEmpty {
				ContentUnavailableView {
					Text("No notes.")
				}
			}
		}.toolbar {
			NotesListToolbar()
		}
	}
}

#Preview("Dummy Contents", traits: .sizeThatFitsLayout) {
	@Previewable @State var selection: Note.ID?
	
	NotesListView(notes: Note.sampleNotes, selection: $selection)
}

#Preview("Empty", traits: .sizeThatFitsLayout) {
	@Previewable @State var selection: Note.ID?
	
	NotesListView(notes: [], selection: $selection)
}

