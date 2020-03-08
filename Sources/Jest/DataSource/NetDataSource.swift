import Foundation

open class NetDataSource<RequestType: Request, Output: Decodable> {
    
    let restClient: RestClient
    let request: RequestType
    
    public init(restClient: RestClient, request: RequestType) {
        self.restClient = restClient
        self.request = request
    }
    
    public func does() throws -> Output {
        return try self.restClient.request(
            url: request.url,
            method: request.type,
            headers: request.headers,
            query: request.query,
            body: request.body
        )
    }
}

extension NetDataSource: DataSource {}
