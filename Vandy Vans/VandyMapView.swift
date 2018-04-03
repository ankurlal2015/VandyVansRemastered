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

let mapStyle = "[" +
    "{" +
    "\"elementType\": \"labels\"," +
    "\"stylers\": [" +
    "{" +
    "\"visibility\": \"off\"" +
    "}" +
    "]" +
    "}," +
    "{" +
    "\"featureType\": \"administrative.land_parcel\"," +
    "\"stylers\": [" +
    "{" +
    "\"visibility\": \"off\"" +
    "}" +
    " ]" +
    "}," +
    "{" +
    "\"featureType\": \"administrative.neighborhood\"," +
    "\"stylers\": [" +
    "{" +
    "\"visibility\": \"off\"" +
    "}" +
    "]" +
    "}," +
    "{" +
    "\"featureType\": \"poi.business\"," +
    "\"stylers\": [" +
    "{" +
    "\"visibility\": \"off\"" +
    "}" +
    "]" +
    "}," +
    "{" +
    "\"featureType\": \"road\"," +
    "\"elementType\": \"labels.icon\"," +
    "\"stylers\": [" +
    "{" +
    "\"visibility\": \"off\"" +
    "}" +
    "]" +
    "}," +
    "{" +
    "\"featureType\": \"transit\"," +
    "\"stylers\": [" +
    "{" +
    "\"visibility\": \"off\"" +
    "}" +
    "]" +
    "}" +
"]"

let VandyLattitude = 36.1425898
let Vandylongitude = -86.8022756

class VandyMapView{
    
    func getVandyMap() -> GMSMapView{
        let camera = GMSCameraPosition.camera(withLatitude: VandyLattitude, longitude: Vandylongitude, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        do {
            // Set the map style by passing a valid JSON string.
            mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        //Enable blue dot thingy for users' current location
        mapView.isMyLocationEnabled = true
        return mapView
    }
    
    func drawRouteWithStops(waypoints:JSON, stops:JSON, color: UIColor) ->GMSMapView{
        let mapView = self.getVandyMap()
        let path = GMSMutablePath()
        for index in 0..<waypoints[0].count {
            let lattitude = Double(waypoints[0][index]["Latitude"].rawString()!)
            let longitude = Double(waypoints[0][index]["Longitude"].rawString()!)
            path.add(CLLocationCoordinate2D(latitude: lattitude!, longitude: longitude!))
        }
        for index in 0..<stops[0].count {
            let lattitude = Double(stops[index]["Latitude"].rawString()!)
            let longitude = Double(stops[index]["Longitude"].rawString()!)
            let position = CLLocationCoordinate2D(latitude: lattitude!, longitude: longitude!)
            let marker = GMSMarker(position: position)
            marker.title = stops[index]["Name"].rawString()!
            marker.map = mapView
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = color
        polyline.geodesic = true
        polyline.map = mapView
        return mapView
    }
}

