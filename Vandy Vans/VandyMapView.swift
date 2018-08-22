//
//  MapView.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 3/20/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON

//To move marker so the center of circle is on the line instead of the edge
let markerShiftConstant = 0.0003

//TODO: maybe get rid of patternID
struct StopInfo{
    var stopId: String!
    //var patternID: String!
}

class VandyMapView{
    
    var mapView = SingletonMap.map.getMapView()
    var vans = [GMSMarker]()
        
    func getVandyMap() -> GMSMapView{
        return mapView
    }
    
    func drawRouteWithStops(waypoints:[Double], stops:JSON, color: UIColor) {
        mapView.clear()
        let path = GMSMutablePath()
        //for index in 0..<waypoints.count {
        for i in stride(from: 0, to: waypoints.count, by: 2) {
            //TODO: change indexing
            let lattitude = waypoints[i]
            let longitude = waypoints[i+1]
            path.add(CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
        }
        
        //-1 because bad data duplicates lupton and scomb. If data changes, remove this
        //TODO, get rid of the -1
        for index in 0..<stops.count {
            let lattitude = Double(stops[index]["lat"].rawString()!)! - markerShiftConstant
            let longitude = Double(stops[index]["lon"].rawString()!)
            let position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude!)
            let marker = GMSMarker(position: position)
            marker.title = stops[index]["name"].rawString()!
            marker.userData = stops[index]["id"].rawString()!
            marker.map = self.mapView
            marker.icon = UIImage(named:"GenericStop")
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = color
        polyline.geodesic = true
        polyline.map = self.mapView
    }
}

