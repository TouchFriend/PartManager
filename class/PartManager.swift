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
    
    /// 注册的模块
    public private(set) var parts: [PartType: Part] = [:]
    
    public private(set) var config: PartConfig
    
    public init(config: PartConfig) {
        self.config = config
        registerDirectPart()
    }
    
    deinit {

    }
    
    
}

extension PartManager {
    
    private func registerDirectPart() {
        for (partType, partClass) in directParts {
            registerPart(partType, partClass: partClass)
        }
    }
    
    public func registerPart(_ partType: PartType, partClass: Part.Type) {
        let part = partClass.init(partManager: self, config: config)
        if parts.keys.contains(partType) {
            DLog("duplicate register,type:\(partType),old:\(type(of: parts[partType]!)),new:\(type(of: part))")
        }
        parts[partType] = part
    }
    
    public func unRegisterPart(_ partType: PartType) {
        parts[partType] = nil
    }
}

extension PartManager {
    
    public var viewController: UIViewController? {
        config.viewController
    }
}


/// ViewController生命周期
@objc extension PartManager {
    
    open func initVC() {
        parts.forEach { (_, part) in
            part.initVC()
        }
    }
    
    open func viewDidLoad() {
        parts.forEach { (_, part) in
            part.viewDidLoad()
        }
    }
    
    open func viewWillLayoutSubviews() {
        parts.forEach { (_, part) in
            part.viewWillLayoutSubviews()
        }
    }
    
    open func viewDidLayoutSubviews() {
        parts.forEach { (_, part) in
            part.viewDidLayoutSubviews()
        }
    }
    
    open func viewWillAppear(_ animated: Bool) {
        parts.forEach { (_, part) in
            part.viewWillAppear(animated)
        }
    }
    
    open func viewDidAppear(_ animated: Bool) {
        parts.forEach { (_, part) in
            part.viewDidAppear(animated)
        }
    }
    
    open func viewWillDisappear(_ animated: Bool) {
        parts.forEach { (_, part) in
            part.viewWillDisappear(animated)
        }
    }
    
    open func viewDidDisappear(_ animated: Bool) {
        parts.forEach { (_, part) in
            part.viewDidDisappear(animated)
        }
    }
}
