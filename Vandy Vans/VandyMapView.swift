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

class VandyMapView{
    
    var mapView:GMSMapView
    
    init(){
        mapView = SingletonMap.map.getMapView()
    }
    
    func getVandyMap() -> GMSMapView{
        return mapView
    }
    
    func drawRouteWithStops(waypoints:JSON, stops:JSON, color: UIColor) ->GMSMapView{
        mapView.clear()
        let path = GMSMutablePath()
        for index in 0..<waypoints[0].count {
            let lattitude = Double(waypoints[0][index]["Latitude"].rawString()!)
            let longitude = Double(waypoints[0][index]["Longitude"].rawString()!)
            path.add(CLLocationCoordinate2D(latitude: lattitude!, longitude: longitude!))
        }
        for index in 0..<stops[0].count {
            let lattitude = Double(stops[index]["Latitude"].rawString()!)! - 0.0002
            let longitude = Double(stops[index]["Longitude"].rawString()!)
            let position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude!)
            let marker = GMSMarker(position: position)
            marker.title = stops[index]["Name"].rawString()!
            marker.map = self.mapView
            marker.icon = UIImage(named:"GenericStop")
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = color
        polyline.geodesic = true
        polyline.map = self.mapView
        return self.mapView
    }
}

