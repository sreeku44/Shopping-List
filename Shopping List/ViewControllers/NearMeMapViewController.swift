//
//  NearMeMapViewController.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 11/2/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import UIKit
import MapKit
import HDAugmentedReality

//protocol nearMapViewDelegate  {
//
//  func neARMe(nM : Shops)
//
//}
protocol UserLocationDelegate {
    func userLocation(latitude :Double, longitude :Double)
}

class NearMeMapViewController: ARViewController, ARDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
   
    //var delegate1 : nearMapViewDelegate!
    var shopNameSelected : Shops!
    var nameOfTheShop :String!
    var locationManager : CLLocationManager!
    var nearMeARAnnotations = [ARAnnotation]()
    var nearMeRequests = [NearMeRequest]()
    var delegate : UserLocationDelegate!

   // func neARMe(nM : Shops){}
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //title for the ViewController
        self.title = nameOfTheShop
        
        //location update with CLLocationManager
        self.locationManager = CLLocationManager ()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLHeadingFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        arSetUP()
        
        getNearLocation ()
        
        //
       // self.setAnnotations(self.nearMeARAnnotations)
    }
    
    func arSetUP() {
        
        self.dataSource = self
        self.presenter.distanceOffsetMode = .manual
        self.presenter.distanceOffsetMultiplier = 0.1   // Pixels per meter
        self.presenter.distanceOffsetMinThreshold = 100// Doesn't raise annotations that are nearer than this
        // Filtering for performance
        self.presenter.maxDistance = 20000              // Don't show annotations if they are farther than this
        self.presenter.maxVisibleAnnotations = 50      // Max number of annotations on the screen
        // Stacking
        //self.ARPresenterTransform = ARPresenterStackTransform()
        
       // self.
       // Use presenterTransform = ARPresenterStackTransform()
        
        //self.presenter.verticalStackingEnabled = true
        
        // Location precision
       self.trackingManager.userDistanceFilter = 15
       self.trackingManager.reloadDistanceFilter = 50
    }
    func getNearLocation ()
    {
        //To findount what is near me
        let nearMeRequest = MKLocalSearchRequest()
        nearMeRequest.naturalLanguageQuery = nameOfTheShop
        let nearMeregion = MKCoordinateRegionMakeWithDistance(self.locationManager.location!.coordinate, 250, 250)
        nearMeRequest.region = nearMeregion
        let nearMeSearch = MKLocalSearch(request: nearMeRequest)
        nearMeSearch.start { (response : MKLocalSearchResponse?, error :Error?) in
            
            for requestItem in (response?.mapItems)!{
                
                let nearMeIndexRequest = NearMeRequest ()
                nearMeIndexRequest.name = requestItem.name
                nearMeIndexRequest.coordinate = requestItem.placemark.coordinate
                nearMeIndexRequest.address = requestItem.placemark.addressDictionary?["FormattedAddressLines"] as! [String]
                nearMeIndexRequest.street = requestItem.placemark.addressDictionary?["Street"] as! String!
                nearMeIndexRequest.city = requestItem.placemark.addressDictionary?["City"] as! String
                nearMeIndexRequest.state = requestItem.placemark.addressDictionary?["State"] as! String
                nearMeIndexRequest.zip = requestItem.placemark.addressDictionary?["ZIP"] as! String
                
                self.nearMeRequests.append(nearMeIndexRequest)
                
            }
            
            for nearMe in self.nearMeRequests {
                
                let annotation = NearMeAnnotation(nearMeRequest: nearMe)
                self.nearMeARAnnotations.append(annotation)
                self.setAnnotations(self.nearMeARAnnotations)
                
            }
            
        }
        
    }
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView =  NearMeARAnnotationView(annotation: viewForAnnotation)
        
        
        return annotationView
}
}

