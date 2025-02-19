//
//  PartConfig.swift
//  PartManager
//
//  Created by touchWorld on 2025/2/19.
//

import Foundation
import UIKit

open class PartConfig {
    
    public weak var viewController: UIViewController?
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
