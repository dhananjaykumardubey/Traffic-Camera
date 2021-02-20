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
    
    private let viewModel = MapViewModel(with: TrafficImagesAPIClient(baseURL: NetworkConstant.baseURL))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Traffic Cameras"
        
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
        
        self.viewModel.startLoading = { [weak self] in
            guard let _self = self else { return }
            // Add Loader
        }
        
        self.viewModel.endLoading = { [weak self] in
            guard let _self = self else { return }
            // End Loader
        }
        
        self.viewModel.showError = { [weak self] message in
            guard let _self = self else { return }
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            _self.present(alertController, animated: true)
        }
        
        self.viewModel.mapItems = { [weak self] items in
            guard let _self = self else { return }
            _self.mapView.addAnnotations(items)
        }
        
        self.viewModel.fetchTrafficCameras()
        self.viewModel.bindViewModel()
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
            print("dfrgrer")
            
        default: return
            
        }
    }
}

