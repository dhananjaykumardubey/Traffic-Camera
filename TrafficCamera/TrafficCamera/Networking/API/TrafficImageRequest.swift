
import Foundation

struct TrafficImageRequest {
    
    let url: URL
    
    /**
     Initializes `TrafficImageRequest` with URL, and locationID
    
     - parameters:
        - url: Base URL for traffic images
     */
    init(url: URL) {
        self.url = url
    }
}

extension TrafficImageRequest: DataRequest, ParameteredRequest {
    typealias Response = TrafficCameras
    
    var endPoint: String {
        return "/v1/transport/traffic-images"
    }
    
    func expressAsURLRequest() throws -> URLRequest {
        try self.buildURL()
    }
    
    func buildURL() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.path = self.endPoint
        components.host = self.url.absoluteString
        guard
            components.host != nil,
            let localUrl = components.url else {
            let errorMessage = components.queryItems?.map { String(describing: $0) }.joined(separator: ", ") ?? ""
            throw BuilderError.unableBuildURL(message: "query item \(errorMessage)")
        }
        
        return URLRequest(url: localUrl,
                                    cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData,
                                    timeoutInterval: 30)
    }
}
