import Foundation

open class NetDataSource<RequestType: Request, Output: Decodable> {
    
    let restClient: RestClient
    
    public init(restClient: RestClient) {
        self.restClient = restClient
    }
    
    public func does(request: RequestType) throws -> Output {
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
