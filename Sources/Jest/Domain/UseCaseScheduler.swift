//
//  UseCaseScheduler.swift
//  Jest
//
//  Created by José Carlos Estela Anguita on 10/06/2020.
//

import Foundation

public protocol UseCaseScheduler {
    func schedule<UseCaseType: UseCase>(_ useCase: UseCaseType, input: UseCaseType.Input, completion: @escaping (Result<UseCaseType.Output, Error>) -> Void)
    func schedule<UseCaseType: UseCase>(_ useCase: UseCaseType, input: UseCaseType.Input)
}

extension DispatchQueue: UseCaseScheduler {
    
    
    public func schedule<UseCaseType: UseCase>(_ useCase: UseCaseType, input: UseCaseType.Input) {
        self.schedule(useCase, input: input, completion: { _ in })
    }
    
    public func schedule<UseCaseType: UseCase>(_ useCase: UseCaseType, input: UseCaseType.Input, completion: @escaping (Result<UseCaseType.Output, Error>) -> Void) {
        async {
            do {
                let result = try useCase.does(input)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
