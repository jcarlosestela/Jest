import Foundation

public protocol UseCase {
    associatedtype Input
    associatedtype Output
    func does(_ input: Input) throws -> Output
}

public protocol UseCaseOutputCheckable {
    var isValid: Bool { get }
}

extension Empty: UseCaseOutputCheckable {
    
    public var isValid: Bool {
        return true
    }
}

extension UseCase {
    
    private var defaultScheduler: UseCaseScheduler {
        return DispatchQueue.global()
    }
    
    public func schedule(with input: Input, completion: ((Result<Output, Error>) -> Void)? = nil) {
        defaultScheduler.schedule(self, input: input, completion: completion)
    }
    
    public func schedule(on scheduler: UseCaseScheduler, input: Input, completion: ((Result<Output, Error>) -> Void)? = nil) {
        scheduler.schedule(self, input: input, completion: completion)
    }
}

extension UseCase where Input == Empty {
    
    public func schedule(completion: ((Result<Output, Error>) -> Void)? = nil) {
        defaultScheduler.schedule(self, input: Empty(), completion: completion)
    }

    public func schedule(on scheduler: UseCaseScheduler, completion: ((Result<Output, Error>) -> Void)? = nil) {
        scheduler.schedule(self, input: Empty(), completion: completion)
    }
}

extension UseCase where Output == Empty {

    public func schedule(with input: Input, completion: (() -> Void)? = nil) {
        self.schedule(on: defaultScheduler, input: input, completion: completion)
     }
    
    public func schedule(on scheduler: UseCaseScheduler, input: Input, completion: (() -> Void)? = nil) {
        scheduler.schedule(self, input: input) { result in
            switch result {
            case .success: completion?()
            case .failure: completion?()
            }
        }
    }
}

extension UseCase where Input == Empty, Output == Empty {
    
    public func schedule(completion: (() -> Void)? = nil) {
        self.schedule(on: defaultScheduler, input: Empty(), completion: completion)
     }

    public func schedule(on scheduler: UseCaseScheduler, completion: (() -> Void)? = nil) {
        scheduler.schedule(self, input: Empty()) { result in
            switch result {
            case .success: completion?()
            case .failure: completion?()
            }
        }
    }
}
