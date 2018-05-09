import Vapor
import FluentSQLite

final class Talk: Codable {
    var id: Int?
    var title: String
    var type: String
    var sequence: Int
    var startTime: String
    var endTime: String
    
    init(title: String, type: String, sequence: Int, startTime: String, endTime: String) {
        self.title = title
        self.type = type
        self.sequence = sequence
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension Talk: SQLiteModel {}
extension Talk: Migration {}
extension Talk: Content {}
extension Talk: Parameter {}

