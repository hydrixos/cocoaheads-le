import GRDB
import Foundation

struct DatabaseStore {
	/// Access to the database
	private let database: any DatabaseWriter
	
	init(_ database: any DatabaseWriter) throws {
		self.database = database
		
		try migrate()
	}
}

// MARK: - Loading

extension DatabaseStore {
	/// Creates a production database
	static func loadProductionDatabase() throws -> DatabaseStore {
		let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(component: "notes.sqlite")
		let database = try DatabaseQueue(path: baseURL.path)
		return try DatabaseStore(database)
	}
	
	/// Creates a database that only exists temporary within memory.
	static func makeSampleDatabase() -> DatabaseStore {
		let database = try! DatabaseQueue(named: nil)
		let store = try! DatabaseStore(database)
		
		_ = try! store.write { transaction in
			for note in Note.sampleNotes {
				_ = try note.save(using: transaction)
			}
		}
		
		return store
	}
}

// MARK: - Migration

extension DatabaseStore {
	func migrate() throws {
		var migrator = DatabaseMigrator()
		
		#if DEBUG
		migrator.eraseDatabaseOnSchemaChange = true
		#endif
		
		migrator.registerMigration("Adding Notes") { db in
			try db.create(table: "note") { table in
				table.autoIncrementedPrimaryKey("id")

				table.column("title", .text).notNull()
				table.column("color", .text)
				table.column("content", .text)
			}
		}
		
		try migrator.migrate(database)
	}
}

// MARK: - Transactions

extension DatabaseStore {
	struct ReadTransaction {
		var db: Database
	}
	
	struct WriteTransaction {
		var db: Database
		
		var readTransaction: ReadTransaction { ReadTransaction(db: db) }
	}
	
	func read<T>(_ closure: (_ transaction: ReadTransaction) throws -> T) throws -> T {
		try database.read { db in
			try closure(ReadTransaction(db: db))
		}
	}

	func write<T>(_ closure: (_ transaction: WriteTransaction) throws -> T) throws -> T {
		try database.write { db in
			try closure(WriteTransaction(db: db))
		}
	}

}


// MARK: - Observation

extension DatabaseStore {
	@MainActor func observe<T>(defaultValue: T, closure: @escaping (ReadTransaction) throws -> T) throws -> ObservableModel<T> {
		try ObservableModel(defaultValue: defaultValue, database: database, closure: closure)
	}
	
	@Observable @MainActor class ObservableModel<T> {
		private(set) var value: T
		@ObservationIgnored private var cancellable: AnyDatabaseCancellable? = nil
		
		init(defaultValue: T, database: any DatabaseReader, closure: @escaping (ReadTransaction) throws -> T) rethrows {
			value = defaultValue
			
			let observation = ValueObservation.tracking { db in
				try! closure(ReadTransaction(db: db))
			}
			
			cancellable = observation.start(in: database) { error in
				print(error)
			} onChange: { [weak self] result in
				self?.value = result
			}
		}
	}
}

