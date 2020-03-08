import Foundation

public protocol DataSource {
    associatedtype Object: Decodable
    associatedtype RequestType: Request
    func does(request: RequestType) throws -> Object
}

public protocol DataSourceCacheCapable: DataSource where Object: Encodable {
    func save(_ value: Object) throws
    func get() throws -> Object?
}
