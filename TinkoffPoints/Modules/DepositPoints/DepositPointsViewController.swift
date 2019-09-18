//
//  DepositPointsViewController.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import UIKit
import MapKit

final class DepositPointsViewController: UIViewController {

    private var viewModel: DepositPointsViewModel
    
    private lazy var locationManager = AppLocationManager()
    
    private var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    init(viewModel: DepositPointsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.register(PointView.self)
    }

    override func updateViewConstraints() {
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        super.updateViewConstraints()
    }
    
    // MARK: -
    
    func showWarningAlert() {
        // TODO: показать самый простой алерт
    }
}

extension DepositPointsViewController: AppLocationManagerDelegate {
    func changedLocationPermission(coordinate: CLLocationCoordinate2D?, isAuthorized: Bool) {
        guard let coordinate = coordinate else {
            return
        }
        
        let radius = Double(viewModel.defaultRadius)
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: radius,
                                                  longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
}

extension DepositPointsViewController: DepositPointsViewModelOutput {
    func didReceivePoints(points: [PointAnnotation]) {
        mapView.addAnnotations(points)
    }
    
    func didInactivePoints(points: [PointAnnotation]) {
        mapView.removeAnnotations(points)
    }
    
    func didReceiveError() {
        showWarningAlert()
    }
    
    func didReceiveUnavailableRadius() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

extension DepositPointsViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        viewModel.getPoints(latitude: mapView.region.center.latitude,
                            longitude: mapView.region.center.longitude,
                            radius: Int(mapView.currentRadius()))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PointAnnotation else {
            return nil
        }
        
        let view = mapView.dequeueReusableView(annotation: annotation) as PointView
        view.annotation = annotation
        view.setImage(nil)
        (view.detailCalloutAccessoryView as? PointDetailView)?.setAddress(annotation.address)
        (view.detailCalloutAccessoryView as? PointDetailView)?.setWorkHours(annotation.workHours)
        return view
    }
}

