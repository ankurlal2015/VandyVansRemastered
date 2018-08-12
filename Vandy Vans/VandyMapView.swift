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
    var patternID: String!
}

class VandyMapView{
    
    var mapView = SingletonMap.map.getMapView()
    var vans = [GMSMarker]()
        
    func getVandyMap() -> GMSMapView{
        return mapView
    }
    
    func drawRouteWithStops(waypoints:JSON, stops:JSON, color: UIColor) {
        mapView.clear()
        let path = GMSMutablePath()
        for index in 0..<waypoints[0].count {
            //TODO: change indexing
            let lattitude = Double(waypoints[0][index]["Latitude"].rawString()!)
            let longitude = Double(waypoints[0][index]["Longitude"].rawString()!)
            path.add(CLLocationCoordinate2D(latitude: lattitude!, longitude: longitude!))
        }
        
        //-1 because bad data duplicates lupton and scomb. If data changes, remove this
        //TODO, get rid of the -1
        for index in 0..<stops.count - 1 {
            let lattitude = Double(stops[index]["Latitude"].rawString()!)! - markerShiftConstant
            let longitude = Double(stops[index]["Longitude"].rawString()!)
            let position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude!)
            let marker = GMSMarker(position: position)
            marker.title = stops[index]["Name"].rawString()!
            marker.userData = stops[index]["ID"].rawString()!
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

