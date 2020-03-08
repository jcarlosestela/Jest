import Foundation

public protocol UseCase {
    associatedtype Input: Encodable
    associatedtype Output: Decodable
    func does(_ input: Input) throws -> Output
}
