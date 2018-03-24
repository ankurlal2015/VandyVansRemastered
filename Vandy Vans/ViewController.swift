//
//  ViewController.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 3/18/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        //Load Map Background
        self.view =  VandyMapView().getMap()
        
    }


}

