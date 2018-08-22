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

    func drawVans(vehicles:JSON){
        self.clearVans()
        for index in 0..<vehicles.count {
            let lattitude = Double(vehicles[index]["lat"].rawString()!)!
            let longitude = Double(vehicles[index]["lon"].rawString()!)
            let position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude!)
            let heading = vehicles[index]["heading"].intValue
            
            let marker = GMSMarker(position: position)
           
            marker.rotation = Double(heading)
          
            //Save marker ref to clear on next refresh
            self.vans.append(marker)
            //marker.title = vehicles[index]["Name"].rawString()!
            marker.map = SingletonMap.map.getMapView()
            marker.icon = UIImage(named:"Van")
        }
    }
    
    func clearVans(){
        for index in 0..<self.vans.count{
            self.vans[index].map = nil
        }
        vans.removeAll()
    }
}
