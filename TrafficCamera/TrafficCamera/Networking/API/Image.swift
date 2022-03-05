//
//  Image.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import Foundation

/// Image model having image url
struct Image: Hashable {
    let imageUrlString: String?
    
    init(_ imageUrlString: String?) {
        self.imageUrlString = imageUrlString
    }
    
    var url: URL? {
        if let urlString = self.imageUrlString {
            return URL(string: urlString)
        }
        return nil
    }
}

extension Image: DownloadableContent {
    
    /// Express the URL in form of url request, in case of images, no parameter is required
    func expressAsURLRequest() throws -> URLRequest {
        guard let url = self.url else {
            throw NSError(domain: "Invalid URL", code: 1, userInfo: nil)
        }
        return URLRequest(url: url)
    }
}
