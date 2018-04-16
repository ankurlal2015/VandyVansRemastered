//
//  ArrivalsCacher.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/14/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import SwiftyJSON

class ArrivalsCacher{
    
    var cache : [String: JSON] = [:]
    
    
   @objc func cacheArrivals(RouteColor : String, restApiManager: RestApiManager){
        //print(stopId)
        //        self.restApiManager.getArrivals(stopId: stopId){
        //            (arrivals) in
        //            print(arrivals)
        //        }
        restApiManager.getStops(vanColor: RouteColor) {
            (stops) in
            for index in 0..<stops.count {
                let stopId = stops[index]["ID"].rawString()!
                restApiManager.getArrivals(stopId: stopId){
                    (arrivals) in
                    self.cache[stopId] = arrivals
                }
            }
        }
        
    }
    
    func getCachedArrivals(stopId: String) -> JSON{
        return self.cache[stopId]!
    }
    
    
    func clearCache(){
        self.cache.removeAll()
    }
    
//    func setCache{
//
//    }
//
//    func getCache{
//
//    }
    
    
}
