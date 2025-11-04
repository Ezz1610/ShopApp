//
//  extensions.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//

import SwiftUI

extension Numeric {
    var h: CGFloat {
        
        CGFloat(truncating: self as! NSNumber) / 100 * UIScreen.main.bounds.height
    }

    var w: CGFloat {
        CGFloat(truncating: self as! NSNumber) / 100 * UIScreen.main.bounds.width
    }

    var sp: CGFloat {
        (CGFloat(truncating: self as! NSNumber) * UIScreen.main.bounds.width / 3) / 100
    }
}
