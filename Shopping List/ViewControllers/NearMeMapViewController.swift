//
//  NearMeMapViewController.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 11/2/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import UIKit

//protocol neARMEwDelegate  {
//
//    func neARMe( nM : Shops)
//
//}

class NearMeMapViewController: UIViewController {
    
    //var delegate : neARMEwDelegate
     var nameOfTheShop :String!

    func neARMe(nM : Shops){}
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
