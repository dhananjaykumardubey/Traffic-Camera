

import Foundation

protocol APIClient {
    
    init(baseURL: URL, networkSession: NetworkSession)

    func fetchTrafficCameras(_ completion: @escaping ((Result<TrafficCameras, Error>) -> Void))
}

/// Responsible for providing required content fetched from server.
struct TrafficImagesAPIClient: APIClient {
    
    private let baseURL: URL
    private let networkSession: NetworkSession
    /**
     Initializes `TrafficImagesAPIClient` with provided URL and session
     
     - parameters:
        - baseURL: Base URL
     */
    init(baseURL: URL, networkSession: NetworkSession = URLSession(configuration: .ephemeral)) {
        self.baseURL = baseURL
        self.networkSession = networkSession
    }
    
    func fetchTrafficCameras(_ completion: @escaping ((Result<TrafficCameras, Error>) -> Void)) {
        let request = TrafficImageRequest(url: self.baseURL)
        request.execute(onNetwork: self.networkSession, then: completion)
    }
}
