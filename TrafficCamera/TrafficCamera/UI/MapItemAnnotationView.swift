//
//  MapItemAnnotationView.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import Foundation
import MapKit

final class MapItemAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            clusteringIdentifier = "MapItem"
            self.markerTintColor = .blue
        }
    }
}
