//
//  Part.swift
//  PartManager
//
//  Created by touchWorld on 2025/2/19.
//

import Foundation

open class Part: NSObject {
    
    public weak var partManager: PartManager?
    
    public private(set) var config: PartConfig
    
    public required init(partManager: PartManager, config: PartConfig) {
        self.partManager = partManager
        self.config = config
    }
    
    deinit {
        
    }
}

// MARK: - ViewController生命周期
@objc extension Part {
    
    open func initVC() {
        
    }
    
    open func viewDidLoad() {
        
    }
    
    open func viewWillLayoutSubviews() {
        
    }
    
    open func viewDidLayoutSubviews() {
        
    }
    
    open func viewWillAppear(_ animated: Bool) {
        
    }
    
    open func viewDidAppear(_ animated: Bool) {
        
    }
    
    open func viewWillDisappear(_ animated: Bool) {
        
    }
    
    open func viewDidDisappear(_ animated: Bool) {
        
    }
}

// MARK: - 模块通信
extension Part {
    
    public typealias NotificationName = Conversation.NotificationName
    public typealias NotificationBlock = Conversation.NotificationBlock
    
    /// 监听通知
    /// - Parameters:
    ///   - name: 通知名
    ///   - block: 通知回调
    public func registerNotification(name: NotificationName,
                                     cb block: @escaping NotificationBlock) {
        partManager?.addObserver(part: self,
                                 notificationName: name,
                                 cb: block)
    }
    
    /// 取消监听所有通知
    public func unregisterAllNotification() {
        partManager?.removeObserver(part: self)
    }
    
    /// 取消监听通知
    /// - Parameter name: 通知名
    public func unregisterNotification(name: NotificationName) {
        partManager?.removeObserver(part: self, notificationName: name)
    }
    
    /// 发送通知给指定的模块（1对1）。
    /// - Parameters:
    ///   - partType: 指定模块对应的类型
    ///   - name: 通知名
    ///   - userInfo: 与通知关联的用户信息。
    public func postNotification(to partType: PartType,
                                 notificationName name: NotificationName,
                                 userInfo: Any?) {
        partManager?.postNotification(to: partType,
                                      notificationName: name,
                                      userInfo: userInfo)
    }
    
    /// 发送通知给模块（1对多）。
    /// - Parameters:
    ///   - name: 通知名
    ///   - userInfo: 与通知关联的用户信息。
    public func postNotification(notificationName name: NotificationName,
                                 userInfo: Any?) {
        partManager?.postNotification(notificationName: name,
                                      userInfo: userInfo)
    }
}

// MARK: - config
extension Part {
    
    public var viewController: UIViewController? {
        config.viewController
    }
}
