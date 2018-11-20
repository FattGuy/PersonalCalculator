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
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var extraTextField: UITextField!
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
        priceTextField.delegate = self
        if presenter == nil {
            presenter = EnterNumberPresenter(with: self)
        }
    }
    
    @IBAction func tappedSave(_ sender: Any) {
        if let image = myPhotoView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //Photo
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
    @IBAction func tappedWatermark(_ sender: Any) {
        if let price = presenter.price, let image = myPhotoView.image {
            let priceDouble = Double(price) ?? 0
            let finalPriceDouble = priceDouble
            let finalPrice = String(format: "$%.3f", finalPriceDouble)
            let newImage = self.burnTextToImage(text: finalPrice, image: image)
            myPhotoView.image = newImage
        } else {
            self.show(error: "Price and Ratio are both required.")
        }
    }
    
    @IBAction func tappedFinal(_ sender: Any) {
        if let final = extraTextField.text {
            let finalPirce = (Double(final) ?? 0)
            priceTextField.text = finalPirce.description
            presenter.updatePrice(priceTextField.text)
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
    
    func burnTextToImage(text: String, image: UIImage) -> UIImage? {
        // Setup the font specific variables
        let textColor: UIColor = UIColor.red
        let textFont: UIFont = UIFont.systemFont(ofSize: 200)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ]
        
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        
        //Put the image into a rectangle as large as the original image.
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font:textFont])
        let textRect = CGRect(x: 16, y: 16,
                              width: textSize.width, height: textSize.height)
        
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // Get the image from the graphics context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension EnterNumberViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let mnTax = 1.07
        let price = (Double(textField.text ?? "0") ?? 0) * mnTax
        textField.text = price.description
        presenter.updatePrice(textField.text)
        return true
    }
}
