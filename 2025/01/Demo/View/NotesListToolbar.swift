import SwiftUI

struct NotesListToolbar: ToolbarContent {
	@Environment(\.databaseStore) var databaseStore
	
	var body: some ToolbarContent {
		ToolbarItem {
			Button {
				_ = try! databaseStore?.write { transaction in
					try Note.create(title: "Ohne Titel", using: transaction)
				}
			} label: {
				Image(systemName: "plus")
			}
		}
	}
}

#Preview {
	NavigationSplitView {
		List { }
	} detail: {
		VStack { }
		.toolbar {
			NotesListToolbar()
		   }
	}
	.navigationTitle("")

}
