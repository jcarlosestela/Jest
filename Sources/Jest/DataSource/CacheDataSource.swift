import Foundation

public protocol CacheManager {
    func save<Object>(_ value: Object) throws
    func get<Object>() throws -> Object?
}

open class CacheDataSource<CacheManagerType: CacheManager, RequestType: Request, Output: Codable>: NetDataSource<RequestType, Output> {
    
    private let cacheManager: CacheManagerType
    
    public init(restClient: RestClient, request: RequestType, cacheManager: CacheManagerType) {
        self.cacheManager = cacheManager
        super.init(restClient: restClient, request: request)
    }
    
    public func save(_ value: Output) throws {
        try self.cacheManager.save(value)
    }
    
    public func get() throws -> Output? {
        return try self.cacheManager.get()
    }
}

extension CacheDataSource: DataSourceCacheCapable {}
