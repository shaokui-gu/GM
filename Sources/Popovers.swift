//
//  Popover.swift
//  Polytime
//
//  Created by gavin on 2021/12/19.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public protocol GMPopOverUsable {
    
    var contentSize: CGSize { get }
    var contentView: UIView { get }
    var layoutMargins: UIEdgeInsets { get }
    var popOverBackgroundColor: UIColor? { get }
    var arrowDirection: UIPopoverArrowDirection { get }
    var onDismiss: (() -> Void)? { get }
}

extension GMPopOverUsable {
    
    public var popOverBackgroundColor: UIColor? {
        return nil
    }
    
    public var arrowDirection: UIPopoverArrowDirection {
        return .any
    }
    
    public var layoutMargins : UIEdgeInsets {
        return .zero
    }
    
    public var onDismiss: (() -> Void)? {
        return nil
    }
}

public extension UIPopoverArrowDirection {
    static var none: UIPopoverArrowDirection {
        return UIPopoverArrowDirection(rawValue: 0)
    }
}



public typealias GMPopoverTransitionCompletion = () -> Void
public typealias GMPopoverDismissHandler = ((Bool, GMPopoverTransitionCompletion?) -> Void)

fileprivate class GMPopOverUsableDismissHandlerWrapper {
    var closure: GMPopoverDismissHandler?
    
    init(_ closure: GMPopoverDismissHandler?) {
        self.closure = closure
    }
}

extension UIView {
    
    struct PopoverAssociatedKeys {
        static var onDismissHandler = "onDismissHandler"
    }
    
    var onDismissHandler: GMPopoverDismissHandler? {
        get { return (objc_getAssociatedObject(self, &PopoverAssociatedKeys.onDismissHandler) as? GMPopOverUsableDismissHandlerWrapper)?.closure }
        set { objc_setAssociatedObject(self, &PopoverAssociatedKeys.onDismissHandler, GMPopOverUsableDismissHandlerWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
}

extension GMPopOverUsable where Self: UIView {
    
    public var contentView: UIView {
        return self
    }
    
    public var contentSize: CGSize {
        return frame.size
    }
    
    public func showPopover(sourceView: UIView, sourceRect: CGRect? = nil, shouldDismissOnTap: Bool = true, completion: GMPopoverTransitionCompletion? = nil) {
        let usableViewController = GMPopOverUsableViewController(popOverUsable: self)
        usableViewController.showPopover(sourceView: sourceView,
                                         sourceRect: sourceRect,
                                         shouldDismissOnTap: shouldDismissOnTap,
                                         completion: completion)
        onDismissHandler = { [weak self] (animated, completion) in
            self?.dismiss(usableViewController: usableViewController, animated: animated, completion: completion)
        }
    }
    
    public func showPopover(barButtonItem: UIBarButtonItem, shouldDismissOnTap: Bool = true, completion: GMPopoverTransitionCompletion? = nil) {
        let usableViewController = GMPopOverUsableViewController(popOverUsable: self)
        usableViewController.showPopover(barButtonItem: barButtonItem,
                                         shouldDismissOnTap: shouldDismissOnTap,
                                         completion: completion)
        onDismissHandler = { [weak self] (animated, completion) in
            self?.dismiss(usableViewController: usableViewController, animated: animated, completion: completion)
        }
    }
    
    public func dismissPopover(animated: Bool, completion: GMPopoverTransitionCompletion? = nil) {
        onDismissHandler?(animated, completion)
    }
    
    
    // MARK: - Private
    private func dismiss(usableViewController: GMPopOverUsableViewController, animated: Bool, completion: GMPopoverTransitionCompletion? = nil) {
        if let completion = completion {
            usableViewController.dismiss(animated: animated, completion: { [weak self] in
                self?.onDismissHandler = nil
                completion()
            })
        } else {
            usableViewController.dismiss(animated: animated, completion: nil)
            onDismissHandler = nil
        }
    }
}

extension GMPopOverUsable where Self: UIViewController {
    
    public var contentView: UIView {
        return view
    }
    
    private var rootViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.first { window in
            return window.isKeyWindow
        }
        return keyWindow?.rootViewController?.topPresentedViewController
    }
    
    private var popOverUsableNavigationController: GMPopOverUsableNavigationController {
        let naviController = GMPopOverUsableNavigationController(rootViewController: self)
        naviController.modalPresentationStyle = .popover
        naviController.popoverPresentationController?.delegate = GMPopOverDelegation.shared
        GMPopOverDelegation.shared.dismissHandler = self.onDismiss
        naviController.popoverPresentationController?.backgroundColor = popOverBackgroundColor
        naviController.popoverPresentationController?.permittedArrowDirections = arrowDirection
        naviController.popoverPresentationController?.popoverLayoutMargins = layoutMargins

        return naviController
    }
    
    private func setup() {
        modalPresentationStyle = .popover
        preferredContentSize = contentSize
        popoverPresentationController?.delegate = GMPopOverDelegation.shared
        GMPopOverDelegation.shared.dismissHandler = self.onDismiss
        popoverPresentationController?.backgroundColor = popOverBackgroundColor
        popoverPresentationController?.permittedArrowDirections = arrowDirection
        popoverPresentationController?.popoverLayoutMargins = layoutMargins
    }
    
    public func setupPopover(sourceView: UIView, sourceRect: CGRect? = nil) {
        setup()
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceRect ?? sourceView.bounds
    }
    
    public func setupPopover(barButtonItem: UIBarButtonItem) {
        setup()
        popoverPresentationController?.barButtonItem = barButtonItem
    }
    
    public func showPopover(sourceView: UIView, sourceRect: CGRect? = nil, shouldDismissOnTap: Bool = true, completion: GMPopoverTransitionCompletion? = nil) {
        setupPopover(sourceView: sourceView, sourceRect: sourceRect)
        GMPopOverDelegation.shared.shouldDismissOnOutsideTap = shouldDismissOnTap
        rootViewController?.present(self, animated: true, completion: completion)
    }
    
    public func showPopoverWithNavigationController(sourceView: UIView, sourceRect: CGRect? = nil, shouldDismissOnTap: Bool = true, completion: GMPopoverTransitionCompletion? = nil) {
        let naviController = popOverUsableNavigationController
        naviController.popoverPresentationController?.sourceView = sourceView
        naviController.popoverPresentationController?.sourceRect = sourceRect ?? sourceView.bounds
        GMPopOverDelegation.shared.shouldDismissOnOutsideTap = shouldDismissOnTap
        rootViewController?.present(naviController, animated: true, completion: completion)
    }
    
    public func showPopover(barButtonItem: UIBarButtonItem, shouldDismissOnTap: Bool = true, completion: GMPopoverTransitionCompletion? = nil) {
        setupPopover(barButtonItem: barButtonItem)
        GMPopOverDelegation.shared.shouldDismissOnOutsideTap = shouldDismissOnTap
        rootViewController?.present(self, animated: true, completion: completion)
    }
    
    public func showPopoverWithNavigationController(barButtonItem: UIBarButtonItem, shouldDismissOnTap: Bool = true, completion: GMPopoverTransitionCompletion? = nil) {
        let naviController = popOverUsableNavigationController
        naviController.popoverPresentationController?.barButtonItem = barButtonItem
        GMPopOverDelegation.shared.shouldDismissOnOutsideTap = shouldDismissOnTap
        rootViewController?.present(naviController, animated: true, completion: completion)
    }
    
    public func dismissPopover(animated: Bool, completion: GMPopoverTransitionCompletion? = nil) {
        dismiss(animated: animated, completion: completion)
    }
}

private final class GMPopOverUsableNavigationController: UINavigationController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let popOverUsable = visibleViewController as? GMPopOverUsable {
            preferredContentSize = popOverUsable.contentSize
        } else {
            preferredContentSize = visibleViewController?.preferredContentSize ?? preferredContentSize
        }
    }
    
}

private final class GMPopOverUsableViewController: UIViewController, GMPopOverUsable {
   
    var contentSize: CGSize {
        return popOverUsable.contentSize
    }
    
    var contentView: UIView {
        return view
    }
    
    var popOverBackgroundColor: UIColor? {
        return popOverUsable.popOverBackgroundColor
    }
    
    var arrowDirection: UIPopoverArrowDirection {
        return popOverUsable.arrowDirection
    }
    
    private var popOverUsable: GMPopOverUsable!
    
    convenience init(popOverUsable: GMPopOverUsable) {
        self.init()
        self.popOverUsable = popOverUsable
        preferredContentSize = popOverUsable.contentSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(popOverUsable.contentView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popOverUsable.contentView.frame = view.bounds
    }
    
}

private final class GMPopOverDelegation: NSObject, UIPopoverPresentationControllerDelegate {
    
    static let shared = GMPopOverDelegation()
    var shouldDismissOnOutsideTap: Bool = false
    var dismissHandler:(() -> Void)?
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return shouldDismissOnOutsideTap
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.dismissHandler?()
    }
    
}

open class GMPopoverView : UIViewController, GMPopOverUsable {
    public var contentSize: CGSize = CGSize(width:200, height:174)
    public var arrowDirection: UIPopoverArrowDirection = .none
    public var layoutMargins: UIEdgeInsets = .zero
    public var content:UIViewController
    public var dismissHandler:VoidCallBack?
    public var onDismiss:VoidCallBack? {
        return self.dismissHandler
    }
    
    init(content:UIViewController, contentSize:CGSize = CGSize(width:200, height:174), arrowDirection:UIPopoverArrowDirection = .none, layoutMargins:UIEdgeInsets = .zero, onDissmiss:VoidCallBack? = nil) {
        self.content = content
        self.contentSize = contentSize
        self.arrowDirection = arrowDirection
        self.layoutMargins = layoutMargins
        self.dismissHandler = onDissmiss
        super.init(nibName: nil, bundle: nil)
        view.addSubview(content.view)
        addChild(content)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        content.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        content.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    }
    
    @objc required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class GMPopoverSwiftUIView<Content>: UIHostingController<Content>, GMPopOverUsable where Content : View {
    
    public var contentSize: CGSize = CGSize(width:200, height:174)
    public var arrowDirection: UIPopoverArrowDirection = .none
    public var layoutMargins: UIEdgeInsets = .zero
    public var dismissHandler:VoidCallBack?
    public var onDismiss:VoidCallBack? {
        return self.dismissHandler
    }
    
    init(rootView: Content, contentSize:CGSize = CGSize(width:200, height:174), arrowDirection:UIPopoverArrowDirection = .none, layoutMargins:UIEdgeInsets = .zero, onDissmiss:VoidCallBack? = nil) {
        super.init(rootView: rootView)
        self.contentSize = contentSize
        self.arrowDirection = arrowDirection
        self.layoutMargins = layoutMargins
        self.dismissHandler = onDissmiss
    }
        
    @objc required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class GMPopover {
    
    static let shared = GMPopover()
    private init(){}
    var currentPopover:UIViewController?
    var isShowingPopover:Bool {
        return currentPopover != nil
    }
    
    public func showPopover<contentView:View>(_ view:contentView, contentSize:CGSize = CGSize(width:200, height:174), layoutMargins:UIEdgeInsets = .zero, backgroundColor:UIColor? = .white, sourceRect:CGRect = .zero, onDissmiss:VoidCallBack? = nil) {
        let popover = GMPopoverSwiftUIView(rootView: view, contentSize: contentSize, layoutMargins: layoutMargins, onDissmiss: onDissmiss)
        popover.view.backgroundColor = backgroundColor
        let viewController = GM.topPage()?.controller ?? GM.rootPage()!.controller!
        popover.showPopover(sourceView: viewController.view, sourceRect:sourceRect)
        self.currentPopover = popover
    }
    
    public func showPopover(_ view:UIViewController, contentSize:CGSize = CGSize(width:200, height:174), layoutMargins:UIEdgeInsets = .zero, backgroundColor:UIColor? = .white, sourceRect:CGRect = .zero, onDissmiss:VoidCallBack? = nil) {
        let popover = GMPopoverView(content: view, contentSize: contentSize, layoutMargins: layoutMargins, onDissmiss: onDissmiss)
        popover.view.backgroundColor = backgroundColor
        let viewController = GM.topPage()?.controller ?? GM.rootPage()!.controller!
        popover.showPopover(sourceView: viewController.view, sourceRect:sourceRect)
        self.currentPopover = popover
    }
    
    public func showPopover(_ name:String, params:[String : Any]? = nil, contentSize:CGSize = CGSize(width:200, height:174), layoutMargins:UIEdgeInsets = .zero, backgroundColor:UIColor? = .white, sourceRect:CGRect = .zero, onDissmiss:VoidCallBack? = nil) throws {
        guard let routePage = Router.shared.pages[name] else {
            throw Router.RouteError.init(code: Router.RouteErrorCode.notFound.rawValue, msg: Router.RouteErrorDescription.notFound.rawValue)
        }
        let viewController = routePage.page(params)
        self.showPopover(viewController, contentSize: contentSize, layoutMargins: layoutMargins, backgroundColor: backgroundColor, sourceRect: sourceRect, onDissmiss: onDissmiss)
    }
    
    public func dismiss(animated:Bool = true, completion:VoidCallBack? = nil) {
        self.currentPopover?.dismiss(animated: animated, completion: completion)
    }
}

extension GM {
    
    public static func showPopover<contentView:GMSwiftUIPageView>(_ view:contentView, contentSize:CGSize = CGSize(width:200, height:174), layoutMargins:UIEdgeInsets = .zero, backgroundColor:UIColor? = .white, sourceRect:CGRect = .zero, onDissmiss:VoidCallBack? = nil) {
        GMPopover.shared.showPopover(view, contentSize: contentSize, layoutMargins:layoutMargins, backgroundColor: backgroundColor, sourceRect: sourceRect, onDissmiss: onDissmiss)
    }
    
    public static func showPopover(_ name:String, params:[String : Any]? = nil, contentSize:CGSize = CGSize(width:200, height:174), layoutMargins:UIEdgeInsets = .zero, backgroundColor:UIColor? = .white, sourceRect:CGRect = .zero, onDissmiss:VoidCallBack? = nil) {
        try? GMPopover.shared.showPopover(name, params: params, contentSize: contentSize, layoutMargins:layoutMargins, backgroundColor: backgroundColor, sourceRect: sourceRect, onDissmiss: onDissmiss)
    }
    
    public static func dismissPopover(animated:Bool = true, completion:VoidCallBack? = nil) {
        GMPopover.shared.dismiss(animated: animated, completion: completion)
    }
}
