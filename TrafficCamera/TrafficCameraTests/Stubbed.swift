//
//  Stubbed.swift
//  TrafficCameraTests
//
//  Created by Dhananjay Dubey on 21/2/21.
//

import Foundation

struct Stubbed {
    static let successStubbedData = Data("""
            {
              \"items\": [
                {
                  \"cameras\": [
                    {
                      \"image\": \"https://image.png\",
                      \"location\": {
                        \"latitude\": 1.25999999687243,
                        \"longitude\": 103.823611110166
                      },
                      \"camera_id\": \"4798\"
                    }
                  ]
                }
              ],
              \"api_info\": {
                \"status\": \"healthy\"
              }
            }
            """.utf8)
    
    static let parseFailStubbedData = Data("""
            {
              \"items\": [
                {
                  \"cameras\": [
                    {
                      \"image\": \"https://images.data.gov.sg/api/traffic-images/2021/02/2a224eee-6a2b-4222-89af-2d2216a1ff17.jpg\",
                      \"location\": {
                        \"latitude\": "1.25999999687243",
                        \"longitude\": 103.823611110166
                      },
                      \"camera_id\": \"4798\"
                    }
                  ]
                }
              ]
            }
            """.utf8)
}
