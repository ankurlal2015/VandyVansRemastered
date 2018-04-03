//
//  RouteInfo.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 3/29/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation

class RouteInfo{
    var name:String
    var routeID: String
    var patternID: String
    
    init(name: String, routeID: String, patternID:String) {
        self.name = name
        self.routeID = routeID
        self.patternID = patternID
    }
    
    func getName() -> String {
        return name
    }
    
    func getRouteID() -> String {
        return routeID
    }
    
    func getPatternID() -> String {
        return patternID
    }
}
