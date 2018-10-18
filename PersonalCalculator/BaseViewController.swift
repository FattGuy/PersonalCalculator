//
//  BaseViewController.swift
//  koch-driver
//
//  Created by Alexander Larson on 2/6/17.
//  Copyright © 2017 Myriad Mobile. All rights reserved.
//

import UIKit
protocol BaseView: class {
    //Error Handlers
    func show(error message: String)
    func handleNetworkError(_ message: String, _ retryAction: @escaping (() -> Void))
    
    //URL Handlers
    func openUrl(_ url: URL)
    func share(url: String?)
}

class BaseViewController: UIViewController, BaseView {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var refreshView: UIScrollView?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationBecameActive() {
        // perform view actions for applicationdidBecomeActive() notification
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Custom Keyboard Handling
    // Add unregister in the future? I don't think we really need it though.
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        guard bottomConstraint != nil else {
            print("BaseVC Warning: Bottom constraint not installed; cannot handle for keyboard")
            return
        }
    
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        bottomConstraint.constant = keyboardOffset(keyboardSize?.height ?? 0)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        guard bottomConstraint != nil else {
            print("BaseVC Warning: Bottom constraint not installed; cannot handle for keyboard")
            return
        }
        
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardOffset(_ keyboardHeight: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let viewHeight = view.frame.height
        
        return keyboardHeight - (screenHeight - viewHeight) //Compensate for elements like tab bar
    }
    
    // MARK: - Resigns
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func endEditing(_ force: Bool) {
        view.endEditing(true)
    }
    
    // MARK: - Error Handlers
    
    func handleNetworkError(_ message: String, _ retryAction: @escaping (() -> Void)) {
        let retry = UIAlertAction(title: "Retry", style: .default) { (_) in retryAction() }
        showAlert(title: "Error", message: message, cancelTitle: "OK", otherActions: [retry], cancelHandler: nil)
    }
    
    func show(error message: String) {
        showAlert(title: "Error", message: message, cancelTitle: "OK", otherActions: nil, cancelHandler: nil)
    }
    
    func show(notError message: String) {
        showAlert(title: "Good", message: message, cancelTitle: "OK", otherActions: nil, cancelHandler: nil)
    }
    
    @objc func doneClicked(sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK: - Alert
    
    func showAlert(title: String?, message: String?, cancelTitle: String?, otherActions: [UIAlertAction]?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: cancelTitle ?? "Cancel", style: .cancel, handler: cancelHandler)
        
        alertController.addAction(cancelButton)
        
        if let actions = otherActions {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - URL Handlers
    
    func openUrl(_ url: URL) {
        UIApplication.shared.openURL(url)
    }
    
    func share(url: String?) {
        if let url = URL(string: url ?? "") {
            let activitySheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            navigationController?.present(activitySheet, animated: true, completion: nil)
        }
    }
}
