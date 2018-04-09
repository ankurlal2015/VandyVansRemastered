//
//  RestApiManager.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 3/29/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct VanInfo{
    var name: String!
    var routeID: String!
    var patternID: String!
}

class RestApiManager: NSObject {
    let base = "https://www.vandyvans.com/"
    
    var black:VanInfo
    var gold:VanInfo
    var red:VanInfo
    
    override init(){
        //Default values before fetching new one. Yes I know this is hacky
        //TODO: Fix this
        self.black = VanInfo(name:"black", routeID: "1290", patternID:"1857")
        self.gold = VanInfo(name:"gold", routeID: "1289", patternID:"3021")
        self.red = VanInfo(name:"red", routeID: "1291", patternID:"1858")
        super.init()
        self.getRouteDataForInitialization()
        
    }
    
    func getRouteDataForInitialization() {
        let req = base + "Region/0/Routes/"
        print(req)
        Alamofire.request(req).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJson = JSON(responseData.result.value!)
                //0, 1, 2 hardcoded under the assumption that the json is ordered as such
                self.black = VanInfo(name:swiftyJson[0]["ShortName"].rawString(),
                                     routeID:swiftyJson[0]["ID"].rawString(),
                                     patternID:swiftyJson[0]["Patterns"][0]["ID"].rawString())
                self.gold = VanInfo(name:swiftyJson[1]["ShortName"].rawString(),
                                    routeID:swiftyJson[1]["ID"].rawString(),
                                    patternID:swiftyJson[1]["Patterns"][0]["ID"].rawString())
                self.red = VanInfo(name:swiftyJson[2]["ShortName"].rawString(),
                                   routeID:swiftyJson[2]["ID"].rawString(),
                                   patternID:swiftyJson[2]["Patterns"][0]["ID"].rawString())
            }
        }
    }
    
    func getWaypoints(vanColor : String, completion: @escaping (_ value:JSON)->()){
        var routeId = ""
        switch vanColor {
        case "BLACK"  :
            routeId = self.black.routeID
        case "RED"  :
            routeId = self.red.routeID
        case "GOLD"  :
            routeId = self.gold.routeID
        default :
            print("specify van, either RED, BLACK, or GOLD")
        }
        let req = base + "Route/" + routeId + "/Waypoints"
        print(req)
        Alamofire.request(req).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                //print(JSON(responseData.result.value!))
                completion(JSON(responseData.result.value!))
            }
        }
    }
    
    func getStops(vanColor : String, completion: @escaping (_ value:JSON)->()) {
        var routeId = ""
        var patternId = ""
        switch vanColor {
        case "BLACK"  :
            routeId = self.black.routeID
            patternId = self.black.patternID
        case "RED"  :
            routeId = self.red.routeID
            patternId = self.red.patternID
            print(self.red.routeID)
            print(self.red.patternID)
        case "GOLD"  :
            routeId = self.gold.routeID
            patternId = self.gold.patternID
        default :
            print("specify van, either RED, BLACK, or GOLD")
        }
        let req = base + "Route/" + patternId + "/Direction/" + routeId + "/Stops"
        print(req)
        Alamofire.request(req).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                //return JSON(responseData.result.value!)
                completion(JSON(responseData.result.value!))
            }
        }
    }
    
    func getVehicles(vanColor : String, completion: @escaping (_ value:JSON)->()){
        var routeId = ""
        switch vanColor {
        case "BLACK"  :
            routeId = self.black.routeID
        case "RED"  :
            routeId = self.red.routeID
        case "GOLD"  :
            routeId = self.gold.routeID
        default :
            print("specify van, either RED, BLACK, or GOLD")
        }
        let req = base + "Route/" + routeId + "/Vehicles"
        print(req)
        Alamofire.request(req).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                //print(JSON(responseData.result.value!))
                completion(JSON(responseData.result.value!))
            }
        }
    }
}
