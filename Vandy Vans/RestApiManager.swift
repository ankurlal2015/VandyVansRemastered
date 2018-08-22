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
    var waypoints: [Double]!
    var stops: [Int]!
}

class RestApiManager: NSObject {
    let base = "https://vandyvan.doublemap.com"
    
    var black:VanInfo
    var gold:VanInfo
    var red:VanInfo
    
    override init(){
        //Default values before fetching new one. Yes I know this is hacky
        self.black = VanInfo(name:"black", routeID: "3", waypoints:defaultBlackWaypoints, stops:defaultBlackStops)
        self.gold = VanInfo(name:"gold", routeID: "1", waypoints:defaultGoldWaypoints, stops:defaultGoldStops)
        self.red = VanInfo(name:"red", routeID: "2", waypoints:defaultRedWaypoints, stops:defaultRedStops)
        super.init()
        self.getRouteDataForInitialization()
        
    }
    
    func getRouteDataForInitialization() {
        let req = base + "/map/v2/routes/"
        //print(req)
        Alamofire.request(req).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJson = JSON(responseData.result.value!)
                if(swiftyJson != []){
                self.black = VanInfo(name:swiftyJson[0]["name"].rawString()!,
                                     routeID:swiftyJson[0]["id"].rawString()!,
                                     waypoints:swiftyJson[0]["path"].arrayObject! as! [Double],
                                     stops:swiftyJson[0]["stops"].arrayObject! as! [Int])
                self.gold = VanInfo(name:swiftyJson[1]["name"].rawString()!,
                                    routeID:swiftyJson[1]["id"].rawString()!,
                                    waypoints:swiftyJson[1]["path"].arrayObject! as! [Double],
                                    stops:swiftyJson[1]["stops"].arrayObject! as! [Int])
                self.red = VanInfo(name:swiftyJson[2]["name"].rawString()!,
                                   routeID:swiftyJson[2]["id"].rawString()!,
                                   waypoints:swiftyJson[2]["path"].arrayObject! as! [Double],
                                   stops:swiftyJson[2]["stops"].arrayObject! as! [Int])
                }
            }
        }
    }
    
        func getWaypoints(vanColor:String ) -> [Double] {
            switch vanColor {
            case "BLACK"  :
                return self.black.waypoints
            case "RED"  :
                return self.red.waypoints
            case "GOLD"  :
                return self.gold.waypoints
            default :
                print("specify van, either RED, BLACK, or GOLD")
                return []
            }
        }
    
    //TODO: 1. make a call to stops. 2. Filter on stops for that route. 3. return json
        func getStops(vanColor : String, completion: @escaping (_ value:JSON)->()) {
            //print("here")
            var stops = [Int]()
            switch vanColor {
            case "BLACK"  :
                stops = self.black.stops
            case "RED"  :
                stops = self.red.stops
            case "GOLD"  :
                stops = self.gold.stops
            default :
                print("specify van, either RED, BLACK, or GOLD")
            }
            let req = base + "/map/v2/stops"
            //print(req)
            Alamofire.request(req).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    
                    let allStops = JSON(responseData.result.value!)
                    let arrayAllStops = allStops.arrayValue
                    let j = arrayAllStops.filter({ (json) -> Bool in
                        return stops.contains(json["id"].intValue); })
                    //print ("filterdData: \(j)")
                    completion(JSON(j))
                    
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
                //TODO: change request
                let req = base + "/map/v2/buses"
                //print(req)
                Alamofire.request(req).responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        //print(JSON(responseData.result.value!))
                        let allBuses = JSON(responseData.result.value!)
                        let bussesArray = allBuses.arrayValue
                            let j = bussesArray.filter({ (json) -> Bool in
                                return json["route"].stringValue == routeId; })
                            //print ("filterdData: \(j)")
                        completion(JSON(j))
                    }
                }
            }

    func getArrivals(stopId : String, completion: @escaping (_ value:JSON)->()){
        let req = base + "/map/v2/eta?stop=" + stopId
        //print(req)
        Alamofire.request(req).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                //print(JSON(responseData.result.value!))
                completion(JSON(responseData.result.value!))
            }
        }
    }
    
    let defaultBlackStops = [1,2,3,4,5,6,7,8,9,10,11]
    let defaultGoldStops = [1,2,3,4,15,16,8,9,10,14,13,12,11]
    let defaultRedStops = [1,12,13,14,10,9,8,7,2,11]
    
    let defaultBlackWaypoints = [36.145486,-86.805459,36.14551,-86.80548,36.14554,-86.80543,36.14579,-86.8049,36.14633,-86.80529,36.14735,-86.80606,36.1479,-86.80645,36.14825,-86.80574,36.14881,-86.80454,36.1495,-86.80316,36.14921,-86.80295,36.14922,-86.80294,36.14922,-86.80284,36.14942,-86.80274,36.14974,-86.80211,36.14993,-86.80227,36.15046,-86.8012,36.1495,-86.8005,36.14972,-86.80006,36.14917,-86.79965,36.14915,-86.79965,36.14894,-86.80006,36.14833,-86.79962,36.14829,-86.79957,36.14826,-86.79949,36.14822,-86.79922,36.14606,-86.79955,36.14601,-86.79875,36.14587,-86.7973,36.14388,-86.79768,36.14373,-86.79624,36.14366,-86.79569,36.14103,-86.79619,36.14107,-86.79639,36.13934,-86.79673,36.13931,-86.79675,36.13929,-86.79679,36.1393,-86.79714,36.13914,-86.79717,36.13914,-86.79719,36.13911,-86.79722,36.13904,-86.79725,36.13862,-86.79731,36.13857,-86.79733,36.13854,-86.79736,36.13852,-86.79741,36.13852,-86.7975,36.13856,-86.79792,36.13757,-86.7981,36.13731,-86.79816,36.13753,-86.8003,36.13763,-86.80114,36.13776,-86.80253,36.13783,-86.80313,36.13886,-86.80297,36.13906,-86.80507,36.13903,-86.80529,36.13903,-86.80539,36.13888,-86.80536,36.13894,-86.80603,36.13898,-86.80607,36.13908,-86.80608,36.13918,-86.80702,36.14025,-86.80687,36.14029,-86.80671,36.14032,-86.80665,36.14037,-86.80661,36.14067,-86.80654,36.14073,-86.80654,36.14082,-86.80658,36.1409,-86.80666,36.14097,-86.80677,36.14272,-86.80653,36.14266,-86.80586,36.14254,-86.80477,36.14325,-86.80469,36.14326,-86.8049,36.14342,-86.80644,36.14413,-86.80633,36.14423,-86.80633,36.14429,-86.80635,36.14449,-86.80649,36.14487,-86.80678,36.14548,-86.80552,36.14551,-86.80548]
    
    let defaultGoldWaypoints = [36.145486,-86.805459,36.14551,-86.80548,36.14554,-86.80543,36.14579,-86.8049,36.14633,-86.80529,36.14735,-86.80606,36.1479,-86.80645,36.14825,-86.80574,36.14881,-86.80454,36.1495,-86.80316,36.14921,-86.80295,36.14922,-86.80294,36.14922,-86.80284,36.14942,-86.80274,36.14974,-86.80211,36.14993,-86.80227,36.15046,-86.8012,36.1495,-86.8005,36.14972,-86.80006,36.14917,-86.79965,36.14915,-86.79965,36.14894,-86.80006,36.14833,-86.79962,36.14829,-86.79957,36.14826,-86.79949,36.14822,-86.79922,36.14463,-86.79976,36.14448,-86.79979,36.14448,-86.79993,36.14427,-86.79997,36.14427,-86.79996,36.14413,-86.79999,36.1441,-86.79998,36.14408,-86.79994,36.14408,-86.79984,36.14289,-86.80004,36.14149,-86.80024,36.14146,-86.79986,36.14148,-86.79981,36.14153,-86.7998,36.14272,-86.79969,36.14277,-86.79974,36.14279,-86.80005,36.14097,-86.80032,36.13941,-86.8005,36.13864,-86.80061,36.13906,-86.805,36.13903,-86.80539,36.13888,-86.80536,36.13893,-86.80596,36.13894,-86.80603,36.13896,-86.80606,36.13901,-86.80608,36.13908,-86.80608,36.13918,-86.80702,36.14025,-86.80687,36.14029,-86.80671,36.14032,-86.80665,36.14037,-86.80661,36.14067,-86.80654,36.14073,-86.80654,36.14082,-86.80658,36.1409,-86.80666,36.14097,-86.80677,36.14272,-86.80653,36.14266,-86.80586,36.14254,-86.80477,36.14325,-86.80469,36.14326,-86.8049,36.14342,-86.80644,36.14272,-86.80653,36.14284,-86.80775,36.14258,-86.80779,36.14259,-86.80799,36.14261,-86.80801,36.14286,-86.808,36.14307,-86.8101,36.14325,-86.81041,36.14385,-86.81087,36.14376,-86.81106,36.14315,-86.8106,36.14325,-86.81041,36.14307,-86.8101,36.14459,-86.8098,36.14477,-86.80978,36.14495,-86.80979,36.14498,-86.80929,36.14503,-86.8091,36.14512,-86.80889,36.14546,-86.80845,36.14547,-86.80841,36.14551,-86.80836,36.14591,-86.80755,36.14509,-86.80693,36.14487,-86.80678,36.14548,-86.80552,36.14551,-86.80548]
    
     let defaultRedWaypoints = [36.145486,-86.805459,36.14551,-86.80548,36.14548,-86.80552,36.14487,-86.80678,36.14509,-86.80693,36.14591,-86.80755,36.14551,-86.80836,36.14547,-86.80841,36.14546,-86.80845,36.14512,-86.80889,36.14503,-86.8091,36.14498,-86.80929,36.14495,-86.80979,36.14477,-86.80978,36.14459,-86.8098,36.14307,-86.8101,36.14325,-86.81041,36.14388,-86.81089,36.14385,-86.81087,36.14376,-86.81106,36.14315,-86.8106,36.14325,-86.81041,36.14307,-86.8101,36.14286,-86.80806,36.14284,-86.80775,36.14258,-86.80779,36.14259,-86.80799,36.14261,-86.80801,36.14286,-86.808,36.14266,-86.80586,36.14254,-86.80477,36.14325,-86.80469,36.14326,-86.8049,36.14342,-86.80644,36.14025,-86.80687,36.14029,-86.80671,36.14032,-86.80665,36.14037,-86.80661,36.14067,-86.80654,36.14073,-86.80654,36.14082,-86.80658,36.1409,-86.80666,36.14097,-86.80677,36.13918,-86.80702,36.13908,-86.80608,36.13898,-86.80607,36.13894,-86.80603,36.13888,-86.80536,36.13903,-86.80539,36.13903,-86.80529,36.13906,-86.80507,36.1387,-86.80501,36.13803,-86.80505,36.13779,-86.80273,36.13776,-86.80253,36.1377,-86.80183,36.13759,-86.80076,36.13753,-86.8003,36.13731,-86.79809,36.13731,-86.79816,36.13757,-86.7981,36.13856,-86.79792,36.13852,-86.7975,36.13852,-86.79741,36.13854,-86.79736,36.13857,-86.79733,36.13862,-86.79731,36.13904,-86.79725,36.13911,-86.79722,36.13914,-86.79719,36.13914,-86.79711,36.13907,-86.79657,36.14366,-86.79569,36.14382,-86.79706,36.14408,-86.79984,36.14702,-86.79941,36.14853,-86.79916,36.14865,-86.79909,36.14872,-86.79902,36.14961,-86.798,36.15139,-86.79934,36.15138,-86.79933,36.15117,-86.79975,36.15075,-86.80062,36.15027,-86.80157,36.14936,-86.80345,36.14881,-86.80454,36.14825,-86.80574,36.1479,-86.80645,36.14735,-86.80606,36.14633,-86.80529,36.14579,-86.8049,36.14551,-86.80548]
    
}
