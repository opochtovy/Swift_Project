//
//  Notification.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class KBNotification {
    
    public enum NotificationType {
        
        case publish
        case like
        case share
        case remember
    }
    
    public let user: User
    public let haiku: Haiku
    public let type: NotificationType
    public var readed: Bool = false
    public let date: Date
    
    init(haiku: Haiku, user: User, date: Date, type: NotificationType) {
        self.haiku = haiku
        self.user = user
        self.date = date
        self.type = type
    }
}
