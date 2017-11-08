//
//  NearMeAnnotationView.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 11/6/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import Foundation
import UIKit
import HDAugmentedReality
import MapKit

class NearMeARAnnotationView: ARAnnotationView, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var annotationView :UIView = UIView()
    var annotationNameLabel :UILabel = UILabel()
    var annotationAddressLabel :UILabel = UILabel()
    var annotationDistanceLabel :UILabel = UILabel()
    
    var userLatitude :Double = Double()
    var userLongitude :Double = Double()
    
    //trying to use delegate to get userLocation from ARViewController
    func userLocation(latitude :Double, longitude :Double) {
        self.userLatitude = latitude
        self.userLongitude = longitude
    }
    
    init(annotation : ARAnnotation) {
        super .init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let userLatitude = self.locationManager.location?.coordinate.latitude
        let userLongitude = self.locationManager.location?.coordinate.longitude

       let nearMeAnnotation = annotation as! NearMeAnnotation

        let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)

        print(userLocation)

        let nearMLocation = CLLocation(latitude: nearMeAnnotation.nearMeRequest.coordinate.latitude, longitude: nearMeAnnotation.nearMeRequest.coordinate.longitude)

        print(nearMLocation)
        
        let name =  nearMeAnnotation.nearMeRequest.name
        let address =   "\(nearMeAnnotation.nearMeRequest.street!) \(nearMeAnnotation.nearMeRequest.state!) \(nearMeAnnotation.nearMeRequest.state!) \(nearMeAnnotation.nearMeRequest.zip!)"
        
        let distanceInMeters = userLocation.distance(from: nearMLocation)
        let distanceInMiles = distanceInMeters / 1609.344
        let distanceInMilesRounded = String(format: "%.2f", distanceInMiles)
        
        print(distanceInMiles)
        
        self.annotationView.frame = CGRect(x: 0, y: 0, width: 250, height: 100)
        self.annotationView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        
        self.annotationNameLabel.frame = CGRect(x: 0, y: 5, width: 150, height: 20)
        self.annotationNameLabel.text = name
        self.annotationNameLabel.textColor = UIColor.white
        self.annotationNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.annotationNameLabel.textAlignment = .center
        self.annotationNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.annotationNameLabel.numberOfLines = 2
        
        self.annotationAddressLabel.frame = CGRect(x: 0, y: self.annotationNameLabel.frame.size.height + 3, width: 150, height: 50)
        self.annotationAddressLabel.text = address
        self.annotationAddressLabel.textColor = UIColor.white
        self.annotationAddressLabel.font = UIFont.boldSystemFont(ofSize: 13)
        self.annotationAddressLabel.textAlignment = .center
        self.annotationAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.annotationAddressLabel.numberOfLines = 2
        
        self.annotationDistanceLabel.frame = CGRect(x: 0, y: self.annotationAddressLabel.frame.size.height + 2, width: 250, height: 50)
        self.annotationDistanceLabel.text = "\(distanceInMilesRounded) Miles"
        self.annotationDistanceLabel.textColor = UIColor.white
        self.annotationDistanceLabel.font = UIFont.boldSystemFont(ofSize: 13)
        self.annotationDistanceLabel.textAlignment = .center
        
        self.annotationView.addSubview(self.annotationNameLabel)
        self.annotationView.addSubview(self.annotationAddressLabel)
        self.annotationView.addSubview(self.annotationDistanceLabel)
        self.addSubview(self.annotationView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


