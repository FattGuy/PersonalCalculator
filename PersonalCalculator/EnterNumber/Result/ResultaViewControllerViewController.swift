//
//  ResultaViewControllerViewController.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import UIKit

class ResultaViewControllerViewController: BaseViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var presenter: ResultaViewControllerPresenter!
    
    //Initializer
    static func create(_ result: String?) -> ResultaViewControllerViewController {
        let vc = UIStoryboard(name: "EnterNumber", bundle: nil).instantiateViewController(withIdentifier: "ResultaViewControllerViewController") as! ResultaViewControllerViewController
        vc.presenter = ResultaViewControllerPresenter(with: vc, result: result)
        return vc
    }
    
    static func createNav(_ result: String?) -> UINavigationController {
        let vc = self.create(result)
        let navc = UINavigationController(rootViewController: vc)
        return navc
    }
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.start()
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ResultaViewControllerViewController: ResultaViewControllerView {
    func showResutl(_ result: String?) {
        resultLabel.text = result
    }
}
