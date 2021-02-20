//
//  MapItemAnnotationView.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import Foundation
import MapKit

final class MapItemAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            guard let mapItem = annotation as? MapItem else { return }
            clusteringIdentifier = "MapItem"
            image = mapItem.pinImage?.resizeImage(CGSize(width: 30.0, height: 30.0))
        }
    }
}
