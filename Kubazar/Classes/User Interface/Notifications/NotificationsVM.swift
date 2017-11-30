//
//  NotificationsVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class NotificationsVM: BaseVM {
    
    private var dataSource: [[KBNotification]] = []
    
    override init(client: Client) {
        super.init(client: client)
        self.prepareModel()
    }
    
    //MARK: - Public functions
    
    public func numberOfSections() -> Int {
        return self.dataSource.count
    }
    
    public func numberOfItems(forSection section: Int) -> Int {
        
        return self.dataSource[section].count
    }
    
    public func getNotificationCellVM(forIndexPath indexPath: IndexPath) -> NotificationCellVM {
        
        let notification = self.dataSource[indexPath.section][indexPath.row]
        return NotificationCellVM(withNotification: notification)
    }
    
    public func getSectionTitle(forSection section: Int) -> String {
        
        var result = ""
        let firstNotificationInSectionType = self.dataSource[safe: section]?[safe: 0]?.readed
       
        if let type = firstNotificationInSectionType {
            
            result = type == true ? NSLocalizedString("Notifications_earlier", comment: "") : NSLocalizedString("Notifications_new", comment: "")
        }
        return result
    }
    
    public func getReuseID(forIndexPath indexPath: IndexPath) -> String {
        
        let notification = self.dataSource[indexPath.section][indexPath.row]
        
        switch notification.type {
        case .like, .publish, .share: return NotificationCell.reuseID
        case .remember: return RememberCell.reuseID
        }
    }
    
    public func getBazarDetailVM(forIndexPath indexpath: IndexPath) -> BazarDetailVM{
        
        let notification = self.dataSource[indexpath.section][indexpath.row]
        return BazarDetailVM(client: self.client, haiku: notification.haiku)
    }
    //MARK: - Private functions
    private func prepareModel() {
        
        //-- mocked notifications
/*
        let haikus = HaikuManager.shared.haikus
        let haiku1 = haikus[0]
        let haiku2 = haikus[1]
        let haiku3 = haikus[2]
        let haiku4 = haikus[3]
        let haiku5 = haikus[4]
        
        let n1 = KBNotification(haiku: haiku1, user: haiku1.players[1], date: Date(), type: .like)
        let n2 = KBNotification(haiku: haiku2, user: haiku2.players[2], date: Date(), type: .publish)
        let n3 = KBNotification(haiku: haiku3, user: haiku3.players[1], date: Date(), type: .remember)
        let n4 = KBNotification(haiku: haiku4, user: haiku4.players[2], date: Date(), type: .share)
        let n5 = KBNotification(haiku: haiku5, user: haiku5.players[0], date: Date(), type: .like)
        
        n4.readed = true
        n5.readed = true
        
        let notifications = [n1, n2, n3, n4, n5]
*/
        let notifications: [KBNotification] = []
            
        self.dataSource = []
        
        //Sort by sections
        let newNotifications = notifications.filter({$0.readed == false})
        let oldNotifications = notifications.filter({$0.readed == true})
        
        if newNotifications.count > 0 {
            
            self.dataSource.append(newNotifications)
        }
        
        if oldNotifications.count > 0 {
            
            self.dataSource.append(oldNotifications)
        }
    }
    
}
