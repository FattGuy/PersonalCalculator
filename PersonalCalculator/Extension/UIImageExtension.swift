//
//  UIImageExtension.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 10/18/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    typealias EditSubviewClosure<T: UIView> = (_ parentSize: CGSize, _ viewToAdd: T)->()
    
    func with<T: UIView>(view: T, editSubviewClosure: EditSubviewClosure<T>) -> UIImage {
        
        if let copiedView = view.copyObject() as? T {
            UIGraphicsBeginImageContext(size)
            
            let basicSize = CGRect(origin: .zero, size: size)
            draw(in: basicSize)
            editSubviewClosure(size, copiedView)
            copiedView.draw(basicSize)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        return self
        
    }
}
