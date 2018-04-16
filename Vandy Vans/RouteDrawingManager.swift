//
//  RouteDrawingManager.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/16/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation

class RouteDrawingManager{
    
    let restApiManager = RestApiManager()
    let buttonManager = ButtonManager()
    
    
    @objc func drawBlackRoute(){
        self.restApiManager.getWaypoints(vanColor: "BLACK") {
            (waypoints) in
            self.restApiManager.getStops(vanColor: "BLACK") {
                (stops) in
                //add route
                VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().black)
                self.buttonManager.initButtons(viewController: self)
                //Clear previous vans
                self.clearTimer()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 2, target: self.vehicleLocationManager, selector: #selector(self.vehicleLocationManager.drawBlackVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self.arrivalsCacher, selector: #selector(self.arrivalsCacher.cacheBlackArrivals), userInfo: nil, repeats: true)
            }
        };
    }
    
    @objc func drawRedRoute(){
        self.restApiManager.getWaypoints(vanColor: "RED") {
            (waypoints) in
            self.restApiManager.getStops(vanColor: "RED") {
                (stops) in
                //add route
                VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().red)
                self.buttonManager.initButtons(viewController: self)
                
                //Clear previous vans
                self.clearTimer()
                self.arrivalsCacher.clearCache()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 2, target: self.vehicleLocationManager, selector: #selector(self.vehicleLocationManager.drawRedVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self.arrivalsCacher, selector: #selector(self.arrivalsCacher.cacheRedArrivals), userInfo: nil, repeats: true)
                
            }
            
        };
    }
    
    @objc func drawGoldRoute(){
        self.restApiManager.getWaypoints(vanColor: "GOLD") {
            (waypoints) in
            self.restApiManager.getStops(vanColor: "GOLD") {
                (stops) in
                //add route
                VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().gold)
                self.buttonManager.initButtons(viewController: self)
                
                //Clear previous vans
                self.clearTimer()
                self.arrivalsCacher.clearCache()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 2, target: self.vehicleLocationManager, selector: #selector(self.vehicleLocationManager.drawGoldVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self.arrivalsCacher, selector: #selector(self.arrivalsCacher.cacheGoldArrivals), userInfo: nil, repeats: true)
            }
        }
    }
    
}
