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
        if let price = priceTextField.text, let ratio = ratioTextField.text, let image = myPhotoView.image {
            //presenter.getResult(price: price, ratio: ratio)
            let newImage = self.burnTextToImage(text: price, image: image, atPoint: CGPoint(x: 20, y: 20))
            myPhotoView.image = newImage
        } else {
            self.show(error: "Price and Ratio are both required.")
        }
    }
    
    @IBAction func tappedReset(_ sender: Any) {
        clear()
    }
    
    func clear() {
        self.loadView()
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
        let vc = ResultViewControllerViewController.createNav(resultString)
        self.present(vc, animated: true, completion: nil)
    }
    
    //ImagePickerDelegate method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        myPhotoView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func burnTextToImage(text: String, image: UIImage, atPoint: CGPoint) -> UIImage? {
        // Setup the font specific variables
        let textColor: UIColor = UIColor.red
        let textFont: UIFont = UIFont.systemFont(ofSize: 400)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ]
        
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        
        //Put the image into a rectangle as large as the original image.
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        // Our drawing bounds
        let drawingBounds = CGRect(origin: CGPoint.zero, size: image.size)
        
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font:textFont])
        let textRect = CGRect(x: drawingBounds.size.width/2 - textSize.width/2, y: drawingBounds.size.height/2 - textSize.height/2,
                              width: textSize.width, height: textSize.height)
        
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // Get the image from the graphics context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
