//
//  PartManager.swift
//  PartManager
//
//  Created by touchWorld on 2025/2/19.
//

import Foundation
import UIKit

public typealias PartType = String

/// 模块管理
open class PartManager {
    
    /// 直接加载模块
    open var directParts: [PartType: Part.Type] {
        return [:]
    }

    /// 懒加载模块
    open var lazyParts: [PartType: Part.Type] {
        return [:]
    }
    
    // TODO: - 加锁
    /// 注册的模块
    public private(set) var parts: [PartType: Part] = [:]
    
    public private(set) var config: PartConfig
    
    /// 模块通信
    private let conversation = Conversation()
    /// 生命周期记录
    private let lifeCycleRecord = LifeCycleRecord()
    
    public init(config: PartConfig) {
        self.config = config
        registerDirectPart()
    }
    
    deinit {

    }
    
    
}

extension PartManager {
    
    public func contains(_ partType: PartType) -> Bool {
        parts.keys.contains(partType)
    }
    
    public func getPart(_ partType: PartType) -> Part? {
        if let part = getRegisteredPart(partType) {
            return part
        }
        // 是不是懒加载模块
        if let partClass = lazyParts[partType] {
            registerPart(partType, partClass: partClass)
            let part = getRegisteredPart(partType)
            return part
        }
        return nil
    }
    
    public func getRegisteredPart(_ partType: PartType) -> Part? {
        parts[partType]
    }
}

// MARK: - 注册
extension PartManager {
    
    private func registerDirectPart() {
        for (partType, partClass) in directParts {
            registerPart(partType, partClass: partClass)
        }
    }
    
    public func registerPart(_ partType: PartType, partClass: Part.Type) {
        if let part = parts[partType] {
            DLog("duplicate register,type:\(partType),old:\(type(of: part)),new:\(partClass)")
            return
        }
        let newPart = partClass.init(partManager: self, config: config)
        // 恢复生命周期
        lifeCycleRecord.restore(newPart)
        parts[partType] = newPart
    }
    
    public func unRegisterPart(_ partType: PartType) {
        parts[partType] = nil
    }
    
}

// MARK: - 模块通信
extension PartManager {
    
    public typealias NotificationName = Conversation.NotificationName
    public typealias NotificationBlock = Conversation.NotificationBlock
    
    public func addObserver(part: Part,
                            notificationName name: NotificationName,
                            cb block: @escaping NotificationBlock) {
        conversation.addObserver(part: part,
                                 notificationName: name,
                                 cb: block)
    }
    
    public func removeObserver(part: Part) {
        conversation.removeObserver(part: part)
    }
    
    public func removeObserver(part: Part,
                               notificationName name: NotificationName) {
        conversation.removeObserver(part: part,
                                    notificationName: name)
    }
    
    public func postNotification(to partType: PartType,
                                 notificationName name: NotificationName,
                                 userInfo: Any?) {
        guard let part = getPart(partType) else { return }
        postNotification(to: part,
                         notificationName: name,
                         userInfo: userInfo)
    }
    
    public func postNotification(notificationName name: NotificationName,
                                 userInfo: Any?) {
        for part in parts.values {
            postNotification(to: part,
                             notificationName: name,
                             userInfo: userInfo)
        }
    }
    
    private func postNotification(to part: Part,
                                  notificationName name: NotificationName,
                                  userInfo: Any?) {
        conversation.post(to: part,
                          notificationName: name,
                          userInfo: userInfo)
    }
}

// MARK: - config
extension PartManager {
    
    public var viewController: UIViewController? {
        config.viewController
    }
}


// MARK: - ViewController生命周期
@objc extension PartManager {
    
    open func initVC() {
        lifeCycleRecord.record(.initVC)
        parts.forEach { (_, part) in
            part.initVC()
        }
    }
    
    open func viewDidLoad() {
        lifeCycleRecord.record(.viewDidLoad)
        parts.forEach { (_, part) in
            part.viewDidLoad()
        }
    }
    
    open func viewWillLayoutSubviews() {
        lifeCycleRecord.record(.viewWillLayoutSubviews)
        parts.forEach { (_, part) in
            part.viewWillLayoutSubviews()
        }
    }
    
    open func viewDidLayoutSubviews() {
        lifeCycleRecord.record(.viewDidLayoutSubviews)
        parts.forEach { (_, part) in
            part.viewDidLayoutSubviews()
        }
    }
    
    open func viewWillAppear(_ animated: Bool) {
        lifeCycleRecord.record(.viewWillAppear)
        parts.forEach { (_, part) in
            part.viewWillAppear(animated)
        }
    }
    
    open func viewDidAppear(_ animated: Bool) {
        lifeCycleRecord.record(.viewDidAppear)
        parts.forEach { (_, part) in
            part.viewDidAppear(animated)
        }
    }
    
    open func viewWillDisappear(_ animated: Bool) {
        lifeCycleRecord.record(.viewWillDisappear)
        parts.forEach { (_, part) in
            part.viewWillDisappear(animated)
        }
    }
    
    open func viewDidDisappear(_ animated: Bool) {
        lifeCycleRecord.record(.viewDidDisappear)
        parts.forEach { (_, part) in
            part.viewDidDisappear(animated)
        }
    }
}
