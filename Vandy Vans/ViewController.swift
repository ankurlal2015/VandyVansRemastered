//
//  ViewController.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 3/18/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

struct ArrivalInfo{
    var patternID: String!
    var secsToArrival: Double!
}

class ViewController: UIViewController, GMSMapViewDelegate {
    let restApiManager = RestApiManager()
    var buttonsInit = false
    let vehicleLocationLoop = VehicleLocationLoop()
    var vanTimer:Timer?
    var arrivalTimer:Timer?
    var infoView:UIView?
    var arrivalsCacher = ArrivalsCacher()
    var cache : [String: JSON] = [:]
    //let vandyMapView = VandyMapView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Map initially
        self.view = VandyMapView().getVandyMap()
        VandyMapView().getVandyMap().delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        //Black by default
        drawBlackRoute()
    }
    
    @objc func drawBlackRoute(){
        self.restApiManager.getWaypoints(vanColor: "BLACK") {
            (waypoints) in
            self.restApiManager.getStops(vanColor: "BLACK") {
                (stops) in
                //add route
                self.view =  VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().black)
                self.initButtons()
                //Clear previous vans
                self.clearTimer()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.drawBlackVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.cacheBlackArrivals), userInfo: nil, repeats: true)
            }
        };
    }
    
    @objc func drawRedRoute(){
        self.restApiManager.getWaypoints(vanColor: "RED") {
            (waypoints) in
            self.restApiManager.getStops(vanColor: "RED") {
                (stops) in
                //add route
                self.view =  VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().red)
                self.initButtons()
                
                //Clear previous vans
                self.clearTimer()
                self.clearCache()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.drawRedVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.cacheRedArrivals), userInfo: nil, repeats: true)
                
            }
            
        };
    }
    
    @objc func drawGoldRoute(){
        self.restApiManager.getWaypoints(vanColor: "GOLD") {
            (waypoints) in
            self.restApiManager.getStops(vanColor: "GOLD") {
                (stops) in
                //add route
                self.view =  VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().gold)
                self.initButtons()
                
                //Clear previous vans
                self.clearTimer()
                self.clearCache()
                //Start fetching van data
                self.vanTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.drawGoldVans), userInfo: nil, repeats: true)
                self.arrivalTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.cacheGoldArrivals), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func drawBlackVans(){
        self.restApiManager.getVehicles(vanColor: "BLACK") {
            (vehicles) in
            //print(vehicles)
            //self.view = VandyMapView().drawVans(vehicles:vehicles)
            self.view = self.vehicleLocationLoop.drawVans(vehicles: vehicles, map: SingletonMap.map.getMapView())
        }
    }
    
    @objc func drawRedVans(){
        self.restApiManager.getVehicles(vanColor: "RED") {
            (vehicles) in
            //print(vehicles)
            //self.view = VandyMapView().drawVans(vehicles:vehicles)
            self.view = self.vehicleLocationLoop.drawVans(vehicles: vehicles, map: SingletonMap.map.getMapView())
        }
    }
    
    @objc func drawGoldVans(){
        self.restApiManager.getVehicles(vanColor: "GOLD") {
            (vehicles) in
            //print(vehicles)
            //self.view = VandyMapView().drawVans(vehicles:vehicles)
            self.view = self.vehicleLocationLoop.drawVans(vehicles: vehicles, map: SingletonMap.map.getMapView())
        }
    }
    
    //Size buttons based on Screen size and lay them out.
    //Only do it once, don't redraw every time we change the map
    //TODO: Refactor this so it isn't so hacky
    //But it works, so won't change it for a while
    func initButtons(){
        if(!buttonsInit){
            buttonsInit = true
            
            let buttonSize = CGFloat(85)
            
            let centerX = self.view.center.x
            //shift by button with
            let buttonShift = buttonSize/2
            //Distance between buttons
            let buttonSpacing = CGFloat(110.0)
            //buttons render 20% from bottom
            let vertShift = self.view.frame.size.height - self.view.frame.size.height/5
            
            
            let blackBtn: UIButton = UIButton(type: UIButtonType.custom)
            blackBtn.frame = CGRect(x: (centerX - buttonShift), y: vertShift, width: buttonSize, height: buttonSize)
            blackBtn.setImage(UIImage(named: "BlackRouteButton"),for: .normal)
            blackBtn.addTarget(self, action: #selector(self.drawBlackRoute), for: .touchUpInside)
            self.view.addSubview(blackBtn)
            
            let redBtn: UIButton = UIButton(type: UIButtonType.custom)
            redBtn.frame = CGRect(x: (centerX - buttonShift - buttonSpacing), y: vertShift, width: buttonSize, height: buttonSize)
            redBtn.setImage(UIImage(named: "RedRouteButton"),for: .normal)
            redBtn.addTarget(self, action: #selector(self.drawRedRoute), for: .touchUpInside)
            self.view.addSubview(redBtn)
            
            let goldBtn: UIButton = UIButton(type: UIButtonType.custom)
            goldBtn.frame = CGRect(x: (centerX - buttonShift + buttonSpacing), y: vertShift, width: buttonSize, height: buttonSize)
            goldBtn.setImage(UIImage(named: "GoldRouteButton"),for: .normal)
            goldBtn.addTarget(self, action: #selector(self.drawGoldRoute), for: .touchUpInside)
            self.view.addSubview(goldBtn)
        
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let stopId = marker.userData as! String
        //print(stopId)
//        self.restApiManager.getArrivals(stopId: stopId){
//            (arrivals) in
//            print(arrivals)
//        }
       
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 100))
        
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        //view.layer.borderWidth = 2
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowOffset = CGSize.zero
//        view.layer.shadowRadius = 10
        
        let stopNameLabel = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 25))
        stopNameLabel.text = marker.title
        stopNameLabel.font =  UIFont.systemFont(ofSize: 20, weight: .regular)
        view.addSubview(stopNameLabel)
        
//        let arrivalsLabel = UILabel(frame: CGRect.init(x: 8, y: 28, width: view.frame.size.width - 16, height: 15))
//        arrivalsLabel.text = "Arrivals:"
//        arrivalsLabel.font =  UIFont.systemFont(ofSize: 15, weight: .regular)
//        view.addSubview(arrivalsLabel)
        
        let arrivals = self.cache[stopId]
        
        var arriveTimes = [ArrivalInfo]()
        if (arrivals != nil){
            for i in 0..<arrivals!.count {
                let arr = arrivals![i]["Arrivals"]
                for j in 0..<arr.count {
                let patternID = arr[j]["RouteID"].rawString()!
                let secsToArrival = arr[j]["SecondsToArrival"].rawString()!
                print(patternID)
                let arrivalInfo = ArrivalInfo(patternID: patternID, secsToArrival: Double(secsToArrival))
                    arriveTimes.append(arrivalInfo)
                }
            }
        }
        
        arriveTimes.sort(by: {$0.secsToArrival < $1.secsToArrival})
        let numArrivalsToDisplay = 4
        for index in 0..<numArrivalsToDisplay {
            
            if (arriveTimes.count >= (index + 1)){
                let arrivalTimeLabel = ArrivalInfoToArrivalLabel(arrivalInfo: arriveTimes[index], parentView: view, parentLabel: stopNameLabel, labelNumber: index)
//                let arriveRouteToDisplay = arriveTimes[index].routeID
//                let arriveTimeToDisplay = arriveTimes[index].secsToArrival
//
//
//                let arrivalTimeLabel = UILabel(frame: CGRect.init(x: arrivalsLabel.frame.origin.x, y: arrivalsLabel.frame.origin.y +
//                    arrivalsLabel.frame.size.height + 15 * CGFloat(index), width: view.frame.size.width - 16, height: 15))
//                    arrivalTimeLabel.text = "stop"
//                    arrivalTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
                    view.addSubview(arrivalTimeLabel)
            }
        }
        
        return view
    }
    
    func ArrivalInfoToArrivalLabel(arrivalInfo : ArrivalInfo, parentView:UIView, parentLabel:UILabel, labelNumber:Int) -> UILabel{
        let patternID = arrivalInfo.patternID
        let arriveMins = SecsToMins(secsToArrival: arrivalInfo.secsToArrival)
        let arrivalTimeLabel = UILabel(frame: CGRect.init(x: parentLabel.frame.origin.x, y: parentLabel.frame.origin.y +
            parentLabel.frame.size.height + 15 * CGFloat(labelNumber), width: parentView.frame.size.width - 16, height: 15))
        arrivalTimeLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        //String(format: "Value: %3.2f\tResult: %3.2f", arguments: [2.7, 99.8])
        if(patternID == self.restApiManager.black.patternID){
            //String(format: "Black: %3.2f\tResult: %3.2f", arguments: [2.7, 99.8])
            let labelString = "Black:           \(arriveMins) Mins"
            let coloredString = NSMutableAttributedString(string: labelString)
            coloredString.addAttribute(NSAttributedStringKey.foregroundColor, value: ColorWheel().black, range: NSRange(location:0,length:6))
            arrivalTimeLabel.attributedText = coloredString
        }else if(patternID == self.restApiManager.red.patternID){
            let labelString = "Red  :            \(arriveMins) Mins"
            let coloredString = NSMutableAttributedString(string: labelString)
            coloredString.addAttribute(NSAttributedStringKey.foregroundColor, value: ColorWheel().red, range: NSRange(location:0,length:6))
            arrivalTimeLabel.attributedText = coloredString
        }else if(patternID == self.restApiManager.gold.patternID){
            let labelString = "Gold :            \(arriveMins) Mins"
            let coloredString = NSMutableAttributedString(string: labelString)
            coloredString.addAttribute(NSAttributedStringKey.foregroundColor, value: ColorWheel().gold, range: NSRange(location:0,length:6))
            arrivalTimeLabel.attributedText = coloredString
        }
        
        return arrivalTimeLabel
    }
    
    func SecsToMins(secsToArrival: Double) -> Int{
        //Prevent negative values
        return (Int(floor(secsToArrival/60)) > 0) ? Int(floor(secsToArrival/60)) : 0
    }
    
    
    @objc func cacheBlackArrivals(){
        //print(stopId)
        //        self.restApiManager.getArrivals(stopId: stopId){
        //            (arrivals) in
        //            print(arrivals)
        //        }
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
        //print(stopId)
        //        self.restApiManager.getArrivals(stopId: stopId){
        //            (arrivals) in
        //            print(arrivals)
        //        }
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
        //print(stopId)
        //        self.restApiManager.getArrivals(stopId: stopId){
        //            (arrivals) in
        //            print(arrivals)
        //        }
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
    
    func clearTimer(){
        if(self.vanTimer != nil){
            self.vanTimer!.invalidate()
        }
    }

    func clearCache(){
        self.cache.removeAll()
    }
}

