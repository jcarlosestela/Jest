import Foundation

public protocol DataSource {
    associatedtype Object: Decodable
    associatedtype RequestType: Request
    func does(request: RequestType) throws -> Object
}
