import Foundation

public protocol Repository {
    associatedtype DS: DataSource
    func get() throws -> DS.Object
    var dataSource: DS { get }
}

extension Repository where DS: DataSource {

    public func get() throws -> DS.Object {
        return try self.dataSource.does()
    }
}

extension Repository where DS: DataSourceCacheCapable {
    
    public func get() throws -> DS.Object {
        guard let cached = try self.dataSource.get() else {
            let response = try self.dataSource.does()
            try self.dataSource.save(response)
            return response
        }
        return cached
    }
}
