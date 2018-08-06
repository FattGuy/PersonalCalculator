//
//  EnterNumberViewController.swift
//  PersonalCalculator
//
//  Created by Feng Chang on 8/5/18.
//  Copyright © 2018 Feng Chang. All rights reserved.
//

import UIKit

class EnterNumberViewController: BaseViewController {
    
    @IBOutlet weak var myPhotoView: UIImageView!
    @IBOutlet weak var reTakeButton: UIButton!
    @IBOutlet weak var takeButton: UIButton!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ratioTextField: UITextField!
    
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
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
    
    //Photo
    @IBAction func tappedReTakePhoto(_ sender: Any) {
        //TODO:
    }
    
    @IBAction func tappedTakePhoto(_ sender: Any) {
        self.selectSource()
    }
    
    func selectSource() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presenter.selectCamera()
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.presenter.selectGallery()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(camera)
        sheet.addAction(gallery)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
    }
    
    //Calculate
    @IBAction func tappedResult(_ sender: Any) {
        if let price = priceTextField.text, let ratio = ratioTextField.text {
            presenter.getResult(price: price, ratio: ratio)
        } else {
            self.show(error: "Price and Ratio are both required.")
        }
    }
    
    @IBAction func tappedReset(_ sender: Any) {
        //TODO:
    }
}

extension EnterNumberViewController: EnterNumberView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pc = UIImagePickerController()
            pc.delegate = self
            pc.sourceType = .camera
            self.present(pc, animated: true, completion: nil)
        }
    }
    
    func accessGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pc = UIImagePickerController()
            pc.delegate = self
            pc.sourceType = .photoLibrary
            self.present(pc, animated: true, completion: nil)
        }
    }
    
    func goToResultScreen(_ result: Double) {
        let resultString = String(result)
        let vc = ResultaViewControllerViewController.createNav(resultString)
        self.present(vc, animated: true, completion: nil)
    }
    
    //ImagePickerDelegate method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    }
}
