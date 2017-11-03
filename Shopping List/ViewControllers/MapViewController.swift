//
//  MapViewController.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 11/1/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import UIKit
import MapKit

protocol mapViewDelegate  {
    
    func mapView( mV : Shops)
    
}
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var delegate : mapViewDelegate?
    var shopNameSelected : Shops!
    var nameOfTheShop :String!
    var locationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()
    var selectedAnnotation :MKPointAnnotation!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = nameOfTheShop
        
        nearMeSearch()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // give the aacuracy
        self.locationManager.distanceFilter = kCLDistanceFilterNone // filter any distance constraints
        self.locationManager.requestWhenInUseAuthorization() // asking permission to use the location
        self.mapView.showsUserLocation = true // to show the location
        self.locationManager.startUpdatingLocation()
        self.mapView.userTrackingMode = .follow
        self.mapView.delegate = self
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func nearMeSearch()  {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = nameOfTheShop
        let region = MKCoordinateRegionMakeWithDistance(self.locationManager.location!.coordinate, 800, 800)
        request.region  = region
        let search = MKLocalSearch(request: request)
        search.start { (response : MKLocalSearchResponse?, error :Error?) in
            for mapItem in (response?.mapItems)! {
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.placemark.name
                if
                    //subtitle for address
                    let city = mapItem.placemark.locality,
                    let state = mapItem.placemark.administrativeArea,
                    let postalcode = mapItem.placemark.postalCode {
                    annotation.subtitle = "  \(city) , \(state) \(postalcode) "
                    
                    self.mapView.addAnnotation(annotation)
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegionMake(mapItem.placemark.coordinate, span)
                    
                    //.distance(from: nearMLocation)
                    //                let distanceInMiles = distanceInMeters / 1609.344
                    //                let distanceInMilesRounded = String(format: "%.2f", distanceInMiles)
                    
                    //print (mapItem.placemark.addressDictionary)
                }
            }
        }
    }
    
    // Alert if map access denied
    func showAlert(message: String) {
        let alert = UIAlertController (title: "Shopping List", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestAlwaysAuthorization()
        }
            
        else if CLLocationManager.authorizationStatus() == .denied {
            
            showAlert (message: " Location service were previously denied. Please enable location services for this app in Settings")
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways{
            
            locationManager.startUpdatingLocation()
            
        }
        
    }
    //AnnotationView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotaion =  annotation as! MKPointAnnotation
        let annotationView = MKPinAnnotationView(annotation: annotaion, reuseIdentifier: "MyAnnotation")
        annotationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        annotationView.canShowCallout = true
        
        //adding  button for deatails & map
        let button = UIButton(type: .detailDisclosure) as UIButton
        button.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        
        annotationView.rightCalloutAccessoryView = button
        
        return annotationView
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.2, 0.2)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
            
        }
    }
    //user location
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation {
            return
        }
        
        self.selectedAnnotation = view.annotation as! MKPointAnnotation
    }
    
    @objc func infoButtonPressed() {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?daddr=\(Float(self.selectedAnnotation.coordinate.latitude)),\(Float(self.selectedAnnotation.coordinate.longitude))&directionsmode=driving")!,options: [:], completionHandler: nil)
            
        } else {
            let url: String = "http://maps.apple.com/?daddr=\(mapView.userLocation.coordinate.latitude),\(mapView.userLocation.coordinate.longitude)&daddr=\( self.selectedAnnotation.coordinate.latitude),\(self.selectedAnnotation.coordinate.longitude)"
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.identifier == "neARMeSegue"
        let navigationC = segue.destination as! UINavigationController
        let neARMeVC = navigationC.viewControllers.first as! MapViewController
        neARMeVC.nameOfTheShop = shopNameSelected.shopName
    }
}

