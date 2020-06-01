import Foundation

public struct VoidParam: BodyParamEncodable {
    public init() {}
    
    public var encoding: BodyParamEncoding {
        return .none
    }
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

public enum BodyParamEncoding {
    case json
    case urlEncoded
    case none
}

public protocol BodyParamEncodable: Encodable {
    var encoding: BodyParamEncoding { get }
}

public protocol RestClient {
    func request<BodyParam: BodyParamEncodable, QueryParam: Encodable, Output: Decodable>(
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

public struct JestRestClient: RestClient {
    
    public init() {
        
    }
    
    public func request<BodyParam: BodyParamEncodable, QueryParam: Encodable, Output: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String],
        query: QueryParam,
        body: BodyParam
    ) throws -> Output {
        var request = try self.urlRequest(method: method.description, url: url, headers: headers, body: body, query: query)
        request.httpBody = try getBody(for: body)
        let semaphore = DispatchSemaphore(value: 0)
        var output: Output?
        var errorOutput: Error?
        print("=== Request ===")
        print(request)
        print("=== Body ===")
        if let body = request.httpBody {
            print(String(data: body, encoding: .utf8))
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            print("=== Response ===")
            guard let dataResponse = data, let response = String(data: dataResponse, encoding: .utf8) else {
                errorOutput = error
                print(errorOutput?.localizedDescription ?? "Unknown error")
                return
            }
            print(response)
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
    
    func getBody<BodyParam: BodyParamEncodable>(for bodyParam: BodyParam) throws -> Data? {
        switch bodyParam.encoding {
        case .json:
            return try JSONEncoder().encode(bodyParam)
        case .urlEncoded:
            return try bodyParam.encodingString().data(using: .utf8)
        case .none:
            return nil
        }
    }
    
    func urlRequest<BodyParam: BodyParamEncodable, QueryParam: Encodable>(method: String, url: String, headers: [String: String], body: BodyParam, query: QueryParam) throws -> URLRequest {
        guard let url = URL(string: url) else { throw NSError() }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = try query.queryItems()
        guard let urlWithParams = urlComponents?.url else { return URLRequest(url: url) }
        var request = URLRequest(url: urlWithParams)
        request.httpMethod = method
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        switch body.encoding {
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .urlEncoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none:
            break
        }
        return request
    }
}

private extension Encodable {
    
    func encodingString() throws -> String {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any], dictionary.keys.count > 0 else {
            return ""
        }
        return dictionary.enumerated().reduce(into: "?") { current, next in
            guard let value = next.element.value as? String else { return }
            switch next.offset {
            case 0:
                current += next.element.key + "=" + value
            default:
                current += "&" + next.element.key + "=" + value
            }
        }
    }
    
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
