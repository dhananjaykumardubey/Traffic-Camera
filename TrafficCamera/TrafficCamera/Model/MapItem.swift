//
//  MapItem.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import Foundation
import MapKit

/// MapItem consisting coordinates, imageUrl, and timeStamp
/// Can be expanded to have any other items - like custom annotation image, if needed
/// Can be expanded to have variants of images, if cluster supports come in different images required, based on some condition

class MapItem: NSObject, MKAnnotation {
    
    let image: Image?
    let coordinate: CLLocationCoordinate2D
    
    var pinImage: UIImage? {
        return UIImage(named: "pin")
    }
    
    init(coordinate: CLLocationCoordinate2D, image: Image?) {
        
        self.coordinate = coordinate
        self.image = image
    }
}
