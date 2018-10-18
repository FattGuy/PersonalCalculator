//
//  ResultaViewControllerPresenter.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import Foundation

protocol ResultViewControllerView: BaseView {
    func showResutl(_ result: String?)
}

//No return statements
class ResultViewControllerPresenter: NSObject {
    
    weak var view: ResultViewControllerView?
    var result: String?
    
    init(with view: ResultViewControllerView, result: String?) {
        self.view = view
        self.result = result
    }
    
    func start() {
        getResult(self.result)
    }
}

//API
extension ResultViewControllerPresenter {
    func getResult(_ result: String?) {
        view?.showResutl(result)
    }
}
