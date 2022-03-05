//
//  ImageFetcherTests.swift
//  TrafficCameraTests
//
//  Created by Dhananjay Dubey on 21/2/21.
//

import XCTest

@testable import TrafficCamera

class ImageFetcherTests: XCTestCase {
    
    func testFetcherBehaviourWhenImageIsNotCached() {
        let networkSessionMock = NetworkSessionMock()
        let imageFetcher = ImageFetcher(session: networkSessionMock)
        let imageToFetch = Image("https://image.png")
        networkSessionMock.response = .success(UIImage(named: "placeholder")!.pngData()!)
        
        let expectUncached = self.expectation(description: #function)
        
        imageFetcher.fetchContent(imageToFetch) { result in
            expectUncached.fulfill()
            do {
                let successResponse = try result.get()
                XCTAssertNotNil(successResponse)
            } catch {
                XCTFail()
            }
        }
        
        XCTAssertEqual(networkSessionMock.url, imageToFetch.url)
        XCTAssertNotNil(ImageFetcher.cache.object(forKey: imageToFetch.url!.absoluteString as NSString))
        self.wait(for: [expectUncached], timeout: 1)
        
        ImageFetcher.flushCache()
        
        XCTAssertNil(ImageFetcher.cache.object(forKey: imageToFetch.url!.absoluteString as NSString))
    }
    
    func testFetcherBehaviourWhenImageIsCached() {
        
        let networkSessionMock = NetworkSessionMock()
        let imageFetcher = ImageFetcher(session: networkSessionMock)
        
        let imageURL = URL(string: "https://image.png")!
        let imageToFetch = Image("https://image.png")
        let image = UIImage(named: "placeholder")!
        
        ImageFetcher.cache.setObject(image, forKey: imageURL.absoluteString as NSString)
        let cached = self.expectation(description: "Should not call service")
        
        imageFetcher.fetchContent(imageToFetch) { result in
            cached.fulfill()
            do {
                let successResponse = try result.get()
                XCTAssertNotNil(successResponse)
            } catch {
                XCTFail()
            }
        }
        
        XCTAssertNil(networkSessionMock.url)
        
        self.wait(for: [cached], timeout: 1)
        ImageFetcher.flushCache()
    }
    
    func testFetcherBehaviourWhenImageIsNotFetchable() {
        let networkSessionMock = NetworkSessionMock()
        let imageFetcher = ImageFetcher(session: networkSessionMock)
        let imageToFetch = Image("https://image2.png")
        
        let expectUncached = self.expectation(description: #function)
        
        imageFetcher.fetchContent(imageToFetch) { result in
            expectUncached.fulfill()
            do {
                let failureResponse = try? result.get()
                XCTAssertNil(failureResponse)
            }
            let errorResponse = result.mapError { e in ImageFetcher.ImageFetcherError.unableToFetchImage }
            if case let Result.failure(error) = errorResponse {
                XCTAssertNotNil(error)
                XCTAssertEqual(ImageFetcher.ImageFetcherError.unableToFetchImage.errorDescription, error.errorDescription)
            }
        }
        
        XCTAssertEqual(networkSessionMock.url, imageToFetch.url)
        
        self.wait(for: [expectUncached], timeout: 1)
        ImageFetcher.flushCache()
    }
    
    func testFetcherBehaviourWhenImageURLIsNil() {
        
        let networkSessionMock = NetworkSessionMock()
        let imageFetcher = ImageFetcher(session: networkSessionMock)
        
        let imageToFetch = Image(nil)
        
        let cached = self.expectation(description: "Should not call service")
        
        imageFetcher.fetchContent(imageToFetch) { result in
            cached.fulfill()
            do {
                let failureResponse = try? result.get()
                XCTAssertNil(failureResponse)
            }
            let errorResponse = result.mapError { e in ImageFetcher.ImageFetcherError.unableToFetchImage }
            if case let Result.failure(error) = errorResponse {
                XCTAssertNotNil(error)
                XCTAssertEqual(ImageFetcher.ImageFetcherError.unableToFetchImage.errorDescription, error.errorDescription)
            }
        }
        
        XCTAssertNil(networkSessionMock.url)
        
        self.wait(for: [cached], timeout: 1)
        ImageFetcher.flushCache()
    }

}
