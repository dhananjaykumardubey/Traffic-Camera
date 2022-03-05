//
//  TrafficCameraTests.swift
//  TrafficCameraTests
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import XCTest
@testable import TrafficCamera

class TrafficCameraTests: XCTestCase {

    private var cameraDetails: TrafficCameras?
    
    override func setUpWithError() throws {
        do {
            self.cameraDetails = try JSONDecoder().decode(TrafficCameras.self, from: Stubbed.successStubbedData)
            XCTAssertNotNil(self.cameraDetails)
            XCTAssertEqual(self.cameraDetails?.items.count, 1)
            XCTAssertEqual(self.cameraDetails?.items.first?.cameras.count, 1)
        } catch {
            XCTFail()
        }
    }
    
    override func tearDownWithError() throws {
        self.cameraDetails = nil
    }
    
    func testSuccessfulParsing() {
        guard
            let cameraItem = self.cameraDetails?.items.first
        else {
            XCTFail("cameraItem not there")
            return
        }
        
        XCTAssertEqual(cameraItem.cameras.count, 1)
        XCTAssertEqual(cameraItem.cameras.first?.cameraID, "4798")
        XCTAssertEqual(cameraItem.cameras.first?.location?.latitude, 1.25999999687243)
        XCTAssertEqual(cameraItem.cameras.first?.location?.longitude, 103.823611110166)
        XCTAssertEqual(cameraItem.cameras.first?.image, "https://image.png")
    }
}
