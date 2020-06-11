//
//  UseCaseScheduler.swift
//  Jest
//
//  Created by José Carlos Estela Anguita on 10/06/2020.
//

import Foundation

public protocol UseCaseScheduler {
    func schedule<UseCaseType: UseCase>(_ useCase: UseCaseType, input: UseCaseType.Input, completion: ((Result<UseCaseType.Output, Error>) -> Void)?)
}

extension DispatchQueue: UseCaseScheduler {
    
    public func schedule<UseCaseType: UseCase>(_ useCase: UseCaseType, input: UseCaseType.Input, completion: ((Result<UseCaseType.Output, Error>) -> Void)?) {
        async {
            do {
                let result = try useCase.does(input)
                DispatchQueue.main.async {
                    completion?(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }
    }
}
