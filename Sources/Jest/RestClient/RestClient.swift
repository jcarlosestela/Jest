//
//  RestClient.swift
//  
//
//  Created by José Carlos Estela Anguita on 08/03/2020.
//

import Foundation

public struct VoidParam: Encodable {
    public init() {}
}

public enum HTTPMethod {
    case get
    case post
}

extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

public protocol RestClient {

    func request<BodyParam: Encodable, QueryParam: Encodable, Output: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String],
        query: QueryParam,
        body: BodyParam
    ) throws -> Output
}

public enum RestClientError: Error {
    case unknown
    case decodedError
}

public final class JestRestClient: RestClient {
    
    public func request<BodyParam: Encodable, QueryParam: Encodable, Output: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String],
        query: QueryParam,
        body: BodyParam
    ) throws -> Output {
        var request = try self.urlRequest(method: method.description, url: url, headers: headers, body: body, query: query)
        request.httpBody = try JSONEncoder().encode(body)
        let semaphore = DispatchSemaphore(value: 0)
        var output: Output?
        var errorOutput: Error?
        print("=== Request ===")
        print(request)
        URLSession.shared.dataTask(with: request) { data, _, error in
            print("=== Response ===")
            guard let dataResponse = data else {
                errorOutput = error
                print(errorOutput?.localizedDescription ?? "Unknown error")
                return
            }
            print(String(describing: String(data: dataResponse, encoding: .utf8)))
            do {
                output = try JSONDecoder().decode(Output.self, from: dataResponse)
            } catch {
                errorOutput = error
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        guard let outputResponse = output else { throw errorOutput ?? RestClientError.unknown }
        return outputResponse
    }
}

private extension JestRestClient {
    
    func urlRequest<BodyParam: Encodable, QueryParam: Encodable>(method: String, url: String, headers: [String: String], body: BodyParam, query: QueryParam) throws -> URLRequest {
        guard let url = URL(string: url) else { throw NSError() }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = try query.queryItems()
        guard let urlWithParams = urlComponents?.url else { return URLRequest(url: url) }
        var request = URLRequest(url: urlWithParams)
        request.httpMethod = method
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

private extension Encodable {
    
    func queryItems() throws -> [URLQueryItem]? {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any], dictionary.keys.count > 0 else {
            return nil
        }
        return dictionary.compactMap {
            guard let stringParam = $0.value as? String else { return nil }
            return URLQueryItem(name: $0.key, value: stringParam)
        }
    }
}
