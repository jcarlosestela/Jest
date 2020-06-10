import Foundation

open class CacheRequestDataSource<RequestType: Request, Output: Codable>: NetDataSource<RequestType, Output> {
    
    public let cacheManager: CacheManager
    
    public init(restClient: RestClient, cacheManager: CacheManager) {
        self.cacheManager = cacheManager
        super.init(restClient: restClient)
    }
    
    public func save(_ value: Object) throws {
        try self.cacheManager.save(value)
    }
    
    public func get() throws -> Object? {
        return try self.cacheManager.get()
    }
}

open class CacheDataSource<CacheManagerType: CacheManager, Object: Codable> {
    
    public let cacheManager: CacheManagerType
    
    public init(cacheManager: CacheManagerType) {
        self.cacheManager = cacheManager
    }
    
    public func save(_ value: Object) throws {
        try self.cacheManager.save(value)
    }
    
    public func get() throws -> Object? {
        return try self.cacheManager.get()
    }
}
