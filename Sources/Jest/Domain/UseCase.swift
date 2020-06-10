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
    
    public func schedule(on scheduler: UseCaseScheduler, input: Input) {
        scheduler.schedule(self, input: input)
    }
}

extension UseCase where Input == Empty {

    public func schedule(on scheduler: UseCaseScheduler, completion: @escaping (Result<Output, Error>) -> Void) {
        scheduler.schedule(self, input: Empty(), completion: completion)
    }
    
    public func schedule(on scheduler: UseCaseScheduler) {
        scheduler.schedule(self, input: Empty())
    }
}

extension UseCase where Output == Empty {

    public func schedule(on scheduler: UseCaseScheduler, input: Input, completion: @escaping (Error?) -> Void) {
        scheduler.schedule(self, input: input) { result in
            switch result {
            case .success: completion(nil)
            case .failure(let error): completion(error)
            }
        }
    }
}

extension UseCase where Input == Empty, Output == Empty {

    public func schedule(on scheduler: UseCaseScheduler, completion: @escaping (Error?) -> Void) {
        scheduler.schedule(self, input: Empty()) { result in
            switch result {
            case .success: completion(nil)
            case .failure(let error): completion(error)
            }
        }
    }
}
