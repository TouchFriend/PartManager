//
//  Conversation.swift
//  PartManager
//
//  Created by touchWorld on 2025/2/28.
//

import Foundation

public class Conversation {
    
    // TODO: - 加锁
    private var infos = NSMapTable<Part, Info>(keyOptions: .weakMemory,
                                               valueOptions: .strongMemory,
                                               capacity: 0)
    
    public init() {
        
    }
    
    public func addObserver(part: Part,
                            notificationName name: NotificationName,
                            cb block: @escaping NotificationBlock) {
        let info = getInfo(part)
        info.register(name: name, block: block)
    }
    
    public func removeObserver(part: Part) {
        infos.removeObject(forKey: part)
    }
    
    public func removeObserver(part: Part,
                               notificationName name: NotificationName) {
        let info = getInfo(part)
        info.unregister(name: name)
    }
    
    public func post(to part: Part,
                     notificationName name: NotificationName,
                     userInfo: Any?) {
        let info = getInfo(part)
        guard let cb = info.getNotificationBlock(name: name) else {
            return
        }
        cb(userInfo)
    }
    
    private func getInfo(_ part: Part) -> Info {
        if let info = infos.object(forKey: part) {
            return info
        }
        let info = Info()
        infos.setObject(info, forKey: part)
        return info
    }
    
}

extension Conversation {
    public typealias NotificationName = String
    public typealias NotificationBlock = (_ userInfo: Any?) -> Void
    
    public class Info {
        // TODO: - 加锁
        private var items: [NotificationName: NotificationBlock] = [:]
        
        public init() {
            
        }
        
        public func register(name: NotificationName, block: @escaping NotificationBlock) {
            items[name] = block
        }
        
        public func unregister(name: NotificationName) {
            items[name] = nil
        }
        
        public func getNotificationBlock(name: NotificationName) -> NotificationBlock? {
            items[name]
        }
        
    }
}
