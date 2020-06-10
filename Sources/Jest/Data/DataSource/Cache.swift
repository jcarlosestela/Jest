//
//  Cache.swift
//  Jest
//
//  Created by José Carlos Estela Anguita on 10/06/2020.
//

import Foundation

public protocol CacheManager {
    func save<Object: Codable>(_ value: Object) throws
    func get<Object: Codable>() throws -> Object?
}

protocol CacheDataSourceCapable {
    func save<Object: Codable>(_ value: Object, on cacheManager: CacheManager) throws
    func get<Object: Codable>(on cacheManager: CacheManager) throws -> Object?
}

extension CacheDataSourceCapable {
    
    func save<Object: Codable>(_ value: Object, on cacheManager: CacheManager) throws {
        try cacheManager.save(value)
    }
    
    func get<Object: Codable>(on cacheManager: CacheManager) throws -> Object? {
        try cacheManager.get()
    }
}

extension UserDefaults: CacheManager {
    
    public func save<Object>(_ value: Object) throws where Object : Decodable, Object : Encodable {
        let data = try JSONEncoder().encode(value)
        set(data, forKey: String(describing: Object.self))
    }
    
    public func get<Object>() throws -> Object? where Object : Decodable, Object : Encodable {
        guard
            let data = object(forKey: String(describing: Object.self)) as? Data
        else {
            return nil
        }
        return try JSONDecoder().decode(Object.self, from: data)
    }
}

