//
//  UIViewExtension.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 10/18/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func copyObject<T: UIView> () -> T? {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? T
    }
}
