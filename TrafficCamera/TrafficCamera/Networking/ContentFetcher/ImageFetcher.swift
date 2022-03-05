
import Foundation
import UIKit.UIImage

/// Image fetcher class
class ImageFetcher: ContentFetcher {
    typealias ContentType = Image
            
    /// Error to be displayed when image downloading fails
    enum ImageFetcherError: Error {
        case unableToFetchImage
        
        var errorDescription: String? {
            switch self {
            case .unableToFetchImage:
                return "Unable to fetch the image.\n Please try again later"
            }
        }
    }
    
    /// NSCache object used to cache image for key
    static let cache = NSCache<NSString, UIImage>()
    
    private let session: NetworkSession
    
    
    /**
     Image fetcher initilizer with Network session
     
     - parameter session: Network session using which image needs to be downloaded, by default URLSession.shared is used
     
     */
    required init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchContent(_ content: ContentType, completionHandler: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let url = content.url else {
            completionHandler(.failure(ImageFetcherError.unableToFetchImage))
            return
        }
        
        if let cachedImage = type(of: self).cache.object(forKey: url.absoluteString as NSString) {
            // we have image
            completionHandler(.success(cachedImage))
            return
        }
        
        self.session.call(content) { [key = url.absoluteString] result in
            switch result {
            case .success(let imageData):
                guard
                    let image = UIImage(data: imageData) else {
                    completionHandler(.failure(ImageFetcherError.unableToFetchImage))
                    return
                    
                }
                type(of: self).cache.setObject(image, forKey: key as NSString)
                completionHandler(.success(image))
                
            case .failure(_):
                completionHandler(.failure(ImageFetcherError.unableToFetchImage))
                return
            }
        }
    }
}

