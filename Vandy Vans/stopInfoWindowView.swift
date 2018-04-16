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

class stopInfoWindowView{
    
    let stopId: String!
    let stopName: String!
    let arrivals: JSON!
    
    init(stopId: String, stopName:String, arrivals:JSON) {
        self.stopId = stopId
        self.stopName = stopName
        self.arrivals = arrivals
        
    }
    
    func getInfoView () -> UIView {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
    
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = self.stopName
        view.addSubview(lbl1)
        
        //CHANGE THIS TO TO FORMAT ARRIVALS CORRECTLY ETC
        for index in 0..<self.arrivals.count {
            let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 15 * CGFloat(index), width: view.frame.size.width - 16, height: 15))
            lbl2.text = "stop"
            lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
            view.addSubview(lbl2)
            
//            let stop = stops[index]["ID"].rawString()!
//            let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
//            lbl2.text = stop
//            lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
            view.addSubview(lbl2)
        }
        
        return view
    }
    
    
//    let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
//    view.backgroundColor = UIColor.white
//    view.layer.cornerRadius = 6
//
//    let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
//    lbl1.text = marker.title
//    view.addSubview(lbl1)
    
}
