//
//  stopInfoWindowView.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/12/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import GoogleMaps

struct ArrivalInfo{
    var routeID: String!
    var minsToArrival: Int!
}

class StopInfoPopupViewCreator{
    
    let restApiManager = RestApiManager()
    
    func generateStopInfoWindowView(marker:GMSMarker, arrivals:JSON, stopId:String) -> UIView{
        
        //Make White Rounded rectange
        let view = UIView(frame:CGRect.init(x: 20, y: 10, width: 200, height: 100))
        let containerView = UIView(frame:CGRect.init(x: 0, y: 0, width: 240, height: 120))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.0
        
        //Add dropshadow
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 1
        view.layer.masksToBounds = false
        containerView.addSubview(view)

        let stopNameLabel = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 25))
        stopNameLabel.text = marker.title
        stopNameLabel.font = UIFont(name: "Raleway-Medium", size: 20)

        view.addSubview(stopNameLabel)
        
        var arriveTimes = [ArrivalInfo]()
        if (arrivals != JSON.null){
            //print(arrivals)
            let unnesst = arrivals["etas"][stopId]["etas"]
            //print(unnesst)
            for i in 0..<unnesst.count {
                let routeID = unnesst[i]["route"].rawString()!
                let minsToArrival = unnesst[i]["avg"].intValue
                let arrivalInfo = ArrivalInfo(routeID: routeID, minsToArrival: minsToArrival)
                arriveTimes.append(arrivalInfo)
            }
        }
        
        arriveTimes.sort(by: {$0.minsToArrival < $1.minsToArrival})
        let numArrivalsToDisplay = 4
        for index in 0..<numArrivalsToDisplay {

            if (arriveTimes.count >= (index + 1)){
                let arrivalTimeLabel = ArrivalInfoToArrivalLabel(arrivalInfo: arriveTimes[index], parentView: view, parentLabel: stopNameLabel, labelNumber: index)
                view.addSubview(arrivalTimeLabel)
            }
        }
        return containerView
    }
    
    func ArrivalInfoToArrivalLabel(arrivalInfo : ArrivalInfo, parentView:UIView, parentLabel:UILabel, labelNumber:Int) -> UILabel{
        let routeID = arrivalInfo.routeID
        let minsToArrival = arrivalInfo.minsToArrival
        let arrivalTimeLabel = UILabel(frame: CGRect.init(x: parentLabel.frame.origin.x, y: parentLabel.frame.origin.y +
            parentLabel.frame.size.height + 15 * CGFloat(labelNumber), width: parentView.frame.size.width - 16, height: 15))
        arrivalTimeLabel.font = UIFont(name: "Raleway", size: 15)
        
        if(routeID == self.restApiManager.black.routeID){
            let labelString = "Black\t\t\t\(minsToArrival!)\tMins"
            let coloredString = NSMutableAttributedString(string: labelString)
            coloredString.addAttribute(NSAttributedStringKey.foregroundColor, value: ColorWheel().black, range: NSRange(location:0,length:6))
            arrivalTimeLabel.attributedText = coloredString
        }else if(routeID == self.restApiManager.red.routeID){
            let labelString = "Red \t\t\t\(minsToArrival!)\tMins"
            let coloredString = NSMutableAttributedString(string: labelString)
            coloredString.addAttribute(NSAttributedStringKey.foregroundColor, value: ColorWheel().red, range: NSRange(location:0,length:4))
            arrivalTimeLabel.attributedText = coloredString
        }else if(routeID == self.restApiManager.gold.routeID){
            let labelString = "Gold\t\t\t\(minsToArrival!)\tMins"
            let coloredString = NSMutableAttributedString(string: labelString)
            coloredString.addAttribute(NSAttributedStringKey.foregroundColor, value: ColorWheel().gold, range: NSRange(location:0,length:5))
            arrivalTimeLabel.attributedText = coloredString
        }
        
        return arrivalTimeLabel
    }

}
