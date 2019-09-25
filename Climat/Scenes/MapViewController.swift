//
//  MapViewController.swift
//  Climat
//
//  Created by mohamed hashem on 9/2/19.
//  Copyright © 2019 mohamed hashem. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var Model: [CLLocationDegrees]? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "MAP"
        setupMap()
    }
    
    func setupMap() {
        var regoin = MKCoordinateRegion()
        regoin.center.latitude = CLLocationDegrees(Model?[0] ?? 0)
        regoin.center.longitude = CLLocationDegrees(Model?[1] ?? 0)
        
        let Coordinate = CLLocationCoordinate2D(latitude: regoin.center.latitude, longitude: regoin.center.longitude)
        
        regoin.span.latitudeDelta = 0.01
        regoin.span.longitudeDelta = 0.01
        
        mapView.setRegion(regoin, animated: true)
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = Coordinate
        
        mapView.addAnnotation(annotation)
        
//        let noLocation = CLLocationCoordinate2D(latitude: coordiante.latitude, longitude: coordiante.longitude)
//        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
//        mapView.setRegion(viewRegion, animated: false)
//
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = noLocation
//        annotation.title = "My Home"
//        annotation.subtitle = "her"
//        mapView.addAnnotation(annotation)
    }

}
