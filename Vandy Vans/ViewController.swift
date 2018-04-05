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

class ViewController: UIViewController {
    let restApiManager = RestApiManager();
    //let vandyMapView = VandyMapView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        //Load Map Background
        self.view = VandyMapView().getVandyMap()
        //drawBlackRoute()
        drawRedRoute()
        //drawGoldRoute()
    }
    
    @objc func drawBlackRoute(){
        self.restApiManager.getWaypoints(vanColor: "BLACK") {
            (waypoints) in
            self.restApiManager.getStops(vanColor: "BLACK") {
                (stops) in
                //add route
                self.view =  VandyMapView().drawRouteWithStops(waypoints: waypoints, stops:stops, color:ColorWheel().black)
                
                let blackBtn: UIButton = UIButton(type: UIButtonType.custom)
                blackBtn.frame = CGRect(x: 90, y: self.view.frame.size.height - 200, width: 200, height: 200)
                blackBtn.setImage(UIImage(named: "BlackRouteButton"),for: .normal)
                //blackBtn.addTarget(self, action: #selector(self.drawBlackRoute), for: .touchUpInside)
                self.view.addSubview(blackBtn)
                
                let redBtn: UIButton = UIButton(type: UIButtonType.custom)
                redBtn.frame = CGRect(x: -20, y: self.view.frame.size.height - 200, width: 200, height: 200)
                redBtn.setImage(UIImage(named: "RedRouteButton"),for: .normal)
                redBtn.addTarget(self, action: #selector(self.drawRedRoute), for: .touchUpInside)
                self.view.addSubview(redBtn)
                
                let goldBtn: UIButton = UIButton(type: UIButtonType.custom)
                goldBtn.frame = CGRect(x: 200, y: self.view.frame.size.height - 200, width: 200, height: 200)
                goldBtn.setImage(UIImage(named: "GoldRouteButton"),for: .normal)
                goldBtn.addTarget(self, action: #selector(self.drawGoldRoute), for: .touchUpInside)
                self.view.addSubview(goldBtn)
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
                
                let blackBtn: UIButton = UIButton(type: UIButtonType.custom)
                blackBtn.frame = CGRect(x: 90, y: self.view.frame.size.height - 200, width: 200, height: 200)
                blackBtn.setImage(UIImage(named: "BlackRouteButton"),for: .normal)
                blackBtn.addTarget(self, action: #selector(self.drawBlackRoute), for: .touchUpInside)
                self.view.addSubview(blackBtn)

                let redBtn: UIButton = UIButton(type: UIButtonType.custom)
                redBtn.frame = CGRect(x: -20, y: self.view.frame.size.height - 200, width: 200, height: 200)
                redBtn.setImage(UIImage(named: "RedRouteButton"),for: .normal)
                //redBtn.addTarget(self, action: #selector(self.drawRedRoute), for: .touchUpInside)
                self.view.addSubview(redBtn)
                
                let goldBtn: UIButton = UIButton(type: UIButtonType.custom)
                goldBtn.frame = CGRect(x: 200, y: self.view.frame.size.height - 200, width: 200, height: 200)
                goldBtn.setImage(UIImage(named: "GoldRouteButton"),for: .normal)
                goldBtn.addTarget(self, action: #selector(self.drawGoldRoute), for: .touchUpInside)
                self.view.addSubview(goldBtn)
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
                
                let blackBtn: UIButton = UIButton(type: UIButtonType.custom)
                blackBtn.frame = CGRect(x: 90, y: self.view.frame.size.height - 200, width: 200, height: 200)
                blackBtn.setImage(UIImage(named: "BlackRouteButton"),for: .normal)
                blackBtn.addTarget(self, action: #selector(self.drawBlackRoute), for: .touchUpInside)
                self.view.addSubview(blackBtn)
                
                let redBtn: UIButton = UIButton(type: UIButtonType.custom)
                redBtn.frame = CGRect(x: -20, y: self.view.frame.size.height - 200, width: 200, height: 200)
                redBtn.setImage(UIImage(named: "RedRouteButton"),for: .normal)
                redBtn.addTarget(self, action: #selector(self.drawRedRoute), for: .touchUpInside)
                self.view.addSubview(redBtn)
                
                let goldBtn: UIButton = UIButton(type: UIButtonType.custom)
                goldBtn.frame = CGRect(x: 200, y: self.view.frame.size.height - 200, width: 200, height: 200)
                goldBtn.setImage(UIImage(named: "GoldRouteButton"),for: .normal)
                //goldBtn.addTarget(self, action: #selector(self.drawGoldRoute), for: .touchUpInside)
                self.view.addSubview(goldBtn)
            }
        };
    }
}

