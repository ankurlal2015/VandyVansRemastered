//
//  vehicleLocator.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/16/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation

class VehicleLocationManager{
    let restApiManager = RestApiManager()
    let vehicleLocationLoop = VehicleLocationLoop()
    
    @objc func drawBlackVans(){
        self.restApiManager.getVehicles(vanColor: "BLACK") {
            (vehicles) in
            //print(vehicles)
            self.vehicleLocationLoop.drawVans(vehicles: vehicles)
        }
    }
    
    @objc func drawRedVans(){
        self.restApiManager.getVehicles(vanColor: "RED") {
            (vehicles) in
            //print(vehicles)
            self.vehicleLocationLoop.drawVans(vehicles: vehicles)
        }
    }
    
    @objc func drawGoldVans(){
        self.restApiManager.getVehicles(vanColor: "GOLD") {
            (vehicles) in
            //print(vehicles)
            self.vehicleLocationLoop.drawVans(vehicles: vehicles)
        }
    }
}
