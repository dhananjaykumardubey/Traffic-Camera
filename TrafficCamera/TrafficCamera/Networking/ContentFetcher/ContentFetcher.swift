
import Foundation

/** Protocol to provide the content type which needs to be downloaded, in this project only Image is being used, further can be used to download anything.
 
 Inherited from URLRequestConvertible which provides URL from which content needs to be downloaded.
 */
protocol DownloadableContent: URLRequestConvertible {}

/**
 Class confirming to this protocol needs to implement all the
 
 
 */
protocol ContentFetcher {
    
    associatedtype Key: AnyObject
    associatedtype Value: AnyObject
    associatedtype ContentType: DownloadableContent
    
    /// NSCache object used to cache image for key
    static var cache: NSCache<Key, Value> { get }
    
    /**
     Content fetcher initilizer with Network session
     
     - parameter session: Network session using which content needs to be downloaded, by default URLSession.shared is used
     
     */
    init(session: NetworkSession)
    
    /**
     Downloads content if not present in cache, if present in cache, returns content from cache, else goes for downloading
     
     - parameters:
         - content: Content type associated value, which can be document, file, image etc
         - completionHandler: completion handler to inform service call back, passes downloaded content successfully or error in case of failure
     */
    func fetchContent(_ content: ContentType, completionHandler: @escaping ((Result<Value, Error>) -> Void))
    
    static func flushCache()
}

extension ContentFetcher {
    static func flushCache() {
        self.cache.removeAllObjects()
    }
}
