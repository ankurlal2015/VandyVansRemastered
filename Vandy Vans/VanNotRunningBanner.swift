//
//  VanNotRunningBanner.swift
//  Vandy Van
//
//  Created by Ankur Lal on 8/20/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import UIKit

class VanNotRunningBanner{
    
    func createBanner(vanColor:String) -> UIView{
        let text = "No" + vanColor + "Vans Running"
        
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
        
        let notRunningText = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 25))
        notRunningText.text = text
        notRunningText.font = UIFont(name: "Raleway-Medium", size: 20)
        
        view.addSubview(notRunningText)
        
        return containerView
    }
}
