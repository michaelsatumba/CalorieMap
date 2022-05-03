//
//  CalorieMapViewController.swift
//  CalorieMap
//
//  Created by Michael Tayamen Satumba Jr. on 5/2/22.
//

import UIKit
import MapKit

class CalorieMapViewController: UIViewController {

    let mapView = MKMapView()

    override func viewDidLoad() {
    super.viewDidLoad()
        title = "Maps"
        view.addSubview(mapView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.77, longitude: -122.43)
        annotation.title = "SF"
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(region, animated: true)
    }
}

