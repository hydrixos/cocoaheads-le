import GRDB

struct Note: Identifiable, Equatable, Codable {
	var id: Int64?
	
	var title: String
	var color: Color
	var content: String
	
	enum Color: String, Codable, Equatable {
		case `default`
		case red
		case green
		case blue
	}
}

extension Note: FetchableRecord, MutablePersistableRecord {
}

// MARK: - Operations

extension Note {
	static func fetch(id: Note.ID, using transaction: DatabaseStore.ReadTransaction) throws -> Note? {
		try Note
			.fetchOne(transaction.db, id: id)
	}
	
	static func fetchAll(using transaction: DatabaseStore.ReadTransaction) throws -> [Note] {
		try Note
			.all()
			.order(Column(CodingKeys.title))
			.fetchAll(transaction.db)
	}
	
	static func create(title: String, using transaction: DatabaseStore.WriteTransaction) throws -> Note {
		try Note(id: nil, title: title, color: .default, content: "")
			.saveAndFetch(transaction.db)!
	}
	
	func delete(using transaction: DatabaseStore.WriteTransaction) throws {
		try Note
			.filter(key: id)
			.deleteAll(transaction.db)
	}
	
	func save(using transaction: DatabaseStore.WriteTransaction) throws {
		_ = try self
			.saved(transaction.db)
	}
}

// MARK: - Sample data

extension Note {
	static let sampleNotes = [
		Note(id: 1, title: "Hello World", color: .default, content: "10 PRINT \"HELLO WORLD\"\n20 GOTO 10"),
		Note(id: 2, title: "Do not forget", color: .red, content: "This is some super important note!"),
		Note(id: 3, title: "Books to read", color: .green, content: "- How to use GRDB with Swift UI\n- GRDB for Dummies")
	]
}

// MARK: - UI support

extension Note.Color: Identifiable, CaseIterable {
	var id: String { self.rawValue }
}
