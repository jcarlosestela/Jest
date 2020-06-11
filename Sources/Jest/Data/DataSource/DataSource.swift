import Foundation

public protocol DataSource {
    associatedtype Object: Decodable
    associatedtype RequestType: Request
    func does(request: RequestType) throws -> Object
}

extension DataSource where Object == Empty {
    
    public func does(request: RequestType) throws {
        _ = try self.does(request: request)
    }
}
