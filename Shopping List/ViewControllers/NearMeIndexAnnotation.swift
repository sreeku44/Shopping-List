//
//  NearMeIndexAnnotation.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 11/6/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import Foundation
import HDAugmentedReality
import MapKit

class NearMeAnnotation : ARAnnotation {
    
    var nearMeRequest : NearMeRequest!
    
    init(nearMeRequest : NearMeRequest) {
       
        super.init(identifier:nearMeRequest.name, title: nearMeRequest.name, location: CLLocation(latitude: nearMeRequest.coordinate.latitude, longitude: nearMeRequest.coordinate.longitude))!
    
        self.nearMeRequest = nearMeRequest
    }
    
}




