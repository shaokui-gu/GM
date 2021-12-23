//
//  DialogManager.swift
//  kroknow (iOS)
//
//  Created by gavin on 2021/6/10.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import UIKit

public typealias AlertActionCallBack = (UIAlertAction) -> Void

class Dialog {
    
    static let shared = Dialog()
    private var dialogQueue:[UIAlertController] = []
    weak var currentDialog: UIAlertController?
    private init(){}
    
    func showAlert(title:String?, message:String?, confirmTitle:String?, confirmAction:AlertActionCallBack?, cancelTitle:String?, cancelAction:AlertActionCallBack?){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if let confTitle = confirmTitle {
            alert.addAction(UIAlertAction.init(title: confTitle, style: .default, handler: confirmAction))
        }
        if let cancTitle = cancelTitle {
            alert.addAction(UIAlertAction.init(title: cancTitle, style: .cancel, handler: cancelAction))
        }
        let viewController = GM.topPage()?.controller
        viewController?.present(alert, animated: true, completion: nil)
        self.currentDialog = alert
    }
    
    func showActionSheet(title:String?, message:String?, actions:[UIAlertAction], sourceView:UIView? = nil, sourceRect:CGRect? = nil) {
        let actionSheet = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .black
        for action in actions {
            actionSheet.addAction(action)
        }
        
        if actionSheet.popoverPresentationController != nil {
            actionSheet.popoverPresentationController!.sourceView = sourceView
            actionSheet.popoverPresentationController!.sourceRect = sourceRect ?? .zero
        }
        let viewController = GM.topPage()?.controller
        viewController?.present(actionSheet, animated: true, completion: nil)
    }
}


extension GM {
    
    public static var showingDialog:Bool {
        return Dialog.shared.currentDialog != nil
    }
    
    public static var dialogSourceView:UIView {
        return self.topPage()!.controller!.view!
    }
    
    /// alert
    public static func showAlert(title:String?, message:String?, confirmTitle:String?, confirmAction:AlertActionCallBack?, cancelTitle:String?, cancelAction:AlertActionCallBack?){
        Dialog.shared.showAlert(title: title, message: message, confirmTitle: confirmTitle, confirmAction: confirmAction, cancelTitle: cancelTitle, cancelAction: cancelAction)
    }
    
    /// actionsheet
    public static func showActionSheet(title:String?, message:String?, actions:[UIAlertAction], sourceView:UIView? = nil, sourceRect:CGRect? = nil) {
        let sView = self.dialogSourceView
        let sRect = CGRect(x: sView.bounds.midX, y: sView.bounds.maxY, width: 44, height: 44)
        Dialog.shared.showActionSheet(title: title, message: message, actions: actions, sourceView: sourceView ?? sView, sourceRect: sourceRect ?? sRect)
    }
    
}
