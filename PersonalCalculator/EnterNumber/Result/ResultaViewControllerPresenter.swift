//
//  ResultaViewControllerPresenter.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import Foundation

protocol ResultaViewControllerView: BaseView {
    func showResutl(_ result: String?)
}

//No return statements
class ResultaViewControllerPresenter: NSObject {
    
    weak var view: ResultaViewControllerView?
    var result: String?
    
    init(with view: ResultaViewControllerView, result: String?) {
        self.view = view
        self.result = result
    }
    
    func start() {
        getResult(self.result)
    }
}

//API
extension ResultaViewControllerPresenter {
    func getResult(_ result: String?) {
        view?.showResutl(result)
    }
}
