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
    var patternID: String!
    var secsToArrival: Double!
}

class StopInfoPopupViewCreator{
    
    let restApiManager = RestApiManager()
    
    func generateStopInfoWindowView(marker:GMSMarker, arrivals:JSON) -> UIView{
        
        //Make White Rounded rectange
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 100))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10

        
        let stopNameLabel = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 25))
        stopNameLabel.text = marker.title
        stopNameLabel.font =  UIFont.systemFont(ofSize: 20, weight: .regular)
        view.addSubview(stopNameLabel)
        
        var arriveTimes = [ArrivalInfo]()
        if (arrivals != JSON.null){
            for i in 0..<arrivals.count {
                let arr = arrivals[i]["Arrivals"]
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
}
