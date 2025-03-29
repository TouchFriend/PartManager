//
//  LifeCycleRecord.swift
//  PartManager
//
//  Created by touchWorld on 2025/3/12.
//

import Foundation

public struct LifeCycle: OptionSet {
    public let rawValue: Int
    
    public static let initVC = LifeCycle(rawValue: 1 << 0)
    public static let viewDidLoad = LifeCycle(rawValue: 1 << 1)
    public static let viewWillAppear = LifeCycle(rawValue: 1 << 2)
    public static let viewWillLayoutSubviews = LifeCycle(rawValue: 1 << 3)
    public static let viewDidLayoutSubviews = LifeCycle(rawValue: 1 << 4)
    public static let viewDidAppear = LifeCycle(rawValue: 1 << 5)
    public static let viewWillDisappear = LifeCycle(rawValue: 1 << 6)
    public static let viewDidDisappear = LifeCycle(rawValue: 1 << 7)
    
    public static let none = LifeCycle([])
    public static let all: [LifeCycle] = [.initVC, .viewDidLoad, viewWillAppear,
                                          viewWillLayoutSubviews, viewDidLayoutSubviews,
                                          viewDidAppear, viewWillDisappear, viewDidDisappear]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    
    
}

extension LifeCycle: CustomStringConvertible {
    
    public var simpleDescription: String {
        switch self {
        case .initVC:
            return "initVC"
        case .viewDidLoad:
            return "viewDidLoad"
        case .viewWillAppear:
            return "viewWillAppear"
        case .viewWillLayoutSubviews:
            return "viewWillLayoutSubviews"
        case .viewDidLayoutSubviews:
            return "viewDidLayoutSubviews"
        case .viewDidAppear:
            return "viewDidAppear"
        case .viewWillDisappear:
            return "viewWillDisappear"
        case .viewDidDisappear:
            return "viewDidDisappear"
        default:
            return "unknown,rawValue:\(self.rawValue)"
        }
    }
    
    public var combieDescription: String {
        var cycles = self
        var desArr: [String] = []
        for cycle in Self.all {
            if cycles.contains(cycle) {
                cycles.remove(cycle)
                desArr.append(cycle.simpleDescription)
            }
        }
        if cycles != .none {
            desArr.append(cycles.simpleDescription)
        }
        return desArr.description
    }
    
    public var description: String {
        return "\(type(of: self))(rawValue:\(rawValue),arr:\(combieDescription))"
    }
    
    
}

 
public class LifeCycleRecord {
    // TODO: - 线程安全
    private var cycles: LifeCycle = []
    
    public init() {
        
    }
    
    public func record(_ cycle: LifeCycle) {
        cycles.insert(cycle)
        if cycle == .viewWillAppear {
            cycles.remove([.viewDidAppear, .viewWillDisappear, .viewDidDisappear])
        } else if cycle == .viewDidAppear {
            cycles.remove([.viewWillDisappear, .viewDidDisappear])
        } else if cycle == .viewWillDisappear {
            cycles.remove([.viewDidDisappear])
        }
//        DLog("\(#function),cycle:\(cycle),cycles:\(cycles)")
    }
    
    public func restore(_ part: Part) {
        guard cycles != .none else { return }
        for cycle in LifeCycle.all {
            if cycles.contains(cycle) {
                executeCycle(part, cycle: cycle)
            }
        }
    }
    
    private func executeCycle(_ part: Part, cycle: LifeCycle) {
//        DLog("\(#function),part:\(part),cycle:\(cycle)")
        switch cycle {
        case .initVC:
            part.initVC()
        case .viewDidLoad:
            part.viewDidLoad()
        case .viewWillAppear:
            part.viewWillAppear(true)
        case .viewWillLayoutSubviews:
            part.viewWillLayoutSubviews()
        case .viewDidLayoutSubviews:
            part.viewDidLayoutSubviews()
        case .viewDidAppear:
            part.viewDidAppear(true)
        case .viewWillDisappear:
            part.viewWillDisappear(true)
        case .viewDidDisappear:
            part.viewDidDisappear(true)
        default:
            DLog("unknown,rawValue:\(cycle.rawValue)")
        }
    }
    
}
