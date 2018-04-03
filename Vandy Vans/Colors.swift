//
//  ColorPalette.swift
//  Vandy Vans
//
//  Created by Ankur Lal on 4/2/18.
//  Copyright © 2018 Berger-Lal. All rights reserved.
//

import Foundation
import UIKit

struct ColorWheel{
    
    let black:UIColor
    let red:UIColor
    let gold:UIColor
    
    init() {
        black = UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1)
        red  =  UIColor(red: 222.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1)
        gold =  UIColor(red: 233.0/255.0, green: 195.0/255.0, blue: 76.0/255.0, alpha: 1)
    }
    
}

