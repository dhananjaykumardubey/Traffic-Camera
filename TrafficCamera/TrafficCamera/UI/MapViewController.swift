//
//  MapViewController.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var cancelButton: UIButton!
    
    private let viewModel = MapViewModel(
        with: TrafficImagesAPIClient(baseURL: NetworkConstant.baseURL),
        imageFetcher: ImageFetcher()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Traffic Cameras"
        self.imageView.isHidden = true
        self.cancelButton.isHidden = true
        
        self.mapView.delegate = self
        self.mapView.register(
            ClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        mapView.register(
            MapItemAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        self.bindViewModel()
    }
    
    private func bindViewModel() {

        self.viewModel.showError = { [weak self] message in
            guard let _self = self else { return }
            performOnMain {
                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(action)
                _self.present(alertController, animated: true)
            }
        }
        
        self.viewModel.mapItems = { [weak self] items in
            guard let _self = self else { return }
            performOnMain {
                _self.mapView.addAnnotations(items)
            }
        }
        
        self.viewModel.cameraImage = { [weak self] image in
            guard let _self = self else { return }
            performOnMain {
                _self.imageView.isHidden = false
                _self.cancelButton.isHidden = false
                _self.imageView.image = image
            }
        }
        
        self.viewModel.bindViewModel()
    }
    
    @IBAction private func cancelButtonTapped() {
        self.imageView.isHidden = true
        self.cancelButton.isHidden = true
        self.mapView.selectedAnnotations.forEach { annotation in
            self.mapView.deselectAnnotation(annotation, animated: false)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        switch view {
        case is ClusterAnnotationView:
            // if the user taps a cluster, zoom in
            let currentSpan = mapView.region.span
            let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 2.0, longitudeDelta: currentSpan.longitudeDelta / 2.0)
            let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
            let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
            mapView.setRegion(zoomed, animated: true)
            
        case is MapItemAnnotationView:
            // is user taps on pin, then show the image
            guard let annotation = view.annotation as? MapItem else { return }
            self.viewModel.selectedMapItem(mapItem: annotation)
        default: return
            
        }
    }
}

