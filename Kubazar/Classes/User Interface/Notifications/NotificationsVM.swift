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
    public var page: Int = 0
    public var perPage: Int = 10
    
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
        
        var result = NSLocalizedString("Notifications_new", comment: "")
        if let first = self.dataSource[safe: section]?[safe: 0], first.createdOn.isOlderThanOneDay() {
            
            result = NSLocalizedString("Notifications_earlier", comment: "")
        }
        return result
    }
    
    public func getReuseID(forIndexPath indexPath: IndexPath) -> String {
        
        let notification = self.dataSource[indexPath.section][indexPath.row]
        
        switch notification.type {
        case .like, .publish, .share, .nextTurn: return NotificationCell.reuseID
        case .remember: return RememberCell.reuseID
        }
    }
    
    public func getBazarDetailVM(forIndexPath indexpath: IndexPath) -> BazarDetailVM{
        
        let notification = self.dataSource[indexpath.section][indexpath.row]
        return BazarDetailVM(client: self.client, haiku: notification.haiku, filter: 0)
    }
    
    public func getNotifications(completion: @escaping BaseCompletion) {
        
        self.client.authenticator.fetchNotifications(page: self.page, perPage: self.perPage).then { notifications -> Void in
            
            HaikuManager.shared.notifications = notifications
            self.prepareModel()
            completion(true, nil)
            
            }.catch { error in
                
                completion(false, error)
        }
    }
    
    //MARK: - Private functions
    private func prepareModel() {
        
        let notifications: [KBNotification] = HaikuManager.shared.notifications
            
        self.dataSource = []
        
        //Sort by sections
        let newNotifications = notifications.filter { (notification) -> Bool in
            !notification.createdOn.isOlderThanOneDay()
        }
        let oldNotifications = notifications.filter { (notification) -> Bool in
            notification.createdOn.isOlderThanOneDay()
        }
        
        if newNotifications.count > 0 {
            
            self.dataSource.append(newNotifications)
        }
        
        if oldNotifications.count > 0 {
            
            self.dataSource.append(oldNotifications)
        }
    }
    
}
