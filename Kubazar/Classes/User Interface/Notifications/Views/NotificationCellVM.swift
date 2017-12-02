//
//  NotificationCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation


class NotificationCellVM {

    private(set) var userImageURL: URL?
    private(set) var haikuImageURL: URL?
    private(set) var notificationText: String = ""
    private(set) var dateText: String = ""
    
    private let notification: KBNotification
    
    init(withNotification notification: KBNotification) {
        self.notification = notification
        
        if let url = URL(string: notification.user.avatarURL ?? "") {
            userImageURL = url
        }
        if let url = URL(string: notification.haiku.pictureURL ?? "") {
            haikuImageURL = url
        }
        
        var noteText = "\(notification.user.fullName) "
        switch notification.type {
        case .like:     noteText.append(NSLocalizedString("Notifications_liked", comment: ""))
        case .publish:  noteText.append(NSLocalizedString("Notifications_published", comment: ""))
        case .share:    noteText.append(NSLocalizedString("Notifications_shared", comment: ""))
        case .remember: noteText = ""
        case .nextTurn: noteText = NSLocalizedString("Notifications_nextTurn", comment: "")
        }
        
        self.notificationText = noteText
        
        let df = DateFormatter()
        df.dateFormat = "EEEE"
//        self.dateText = df.string(from: notification.date)
        self.dateText = notification.createdOn.convertToDate()
    }
    
}
