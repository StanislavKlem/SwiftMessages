//
//  WindowViewController.swift
//  SwiftMessages
//
//  Created by Timothy Moose on 8/1/16.
//  Copyright © 2016 SwiftKick Mobile LLC. All rights reserved.
//

import UIKit

open class WindowViewController: UIViewController
{
    override open var shouldAutorotate: Bool {
        return config.shouldAutorotate
    }

    convenience public init() {
        self.init(config: SwiftMessage.Config())
    }

    public init(config: SwiftMessage.Config) {
        self.config = config
        let view = PassthroughView()
        let window = PassthroughWindow(hitTestView: view)
        self.window = window
        super.init(nibName: nil, bundle: nil)
        self.view = view
        window.rootViewController = self
        window.windowLevel = config.windowLevel ?? UIWindow.Level.normal
        if #available(iOS 13, *) {
            window.overrideUserInterfaceStyle = config.overrideUserInterfaceStyle
        }
    }

    func install() {
        if #available(iOS 13, *) {
            window?.windowScene = config.windowScene
            #if !SWIFTMESSAGES_APP_EXTENSIONS
            previousKeyWindow = UIWindow.keyWindow
            #endif
            show(
                becomeKey: config.shouldBecomeKeyWindow,
                frame: config.windowScene?.coordinateSpace.bounds
            )
        } else {
            show(becomeKey: config.shouldBecomeKeyWindow)
        }
    }

    open func show(becomeKey: Bool, frame: CGRect? = nil) {
        guard let window = window else { return }
        window.frame = frame ?? UIScreen.main.bounds
        if becomeKey {
            window.makeKeyAndVisible()
        } else {
            window.isHidden = false
        }
    }
    
    func uninstall() {
        if window?.isKeyWindow == true {
            previousKeyWindow?.makeKey()
        }
        if #available(iOS 13, *) {
            window?.windowScene = nil
        }
        window?.isHidden = true
        window = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return config.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }

    open override var prefersStatusBarHidden: Bool {
        return config.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }

    // MARK: - Variables

    private var window: UIWindow?
    private weak var previousKeyWindow: UIWindow?

    let config: SwiftMessage.Config
}

extension WindowViewController {
    static func newInstance(config: SwiftMessage.Config) -> WindowViewController {
        return config.windowViewController?(config) ?? WindowViewController(config: config)
    }
}
