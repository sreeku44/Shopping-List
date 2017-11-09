//
//  ViewController.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 10/26/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var splashScreen:UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.splashScreen = UIImageView(frame: self.view.frame)
//        self.splashScreen.image = UIImage(named: "Shopinglist.png")
//        self.view.addSubview(self.splashScreen)
//        
//        var removeSplashScreen = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: "removeSP", userInfo: nil, repeats: false)
    }
    
    func removeSP()
    {
       
        self.splashScreen.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}




