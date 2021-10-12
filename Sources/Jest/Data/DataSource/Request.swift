import Foundation

public protocol Request {
    associatedtype BodyParam: BodyParamEncodable
    associatedtype QueryParam: Encodable
    var url: String { get }
    var headers: [String: String] { get }
    var query: QueryParam { get }
    var body: BodyParam { get }
    var type: HTTPMethod { get }
}

public struct GetRequest<QueryParam: Encodable>: Request {
    
    public let url: String
    public let headers: [String : String]
    public let query: QueryParam
    public let body: Empty
    public let type: HTTPMethod = .get
    
    public init(url: String, headers: [String : String] = [:], query: QueryParam) {
        self.url = url
        self.headers = headers
        self.query = query
        self.body = Empty()
    }
}

public struct PutRequest<BodyParam: BodyParamEncodable, QueryParam: Encodable>: Request {
    
    public let url: String
    public let headers: [String : String]
    public let query: QueryParam
    public let body: BodyParam
    public let type: HTTPMethod = .put
    
    public init(url: String, headers: [String : String] = [:], query: QueryParam, body: BodyParam) {
        self.url = url
        self.headers = headers
        self.query = query
        self.body = body
    }
}

public struct PostRequest<BodyParam: BodyParamEncodable, QueryParam: Encodable>: Request {
    
    public let url: String
    public let headers: [String : String]
    public let query: QueryParam
    public let body: BodyParam
    public let type: HTTPMethod = .post
    
    public init(url: String, headers: [String : String] = [:], query: QueryParam, body: BodyParam) {
        self.url = url
        self.headers = headers
        self.query = query
        self.body = body
    }
}

public struct DeleteRequest<BodyParam: BodyParamEncodable, QueryParam: Encodable>: Request {
    
    public let url: String
    public let headers: [String : String]
    public let query: QueryParam
    public let body: BodyParam
    public let type: HTTPMethod = .delete
    
    public init(url: String, headers: [String : String] = [:], query: QueryParam, body: BodyParam) {
        self.url = url
        self.headers = headers
        self.query = query
        self.body = body
    }
}

extension PostRequest where QueryParam == Empty {
    
    public init(url: String, headers: [String : String] = [:], body: BodyParam) {
        self.url = url
        self.headers = headers
        self.query = Empty()
        self.body = body
    }
}
