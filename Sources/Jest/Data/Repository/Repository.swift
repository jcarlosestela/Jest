import Foundation

public protocol Repository {
    associatedtype DS: DataSource
    func get(request: DS.RequestType) throws -> DS.Object
    var dataSource: DS { get }
}

extension Repository where DS: DataSource {

    public func get(request: DS.RequestType) throws -> DS.Object {
        return try self.dataSource.does(request: request)
    }
}

extension Repository where DS: DataSourceCacheCapable {
    
    public func get(request: DS.RequestType) throws -> DS.Object {
        guard let cached = try self.dataSource.get() else {
            let response = try self.dataSource.does(request: request)
            try self.dataSource.save(response)
            return response
        }
        return cached
    }
}
