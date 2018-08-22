//
//  vehicleLocator.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/16/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import SwiftyJSON

class VehicleLocationManager{
    let restApiManager = RestApiManager()
    let vehicleLocationLoop = VehicleLocationLoop()
    let vanNotRunningBanner = VanNotRunningBanner()
    
    @objc func drawBlackVans(viewController:ViewController){
        self.restApiManager.getVehicles(vanColor: "BLACK") {
            (vehicles) in
            if(vehicles != []){
                self.vehicleLocationLoop.drawVans(vehicles: vehicles)
            }else{
                //viewController.view.addSubview(UIView())
                print("No Black Vans Running")
            }
        }
    }
    
    @objc func drawRedVans(viewController:ViewController){
        self.restApiManager.getVehicles(vanColor: "RED") {
            (vehicles) in
            //print(vehicles)
            self.vehicleLocationLoop.drawVans(vehicles: vehicles)
        }
    }
    
    @objc func drawGoldVans(viewController:ViewController){
        self.restApiManager.getVehicles(vanColor: "GOLD") {
            (vehicles) in
            //print(vehicles)
            self.vehicleLocationLoop.drawVans(vehicles: vehicles)
        }
    }
}
