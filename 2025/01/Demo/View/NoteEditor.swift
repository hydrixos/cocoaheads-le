import SwiftUI

struct NoteEditor: View {
	@Binding var note: Note
	
	var body: some View {
		Form {
			TextField("Titel", text: $note.title)
			
			Picker("Color", selection: $note.color) {
				ForEach(Note.Color.allCases) { color in
					Text(color.rawValue.capitalized)
						.foregroundColor(color.color)
						.tag(color)
				}
			}
			
			TextEditor(text: $note.content)
				.padding()
				.background(Color(.textBackgroundColor))
		}.labelsHidden()
	}
}

#Preview {
	@Previewable @State var note = Note(id: 1, title: "Some Title", color: .red, content: "Some Content")
	
	NoteEditor(note: $note)
}
