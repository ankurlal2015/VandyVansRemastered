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
    //var prevLocations = [CLLocationCoordinate2D]()
    
    //NEED TO STORE PREVIOUS LOCATION SOMEHOW AND CALCULATE ANGLE.
    //MAYBE NEED TO USE CARDINAL DIRECTION AS A BACKUP
    
    
    func drawVans(vehicles:JSON, map: GMSMapView)->GMSMapView{
        self.clearVans()
        for index in 0..<vehicles.count {
            let lattitude = Double(vehicles[index]["Latitude"].rawString()!)! 
            let longitude = Double(vehicles[index]["Longitude"].rawString()!)
            let position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude!)
            let cardinalHeading = vehicles[index]["Heading"].rawString()!
            //let speed = Int(vehicles[index]["Speed"].rawString()!)!
            let marker = GMSMarker(position: position)
            //print(self.prevLocations.count)
            //let prevlocation = (self.prevLocations.count > index) ? prevLocations[index] : CLLocationCoordinate2D()
            marker.rotation = cardinalToDegrees(cardinalDirection: cardinalHeading)
            //marker.rotation =  calcRotationForVan(cardinalRotation: cardinalHeading, currentLocation: position, prevLocation: prevlocation)
//            //Save State to calculate proper angle
//            if(!self.isLocationEqual(A: position, B: prevlocation)){
//                self.prevLocations.insert(position, at: index)
//            }
            //Save marker ref to clear on next refresh
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
    
    func calcRotationForVan(cardinalRotation:String, currentLocation:CLLocationCoordinate2D, prevLocation:CLLocationCoordinate2D) -> Double{
        
        print(prevLocation)
        print(currentLocation)
//        if(self.isLocationEqual(A:prevLocation, B:CLLocationCoordinate2D()) || self.isLocationEqual(A:prevLocation, B: currentLocation)){
//            print("this")
            return self.cardinalToDegrees(cardinalDirection:cardinalRotation)
//        }else{
//            print("that")
//            print(cardinalRotation)
//            print(self.cardinalToDegrees(cardinalDirection:cardinalRotation))
//            return DegreeBearing(A: prevLocation, B: currentLocation)
//        }
//
        
        
        //If prevlocations empty or prevLovation = current location,
        //use cardinal direction
        
        //otherwise calculate degree bearing and rotate accordingly
        
        
        
    }
    
    func DegreeBearing(A:CLLocationCoordinate2D,B:CLLocationCoordinate2D)-> Double{
        
        var dlon = self.ToRad(degrees: B.longitude - A.longitude)
        
        let dPhi = log(tan(self.ToRad(degrees: B.latitude) / 2 + .pi / 4) / tan(self.ToRad(degrees: A.latitude) / 2 + .pi / 4))
        
        if  abs(dlon) > .pi{
            dlon = (dlon > 0) ? (dlon - 2 * .pi) : (2 * .pi + dlon)
        }
        //print(self.ToBearing(radians: atan2(dlon, dPhi)))
        //return self.ToBearing(radians: atan2(dlon, dPhi))
        print(self.ToDegrees(radians: atan2(dlon, dPhi)))
        return self.ToDegrees(radians: atan2(dlon, dPhi))
    }
    
    func ToRad(degrees:Double) -> Double{
        return degrees*(.pi/180)
    }
    
    func ToBearing(radians:Double)-> Double{
        return (ToDegrees(radians: radians) + 360) / 360
    }
    
    func ToDegrees(radians:Double)->Double{
        return radians * 180 / .pi + 360
    }
    
    func cardinalToDegrees(cardinalDirection:String)->Double{
        if(cardinalDirection == "N"){
            return 0.0
        }else if (cardinalDirection == "NE"){
            return 45.0
        }else if (cardinalDirection == "E"){
            return 90.0
        }else if (cardinalDirection == "SE"){
            return 135.0
        }else if (cardinalDirection == "S"){
            return 180.0
        }else if (cardinalDirection == "SW"){
            return 225.0
        }else if (cardinalDirection == "W"){
            return 270.0
        }else if (cardinalDirection == "NW"){
            return 315.0
        }else{
            print("UNKNOWN DIRECTION")
            return 0.0
        }
    }
    
    func isLocationEqual(A:CLLocationCoordinate2D , B: CLLocationCoordinate2D ) -> Bool {
        let epsilon = 0.000
        return ((A.latitude - B.latitude) <= epsilon && fabs(A.longitude - B.longitude) <= epsilon)
    }
}
