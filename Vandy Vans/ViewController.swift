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
    var buttonsInit = false
    //let vandyMapView = VandyMapView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Map initially
        self.view = VandyMapView().getVandyMap()
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
            }
        };
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
}

