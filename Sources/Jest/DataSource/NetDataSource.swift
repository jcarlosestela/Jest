//
//  NetDataSource.swift
//  
//
//  Created by José Carlos Estela Anguita on 08/03/2020.
//

import Foundation

public protocol Request {
    associatedtype BodyParam: Encodable
    associatedtype QueryParam: Encodable
    var url: String { get }
    var headers: [String: String] { get }
    var query: QueryParam { get }
    var body: BodyParam { get }
    var type: HTTPMethod { get }
    init(url: String, headers: [String: String], query: QueryParam, body: BodyParam)
}

public struct GetRequest<QueryParam: Encodable>: Request {
    
    public let url: String
    public let headers: [String : String]
    public let query: QueryParam
    public let body: VoidParam
    public let type: HTTPMethod = .get
    
    public init(url: String, headers: [String : String] = [:], query: QueryParam, body: VoidParam = VoidParam()) {
        self.url = url
        self.headers = headers
        self.query = query
        self.body = body
    }
}

public struct PostRequest<BodyParam: Encodable, QueryParam: Encodable>: Request {
    
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

public struct NetDataSource<RequestType: Request, Output: Decodable> {
    
    private let restClient: RestClient
    private let request: RequestType
    
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
