//
//  AlertModals.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 09.06.2024.
//

import UIKit

class AlertModals {
    class func
    createAlert(title: String?,
                            message: String?,
                            actions: [UIAlertAction] = []) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        actions.forEach { alert.addAction($0)}
        return alert
    }
    
    class func
    createOkAlert(title: String? ,
                  message: String?,
                  okButton: String,
                  handler: ( () -> Void)? = nil ) -> UIAlertController {
        let okAction = UIAlertAction(title: okButton, style: .default, handler: { _ in handler?() } )
        return createAlert(title: title, message: message, actions: [okAction])
    }
    
    class func
    createOkCancelAlert(title: String?,
                        message: String?,
                        okButton: String = "OK",
                        cancelButton: String = "Cancel",
                        okHandler: ( () -> Void)?,
                        cancelHandler: ( () -> Void)?  = nil) -> UIAlertController {
        let okAction = UIAlertAction(title: okButton,
                                     style: .default,
                                     handler: { _ in okHandler?() } )
        
        let cancelAction = UIAlertAction(title: cancelButton,
                                         style: .cancel,
                                         handler: { _ in cancelHandler?()})
        return createAlert(title: title, message: message, actions: [okAction, cancelAction])
    }
}

