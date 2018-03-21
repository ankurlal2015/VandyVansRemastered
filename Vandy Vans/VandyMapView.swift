//
//  MapView.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 3/20/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import GoogleMaps

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
    
    func getMap() -> GMSMapView{
        let camera = GMSCameraPosition.camera(withLatitude: VandyLattitude, longitude: Vandylongitude, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        do {
            // Set the map style by passing a valid JSON string.
            mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        return mapView
    }
}

