//
//  TrafficCameras.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import Foundation

// MARK: - TrafficCameras
struct TrafficCameras: Codable {
    let items: [TrafficCameraItems]
    let apiInfo: APIInfo

    enum CodingKeys: String, CodingKey {
        case items
        case apiInfo = "api_info"
    }
}

// MARK: - APIInfo
struct APIInfo: Codable {
    let status: String
}

// MARK: - TrafficCameraItems
struct TrafficCameraItems: Codable {
    let cameras: [Camera]
}

// MARK: - Camera
struct Camera: Codable {
    let image: String?
    let location: Location?
    let cameraID: String?

    enum CodingKeys: String, CodingKey {
        case image, location
        case cameraID = "camera_id"
    }
}

// MARK: - Location
struct Location: Codable {
    let latitude: Double?
    let longitude: Double?
}
