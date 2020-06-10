import Foundation

public protocol UseCase {
    associatedtype Input: Encodable
    associatedtype Output: Decodable
    func does(_ input: Input) throws -> Output
}

extension UseCase {
    
    public func schedule(on scheduler: UseCaseScheduler, input: Input, completion: @escaping (Result<Output, Error>) -> Void) {
        scheduler.schedule(self, input: input, completion: completion)
    }
}
