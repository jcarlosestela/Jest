import Foundation

public protocol DataSource {
    associatedtype Object: Decodable
    func does() throws -> Object
}

public protocol DataSourceCacheCapable: DataSource where Object: Encodable {
    func save(_ value: Object) throws
    func get() throws -> Object?
}
