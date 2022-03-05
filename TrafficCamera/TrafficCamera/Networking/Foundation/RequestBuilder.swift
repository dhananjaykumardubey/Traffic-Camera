
import Foundation

enum BuilderError: Error {
    case apiKeyMissing
    case unableToResolveURL(URL)
    case unableBuildURL(message: String)
}

protocol RequestBuilder {
    
    func buildURLRequest(with url: URL) -> URLRequest
    
    func buildURLRequest(withURL url: URL, andParameters parameters: [String: String]) throws -> URLRequest
}

struct NetworkRequestBuilder: RequestBuilder {
    
    func buildURLRequest(with url: URL) -> URLRequest {
        return URLRequest(url: url,
                          cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData,
                          timeoutInterval: 30)
    }
    
    func buildURLRequest(withURL url: URL, andParameters parameters: [String: String]) throws -> URLRequest {
        
        guard var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false) else {
                                                throw BuilderError.unableToResolveURL(url)
        }
        
        var queryItems = [URLQueryItem]()
        for key in parameters.keys.sorted() {
            guard let param = parameters[key] else { continue }
            queryItems.append(URLQueryItem(name: key, value: param))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            let errorMessage = components.queryItems?.map { String(describing: $0) }.joined(separator: ", ") ?? ""
            
            throw BuilderError.unableBuildURL(message: "query item \(errorMessage)")
        }
        
        
        return URLRequest(url: url,
                          cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData,
                          timeoutInterval: 30)
    }
}
