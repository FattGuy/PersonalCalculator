//
//  ResultaViewControllerViewController.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import UIKit

class ResultViewControllerViewController: BaseViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    var presenter: ResultViewControllerPresenter!
    
    //Initializer
    static func create(_ result: String?) -> ResultViewControllerViewController {
        let vc = UIStoryboard(name: "EnterNumber", bundle: nil).instantiateViewController(withIdentifier: "ResultViewControllerViewController") as! ResultViewControllerViewController
        vc.presenter = ResultViewControllerPresenter(with: vc, result: result)
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

extension ResultViewControllerViewController: ResultViewControllerView {
    func showResutl(_ result: String?) {
        #warning ("todo")
    }
}
