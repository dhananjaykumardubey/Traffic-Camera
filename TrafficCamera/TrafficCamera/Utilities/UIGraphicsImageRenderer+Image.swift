//
//  UIGraphicsImageRenderer+Image.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import UIKit
import MapKit

extension UIGraphicsImageRenderer {
    
    static func image(for annotations: [MKAnnotation], in rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: rect.size)

        let countText = "\(annotations.count)"
        
        return renderer.image { _ in
            UIColor(red: 126 / 255.0, green: 211 / 255.0, blue: 33 / 255.0, alpha: 1.0).setFill()
            UIBezierPath(ovalIn: rect).fill()
            
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0),
                           clockwise: true)
            piePath.addLine(to: CGPoint(x: 20, y: 20))
            piePath.close()
            piePath.fill()
            
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
            
            countText.drawForCluster(in: rect)
        }
    }
}
