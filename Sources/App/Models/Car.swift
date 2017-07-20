import Vapor
import FluentProvider
import HTTP

final class Car: Model {
    let storage = Storage()
    
    var name: String
    var color: String
    var milesDriven: Int
    
    
    init(row: Row) throws {
        name = try row.get("name")
        color = try row.get("color")
        milesDriven = try row.get("milesDriven")
    }
    
    init(name: String, color: String, milesDriven: Int) {
        self.name = name
        self.color = color
        self.milesDriven = milesDriven
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("color", color)
        try row.set("milesDriven", milesDriven)
        
        return row
    }
}

extension Car: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { friends in
            friends.id()
            friends.string("name")
            friends.string("color")
            friends.int("milesDriven")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Car: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("color", color)
        try json.set("milesDriven", milesDriven)
        return json
    }
}

// This allows Post models to be returned
// directly in route closures
extension Car: ResponseRepresentable { }
