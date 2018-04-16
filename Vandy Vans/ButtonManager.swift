//
//  ButtonManager.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/16/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import UIKit

class ButtonManager{
    var buttonsInit = false
    
    func initButtons(viewController:ViewController){
        if(!buttonsInit){
            buttonsInit = true

            let buttonSize = CGFloat(85)

            let centerX = viewController.view.center.x
            //shift by button with
            let buttonShift = buttonSize/2
            //Distance between buttons
            let buttonSpacing = CGFloat(110.0)
            //buttons render 20% from bottom
            let vertShift = viewController.view.frame.size.height - viewController.view.frame.size.height/5


            let blackBtn: UIButton = UIButton(type: UIButtonType.custom)
            blackBtn.frame = CGRect(x: (centerX - buttonShift), y: vertShift, width: buttonSize, height: buttonSize)
            blackBtn.setImage(UIImage(named: "BlackRouteButton"),for: .normal)
            blackBtn.addTarget(viewController, action: #selector(viewController.drawBlackRoute), for: .touchUpInside)
            viewController.view.addSubview(blackBtn)

            let redBtn: UIButton = UIButton(type: UIButtonType.custom)
            redBtn.frame = CGRect(x: (centerX - buttonShift - buttonSpacing), y: vertShift, width: buttonSize, height: buttonSize)
            redBtn.setImage(UIImage(named: "RedRouteButton"),for: .normal)
            redBtn.addTarget(viewController, action: #selector(viewController.drawRedRoute), for: .touchUpInside)
            viewController.view.addSubview(redBtn)

            let goldBtn: UIButton = UIButton(type: UIButtonType.custom)
            goldBtn.frame = CGRect(x: (centerX - buttonShift + buttonSpacing), y: vertShift, width: buttonSize, height: buttonSize)
            goldBtn.setImage(UIImage(named: "GoldRouteButton"),for: .normal)
            goldBtn.addTarget(viewController, action: #selector(viewController.drawGoldRoute), for: .touchUpInside)
            viewController.view.addSubview(goldBtn)

        }
    }
}
