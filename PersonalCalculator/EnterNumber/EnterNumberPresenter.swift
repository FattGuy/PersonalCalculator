//
//  EnterNumberPresenter.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import Foundation

protocol EnterNumberView: BaseView {
    func accessCamera()
    func accessGallery()
}

//No return statements
class EnterNumberPresenter: NSObject {
    
    weak var view: EnterNumberView?
    var price: String?
    
    init(with view: EnterNumberView) {
        self.view = view
    }
    
    func start() {
        
    }
}

//API
extension EnterNumberPresenter {
    func updatePrice(_ price: String?) {
        self.price = price
    }
    
    func selectCamera() {
        view?.accessCamera()
    }
    
    func selectGallery() {
        view?.accessGallery()
    }
}
