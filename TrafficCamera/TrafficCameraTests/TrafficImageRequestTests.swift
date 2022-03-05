//
//  TrafficImageRequestTests.swift
//  TrafficCameraTests
//
//  Created by Dhananjay Dubey on 21/2/21.
//

import XCTest
@testable import TrafficCamera

class TrafficImageRequestTests: XCTestCase {
    
    var mock: NetworkSessionMock!
    
    override func setUpWithError() throws {
        self.mock = NetworkSessionMock()
    }

    override func tearDownWithError() throws {
        self.mock = nil
    }
    
    func testExpectSuccessFullResponseWhenValidJSONIsAvailable() {

        self.mock.response = .success(Stubbed.successStubbedData)
        
        let client = TrafficImagesAPIClient(baseURL: URL(string: "abc.com")!, networkSession: self.mock)
        
        let expectation = self.expectation(description: "Expect success")

        client.fetchTrafficCameras { response in
            expectation.fulfill()
            do {
                let successResponse = try response.get()
                XCTAssertNotNil(successResponse)
                XCTAssertEqual(successResponse.items.count, 1)
                XCTAssertEqual(successResponse.items.first?.cameras.count, 1)
            } catch {
                XCTFail()
            }
        }
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testFailureResponse() {
        
        self.mock.response = .failure(NetworkErrors.ResponseError.noDataAvailable)
        
        let client = TrafficImagesAPIClient(baseURL: URL(string: "abc.com")!, networkSession: self.mock)
        let expectation = self.expectation(description: "Expect success")
        client.fetchTrafficCameras { response in
            expectation.fulfill()
            do {
                let failureResponse = try? response.get()
                XCTAssertNil(failureResponse)
            }
            
            let errorResponse = response.mapError { e in NetworkErrors.ResponseError.noDataAvailable }
            if case let Result.failure(error) = errorResponse {
                XCTAssertEqual(NetworkErrors.ResponseError.noDataAvailable.errorDescription, error.errorDescription)
            }

        }
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testResponseParseFailError() {
            
        self.mock.response = .success(Stubbed.parseFailStubbedData)
        
        let client = TrafficImagesAPIClient(baseURL: URL(string: "abc.com")!, networkSession: self.mock)
        
        let expectation = self.expectation(description: "Expect success")

        client.fetchTrafficCameras { response in
            expectation.fulfill()
            do {
                let failureResponse = try? response.get()
                XCTAssertNil(failureResponse)
                let errorResponse = response.mapError { e in NetworkErrors.ParsingError.unableToParse }
                if case let Result.failure(error) = errorResponse {
                    XCTAssertEqual(NetworkErrors.ParsingError.unableToParse.errorDescription, error.errorDescription)
                }
            }
        }
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testValidRequest() {
        let client = TrafficImagesAPIClient(baseURL: URL(string: "abc.com")!, networkSession: self.mock)
        
        let expectation = self.expectation(description: "Expect success")
        
        client.fetchTrafficCameras { _ in
            expectation.fulfill()
        }
        
        guard let receivedRequest = self.mock.request as? TrafficImageRequest else {
            XCTFail("Invalid request received expected was TrafficImageRequest")
            return
        }
        
        XCTAssertEqual(receivedRequest.url.absoluteString, "abc.com")
        XCTAssertEqual(try receivedRequest.expressAsURLRequest().url?.absoluteString,
                       URLRequest(url: URL(string: "https://abc.com/v1/transport/traffic-images")!).url?.absoluteString)
        
        self.wait(for: [expectation], timeout: 1)
    }
}
