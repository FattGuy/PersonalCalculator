//
//  Product.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 11/20/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import Foundation
import UIKit

class Product: NSObject {
    var name: String?
    var image: String?
    var price: String?
    var color: UIColor?
    
    
    init(name: String?, image: String?, price: String?, color: UIColor?) {
        self.name = name
        self.image = image
        self.price = price
        self.color = color
    }
}
