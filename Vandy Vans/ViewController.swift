//
//  ViewController.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 3/18/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class ViewController: UIViewController, GMSMapViewDelegate {
    let restApiManager = RestApiManager()
    let vehicleLocationManager = VehicleLocationManager()
    let buttonManager = ButtonManager()
    let arrivalsCacher = ArrivalsCacher()
    let stopInfoPopupViewCreator = StopInfoPopupViewCreator()
    var buttonsInit = false
    var vanTimer:Timer?
    var arrivalTimer:Timer?
    var infoView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Map initially
        self.view = VandyMapView().getVandyMap()
        VandyMapView().getVandyMap().delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        //Black by default
        drawBlackRoute()
    }
    
    @objc func drawBlackRoute(){
        self.restApiManager.getStops(vanColor: "BLACK") {
                (stops) in
                //recenter
                SingletonMap.map.recenterMap()
                //add route
                let waypoints = self.restApiManager.getWaypoints(vanColor: "BLACK")
                VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().black)
                self.buttonManager.initButtons(viewController: self)
                //Clear previous vans
                self.clearTimer()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 1, target: self.vehicleLocationManager, selector: #selector(self.vehicleLocationManager.drawBlackVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self.arrivalsCacher, selector: #selector(self.arrivalsCacher.cacheBlackArrivals), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc func drawRedRoute(){
            self.restApiManager.getStops(vanColor: "RED") {
                (stops) in
                //recenter
                SingletonMap.map.recenterMap()
                //add route
                let waypoints = self.restApiManager.getWaypoints(vanColor: "RED")
                VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().red)
                self.buttonManager.initButtons(viewController: self)
                
                //Clear previous vans
                self.clearTimer()
                self.arrivalsCacher.clearCache()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 2, target: self.vehicleLocationManager, selector: #selector(self.vehicleLocationManager.drawRedVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self.arrivalsCacher, selector: #selector(self.arrivalsCacher.cacheRedArrivals), userInfo: nil, repeats: true)
                
            
        }
    }
    
    @objc func drawGoldRoute(){
            self.restApiManager.getStops(vanColor: "GOLD") {
                (stops) in
                //recenter
                SingletonMap.map.recenterMap()
                //add route
                let waypoints = self.restApiManager.getWaypoints(vanColor: "GOLD")
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
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let stopId = marker.userData as? String
        if(stopId != nil){
            let arrivals = self.arrivalsCacher.getCachedArrivals(stopId: stopId!)
            return stopInfoPopupViewCreator.generateStopInfoWindowView(marker: marker, arrivals: arrivals, stopId:stopId!)
        }else{
             return UIView()
        }
    }
    
    func clearTimer(){
        if(self.vanTimer != nil){
            self.vanTimer!.invalidate()
        }
    }
}

