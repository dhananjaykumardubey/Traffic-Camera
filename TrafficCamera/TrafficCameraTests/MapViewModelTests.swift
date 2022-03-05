//
//  MapViewModelTests.swift
//  TrafficCameraTests
//
//  Created by Dhananjay Dubey on 21/2/21.
//

import XCTest
import MapKit

@testable import TrafficCamera

class MapViewModelTests: XCTestCase {
    
    private var mock: NetworkSessionMock!
    private let placeholderImage = UIImage(named: "placeholder")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mock = NetworkSessionMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.mock = nil
    }
    
    func testMapViewModelShouldNotReturnPlaceholderWhenHasRequiredImage() {
        let imageModel = Image("https://image.png")
        let mapItem = MapItem(coordinate: CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0), image: imageModel)
        let imageFectherMock = ImageFetcherMock(session: self.mock)
        let apiClient = TrafficImagesAPIClient(baseURL: URL(string: "abc.com")!, networkSession: self.mock)
        
        let viewModel = MapViewModel(with: apiClient, imageFetcher: imageFectherMock)
        
        let expect = self.expectation(description: "image fetching")
        viewModel.cameraImage = { image in
            expect.fulfill()
            XCTAssertNotNil(image)
            XCTAssertNotEqual(self.placeholderImage, image)
        }
        viewModel.selectedMapItem(mapItem: mapItem)

        self.wait(for: [expect], timeout: 1)
    }
    
    func testParsingOfTrafficCameraDetailsInMapItems() {
        
        let apiClient = TrafficImagesAPIClient(baseURL: URL(string: "abc.com")!, networkSession: self.mock)
        
        let viewModel = MapViewModel(with: apiClient, imageFetcher: nil)
        let expect = self.expectation(description: "traffic camera details fetch")
        self.mock.response = .success(Stubbed.successStubbedData)
        
        apiClient.fetchTrafficCameras { response in
            expect.fulfill()
            do {
                let successResponse = try response.get()
                XCTAssertNotNil(successResponse)
                XCTAssertEqual(successResponse.items.count, 1)
                XCTAssertEqual(successResponse.items.first?.cameras.count, 1)
                viewModel.parseFetchedCameraDetails(successResponse)
                
                viewModel.mapItems = { mapItem in
                    XCTAssertEqual(mapItem.count, 1)
                    XCTAssertEqual(mapItem.first?.image?.imageUrlString, "https://image.png")
                    XCTAssertEqual(mapItem.first?.image?.url, URL(string: "https://image.png")!)
                    XCTAssertEqual(mapItem.first?.coordinate.latitude, 1.25999999687243)
                    XCTAssertEqual(mapItem.first?.coordinate.longitude, 103.823611110166)
                }
                
            } catch {
                XCTFail()
            }
        }
        self.wait(for: [expect], timeout: 1)
    }
    
}

private class ImageFetcherMock: ImageFetcher {
    enum MockError: Error {
        case noUIImageSet(for: Image)
    }
    
    var urlImageMap = ["https://image.png": UIImage()]
    
    override func fetchContent(_ content: ContentType, completionHandler: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let image = self.urlImageMap[content.url?.absoluteString ?? ""] else {
            completionHandler(.failure(MockError.noUIImageSet(for: content)))
            return
        }
        completionHandler(.success(image))
    }
}
