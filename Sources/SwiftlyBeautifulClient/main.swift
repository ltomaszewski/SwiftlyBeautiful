import SwiftlyBeautiful

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")


// Printable

@Printable
class Model {
    let abecadlo: String
    let lol: Int
    let kkkk: String
    let subModels: [SubModel]
    
    init(abecadlo: String, lol: Int) {
        self.abecadlo = abecadlo
        self.lol = lol
        self.kkkk = "ABBB"
        self.subModels = [.init(subText: "LOL")]
    }
}

@Printable
class SubModel {
    let subText: String
    
    init(subText: String) {
        self.subText = subText
    }
}

let testModel = Model(abecadlo: "ABBBB", lol: 4)

print(testModel.description)

// Model CRUD
import Foundation

// Mock ModelContext for testing purposes
class ModelContext {
    private var storage: [UUID: SleepSession] = [:]

    // Simulate inserting a new instance into the context
    func insert(_ instance: SleepSession) {
        storage[instance.id] = instance
    }

    // Simulate deleting an instance from the context
    func delete(_ instance: SleepSession) {
        storage.removeValue(forKey: instance.id)
    }

    // Simulate fetching all instances from the context
    func fetch(_ type: FetchDescriptor<SleepSession>) throws -> [SleepSession]  {
        return Array(storage.values)
    }

    // Simulate saving the context (this is a no-op in the mock)
    func save() throws {
        // In a real context, this would persist the data, but in the mock, we do nothing
    }

    // Helper method to retrieve a session by ID
    func findById(_ id: UUID) -> SleepSession? {
        return storage[id]
    }
}

// Mock Predicate type for SleepSession
struct Predicate<T> {
    let filter: (T) -> Bool
}

// Mock SortDescriptor for SleepSession
struct SortDescriptor<T> {
    let compare: (T, T) -> Bool
}

struct FetchDescriptor<T> {
    var predicate: Predicate<T>?
    var sortBy: [SortDescriptor<T>]?
}

@SwiftDataCRUD
class SleepSession {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var type: String
    
    init(id: UUID = UUID(), startDate: Date, endDate: Date, type: String) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
    }
}

let newSleepSession = SleepSession(startDate: Date(), endDate: Date(), type: "ABB")

