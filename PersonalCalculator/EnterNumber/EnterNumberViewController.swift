//
//  EnterNumberViewController.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import UIKit

class EnterNumberViewController: BaseViewController {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ratioTextField: UITextField!
    @IBOutlet weak var resultButton: UIButton!
    
    var presenter: EnterNumberPresenter!
    
    //Initializer
    static func create() -> EnterNumberViewController {
        let vc = UIStoryboard(name: "EnterNumber", bundle: nil).instantiateViewController(withIdentifier: "EnterNumberViewController") as! EnterNumberViewController
        vc.presenter = EnterNumberPresenter(with: vc)
        return vc
    }
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if presenter == nil {
            presenter = EnterNumberPresenter(with: self)
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func tappedResult(_ sender: Any) {
        if let price = priceTextField.text, let ratio = ratioTextField.text {
            presenter.getResult(price: price, ratio: ratio)
        } else {
            self.show(error: "Price and Ratio are both required.")
        }
    }
}

extension EnterNumberViewController: EnterNumberView {
    func goToResultScreen(_ result: Double) {
        let resultString = String(result)
        let vc = ResultaViewControllerViewController.createNav(resultString)
        self.present(vc, animated: true, completion: nil)
    }
}
