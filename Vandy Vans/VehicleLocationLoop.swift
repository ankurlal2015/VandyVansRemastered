//
//  vehicleLocationLoop.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/5/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftyJSON

class VehicleLocationLoop{
    
    var vans = [GMSMarker]()
    
    //while true
    
    //sleep some update delay
    
    //Pseudocode
    //Some double closure like this for vehicle location
    
    //self.restApiManager.getWaypoints(vanColor: "GOLD") {
    //(waypoints) in
    //self.restApiManager.getStops(vanColor: "GOLD") {
    //    (stops) in
    
    //For each location in the loop. compute a vector between the pts
    
    //return a point and a vector
    
    func drawVans(vehicles:JSON, map: GMSMapView)->GMSMapView{
        self.clearVans()
        for index in 0..<vehicles.count {
            let lattitude = Double(vehicles[index]["Latitude"].rawString()!)! - markerShiftConstant
            let longitude = Double(vehicles[index]["Longitude"].rawString()!)
            let position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude!)
            let marker = GMSMarker(position: position)
            self.vans.append(marker)
            //marker.title = vehicles[index]["Name"].rawString()!
            marker.map = map
            marker.icon = UIImage(named:"Van")
        }
        return map
    }
    
    func clearVans(){
        for index in 0..<self.vans.count{
            self.vans[index].map = nil
        }
        vans.removeAll()
    }
}
