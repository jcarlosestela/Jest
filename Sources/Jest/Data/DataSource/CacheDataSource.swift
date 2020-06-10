import Foundation

open class CacheRequestDataSource<CacheManagerType: CacheManager, RequestType: Request, Output: Codable>: NetDataSource<RequestType, Output> {
    
    public let cacheManager: CacheManagerType
    
    public init(restClient: RestClient, cacheManager: CacheManagerType) {
        self.cacheManager = cacheManager
        super.init(restClient: restClient)
    }
}

extension CacheRequestDataSource: CacheDataSourceCapable {
    public typealias Object = Output
    public typealias Manager = CacheManagerType
}

open class CacheDataSource<CacheManagerType: CacheManager, Object: Codable>: CacheDataSourceCapable {
    
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
