//
//  EnterNumberPresenter.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import Foundation

protocol EnterNumberView: BaseView {
    func goToResultScreen(_ result: Double)
    func accessCamera()
    func accessGallery()
}

//No return statements
class EnterNumberPresenter: NSObject {
    
    weak var view: EnterNumberView?
    
    init(with view: EnterNumberView) {
        self.view = view
    }
    
    func start() {
        
    }
}

//API
extension EnterNumberPresenter {
    func getResult(price: String, ratio: String) {
        if let price = Double(price), let ratio = Double(ratio) {
            let result = price * ratio
            view?.goToResultScreen(result)
        }
    }
    
    func selectCamera() {
        view?.accessCamera()
    }
    
    func selectGallery() {
        view?.accessGallery()
    }
}
