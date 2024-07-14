//
//  AlertViewManager.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

struct AlertControllerInfo {
    var presentingVC: UIViewController
    var alertController: UIAlertController
}

public class AlertViewManager: NSObject {
    
    public class var shared: AlertViewManager {
        struct Static {
            static let instance : AlertViewManager = AlertViewManager()
        }
        return Static.instance
    }
    
    fileprivate var alertCtrls = [AlertControllerInfo]()
    
    public func showOkAlert(_ title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.cancel, handler: handler)
        
        self.showAlert(title, message: message, actions: [okAction], style: UIAlertController.Style.alert, view: nil)
    }
    
    public func showErrorAlert(error: Error) {
        self.showOkAlert("Error!", message: error.localizedDescription, handler: nil)
    }
    
    public func showRequestError(_ isNoInternet: Bool, completion: ((Bool) -> ())?) {
        let title = isNoInternet ? "Şəbəkə bağlantısı yoxdur" : "Gözlənilməz xəta baş verdi!"
        let message = isNoInternet ? "Lütfən, internet bağlantınızı yoxlayın və yenidən cəhd edin." : "Bir daha cəhd edin."
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Bağla", style: .cancel, handler: { (alertAction) in
            completion?(false)
        }))
        alertVC.addAction(UIAlertAction(title: "Yeniden cehd ele", style: .default, handler: { (alertAction) in
            completion?(true)
        }))
        
        if let presentingViewController = UIApplication.shared.keyWindow?.rootViewController {
            if let presentedModalVC = presentingViewController.presentedViewController {
                presentedModalVC.present(alertVC, animated: true, completion: nil)
            }
            else {
                presentingViewController.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func cancelAllAlerts() {
        for alertCtrl in alertCtrls {
            if alertCtrl.alertController.presentingViewController != nil {
                alertCtrl.presentingVC.dismiss(animated: false, completion: {
                    
                    if let index = self.findAlertController(alertCtrl.alertController) {
                        self.alertCtrls.remove(at: index)
                    }
                })
            } else {
                 self.alertCtrls.remove(at: self.findAlertController(alertCtrl.alertController)!)
            }
        }
    }
    
    fileprivate func showActions(_ title: String?, message: String?, actions: [UIAlertAction], view: AnyObject) {
        self.showAlert(title, message: message, actions: actions, style: UIAlertController.Style.actionSheet, view: view)
    }
    
    fileprivate func showAlert(_ title: String?, message: String?, actions: [UIAlertAction]) {
        self.showAlert(title, message: message, actions: actions, style: UIAlertController.Style.alert, view: nil)
    }

    fileprivate func showAlert(_ title: String?, message: String?, actions: [UIAlertAction], style: UIAlertController.Style, view: AnyObject?) {
        
        let alertController = UIAlertController.init(title: title, message: message == "" ? nil : message, preferredStyle: style) as UIAlertController
        
        for action: UIAlertAction in actions {
            alertController.addAction(action)
        }
        
        if let app = UIApplication.shared.delegate, let window = app.window, let presentingViewController = window?.rootViewController {
            
            let popOverPresentationVC = alertController.popoverPresentationController
            
            if let popover = popOverPresentationVC {
                if let view = view as? UIBarButtonItem {
                    popover.barButtonItem = view
                }
                else if let view = view as? UIView {
                    popover.sourceView = view;
                    popOverPresentationVC?.sourceRect = view.bounds;
                } else {
                    popOverPresentationVC?.sourceView = presentingViewController.view;
                    popOverPresentationVC?.sourceRect = presentingViewController.view.bounds;
                }
                
                popOverPresentationVC?.permittedArrowDirections = UIPopoverArrowDirection.any;
            }
            
            self.presentAlertController(alertController, presentingViewController: presentingViewController)
        }
    }
    
    fileprivate func showAlertWithController(_ alertController : UIAlertController) {
        if let presentingViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            self.presentAlertController(alertController, presentingViewController: presentingViewController)
        }
    }
    
    fileprivate func presentAlertController(_ alertController : UIAlertController, presentingViewController : UIViewController) {
        DispatchQueue.main.async { () -> Void in
            
            if let presentedModalVC = presentingViewController.presentedViewController {
                presentedModalVC.present(alertController, animated: true, completion: nil)
                self.alertCtrls.append(AlertControllerInfo(presentingVC:presentedModalVC, alertController: alertController))
            }
            else {
                presentingViewController.present(alertController, animated: true, completion: nil)
                self.alertCtrls.append(AlertControllerInfo(presentingVC:presentingViewController, alertController: alertController))
            }
        }
    }
    
    fileprivate func findAlertController(_ alertCtrl: UIAlertController) -> Int? {
        for i in 0..<alertCtrls.count {
            if alertCtrls[i].alertController == alertCtrl {
                return i
            }
        }
        return nil
    }
}
