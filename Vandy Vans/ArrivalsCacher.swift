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
    let restApiManager = RestApiManager()
    
   
    @objc func cacheBlackArrivals(){
        restApiManager.getStops(vanColor: "BLACK") {
            (stops) in
            for index in 0..<stops.count {
                let stopId = stops[index]["ID"].rawString()!
                self.restApiManager.getArrivals(stopId: stopId){
                    (arrivals) in
                    self.cache[stopId] = arrivals
                }
            }
        }
    }
    
    
    @objc func cacheRedArrivals(){
        restApiManager.getStops(vanColor: "RED") {
            (stops) in
            for index in 0..<stops.count {
                let stopId = stops[index]["ID"].rawString()!
                self.restApiManager.getArrivals(stopId: stopId){
                    (arrivals) in
                    self.cache[stopId] = arrivals
                }
            }
        }
    }
    
    
    @objc func cacheGoldArrivals(){
        restApiManager.getStops(vanColor: "GOLD") {
            (stops) in
            for index in 0..<stops.count {
                let stopId = stops[index]["ID"].rawString()!
                self.restApiManager.getArrivals(stopId: stopId){
                    (arrivals) in
                    self.cache[stopId] = arrivals
                }
            }
        }
    }
    
    
    func getCachedArrivals(stopId: String) -> JSON{
        if(self.cache[stopId] != nil){
            return self.cache[stopId]!
        }else{
            return JSON.null
        }
    }
    
    func clearCache(){
        self.cache.removeAll()
    }
}
