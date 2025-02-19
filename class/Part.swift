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

extension Part {
    
    public var viewController: UIViewController? {
        config.viewController
    }
}
