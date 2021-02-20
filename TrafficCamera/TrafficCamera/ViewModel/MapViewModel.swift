//
//  MapViewModel.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import Foundation
import CoreLocation

class MapViewModel {
    
    // MARK: Callbacks or observers
    
    /// Callback for showing loader
    var startLoading: (() -> Void)?
    
    /// Callback for removing the loader
    var endLoading: (() -> Void)?
    
    /// Callback for showing the error message
    var showError: ((String) -> Void)?
    
    /// Callback returning selected source currency
    var selectedLocation: ((String) -> Void)?
    
    /// Callback returning all the map items
    var mapItems: (([MapItem]) -> Void)?
    
    //MARK: Private properties
    private let apiClient: APIClient?
//    private lazy var locationLists: Locations = []
//    private var location: Location?
    
    required init(with apiClient: TrafficImagesAPIClient) {
        self.apiClient = apiClient
    }
    
    //MARK: Exposed functions
    
    /// BindViewModel call to let viewmodel know that bindViewModel of viewcontroller is called and completed and properties can be observed
    func bindViewModel() {
       
    }
    
    func fetchTrafficCameras() {
        self.startLoading?()
        self.apiClient?.fetchTrafficCameras({ [weak self] response in
            guard let _self = self else {
                self?.endLoading?()
                return
            }
            DispatchQueue.main.async {
                _self.endLoading?()
                switch response {
                case let .success(cameraDetails):
                    _self.endLoading?()
                    _self.parseFetchedCameraDetails(cameraDetails)
                case let .failure(error):
                    _self.showError?(error.localizedDescription)
                }
            }
        })
    }

    func selectedMapItem(mapItem: MapItem) {
        
    }
    
    private func parseFetchedCameraDetails(_ cameraDetails: TrafficCameras) {
        guard !cameraDetails.items.isEmpty,
              let cameraItem = cameraDetails.items.first,
              !cameraItem.cameras.isEmpty
        else { return }
        
        let mapItems = cameraItem.cameras.map { item -> MapItem in
            let coordinate = CLLocationCoordinate2D(latitude: item.location?.latitude ?? 0.0,
                                                    longitude: item.location?.longitude ?? 0.0)
            return MapItem(coordinate: coordinate,
                           image: Image(item.image))
        }
        self.mapItems?(mapItems)
    }

}
