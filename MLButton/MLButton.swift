//
//  MLButton.swift
//  MLButton
//
//  Created by mml on 2019/9/3.
//  Copyright © 2019 li.mingming. All rights reserved.
//

import UIKit

extension UIButton {
    
    public typealias ClickHandler = (_ btn: UIButton) -> Void
    
    private struct UIButtonKeys {
        static var acceptEventIntervalKey = "com.limingming.UIButton.acceptEventIntervalKey"
        static var acceptEventTimeKey = "com.limingming.UIButton.acceptEventTimeKey"
        
        static var clickHandlerKey = "com.limingming.UIButton.clickHandlerKey"
    }
    
    @objc var acceptEventInterval: TimeInterval {
        set {
            objc_setAssociatedObject(self, &UIButtonKeys.acceptEventIntervalKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let value = objc_getAssociatedObject(self, &UIButtonKeys.acceptEventIntervalKey) as? TimeInterval {
                return value
            }
            return 0
        }
    }
    
    @objc private var acceptEventTime: TimeInterval {
        set {
            objc_setAssociatedObject(self, &UIButtonKeys.acceptEventTimeKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let value = objc_getAssociatedObject(self, &UIButtonKeys.acceptEventTimeKey) as? TimeInterval {
                return value
            }
            return 0
        }
    }
    
    @objc private var clickHandler: ClickHandler? {
        set {
            objc_setAssociatedObject(self, &UIButtonKeys.clickHandlerKey, newValue, . OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, &UIButtonKeys.clickHandlerKey) as? ClickHandler
        }
    }
    
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        let current = Date().timeIntervalSince1970
        // 如果这次点击时间减去上次点击事件小于设置的点击间隔，则不执行
        if current - acceptEventTime < acceptEventInterval { return }
        if acceptEventInterval > 0 {
            acceptEventTime = current
        }
        super.sendAction(action, to: target, for: event)
    }
    
    public func add(controlEvents: UIControl.Event, handler: @escaping ClickHandler) {
        clickHandler = handler
        addTarget(self, action: #selector(click(_:)), for: controlEvents)
    }
    
    @objc func click(_ sender: UIButton) {
        clickHandler?(sender)
    }
}
