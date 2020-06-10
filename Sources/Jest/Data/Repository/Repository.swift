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
