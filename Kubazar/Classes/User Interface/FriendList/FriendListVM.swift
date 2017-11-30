//
//  FriendListVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import PromiseKit

class FriendListVM: BaseVM {
    
    enum Filter: Int {
        
        case kubazar = 0
        case all = 1
    }
    
    public var filter: Filter = .all
    public var searchFilter: String = ""
    private var users: [User] = []
    private var contactUsers: [ContactUser] = []
    
    private var dataSourceSectionKeys: [String] = []
    private var dataSource: [String: [UserProtocol]] = [:]
    
    override init(client: Client) {
        super.init(client: client)
        self.prepareModel()
    }
    
    
    //MARK: - Public functions
    public func numberOfSections() -> Int {
        
        return self.dataSourceSectionKeys.count
    }
    
    public func numberOfItems(forSection section: Int) -> Int {
        
        return self.dataSource[self.dataSourceSectionKeys[section]]?.count ?? 0
    }
    
    public func titleForSection(section: Int) -> String {
        
        return self.dataSourceSectionKeys[section]
    }
    
    public func getFriendListCellVM(forIndexPath indexPath: IndexPath) -> FriendListCellVM{
        
        let sectionKey = self.dataSourceSectionKeys[indexPath.section]
        let user = self.dataSource[sectionKey]![indexPath.row]
        
        var toInvite = false
        var haikusCount = 0
        switch user {
        case is User:
            toInvite = false
            haikusCount = (user as! User).haikusCount
        case is ContactUser:
            toInvite = true
        default: break
        }
        
        return FriendListCellVM(withUser: user, haikuCount: haikusCount, showInvite: toInvite)
    }
    
    public func getSectionIndexTitles() -> [String] {
        
        return self.dataSourceSectionKeys
    }
    
    public func requestContacts(completion: @escaping BaseCompletion) {
        
        ContactsManager.shared.requestAssess { (success, error) in
            
            if success {
                
                ContactsManager.shared.getAllContacts(completion: { (success, error, contacts) in
                    
                    if success {
                        
                        //Set dataSource
                        self.contactUsers = contacts
                        
                        self.getFriend(completion: { (success, error) in
                            
                            if success {
                                
                                self.prepareModel()
                                completion(true, nil)
                            }
                            else {
                                
                                completion(false, error)
                            }
                        })
                    }
                    else {
                        
                        completion(false, error)
                    }
                })
            }
        }
    }
    
    public func getFriend(completion: @escaping BaseCompletion) {
        
        let phones = self.contactUsers.flatMap({$0.phones})
        self.client.authenticator.fetchFriends(phones: phones).then { users -> Void in
            
            HaikuManager.shared.friends = users
            self.filterUserContacts()
            completion(true, nil)
        
        }.catch { (error) in
            
            completion(false, error)
        }
    }
    
    public func getFrieldDetailVM(forIndexPath indexPath: IndexPath) -> FriendDetailVM? {
        
        let sectionKey = self.dataSourceSectionKeys[indexPath.section]
        
        if let user = self.dataSource[sectionKey]?[indexPath.row] as? User {
            
            return FriendDetailVM(client: self.client, user: user)
        }
        else {
            
            return nil
        }
    }
    
    public func prepareModel() {
        
        //mocked users
        let usersSet = Set(HaikuManager.shared.friends)
        self.users = Array(usersSet)
        
        var resultUsers: [UserProtocol] = []
        
        switch self.filter {
            
        case .kubazar:
            
            resultUsers = self.users
            
        case .all:
            
            resultUsers = self.users
            resultUsers += self.contactUsers as [UserProtocol]
            
            resultUsers.sort(by: { (user1, user2) -> Bool in
                user1.firstName < user2.firstName
            })
        }
        
        if self.searchFilter.count > 0 {
            
            resultUsers = resultUsers.filter({$0.firstName.contains(self.searchFilter) ||
                $0.lastName.contains(self.searchFilter)})
        }
        
        let firstNameKeyPath = \UserProtocol.firstName
        
        let sortedUsers = Dictionary.init(grouping: resultUsers) {
            
            $0[keyPath: firstNameKeyPath].prefix(1).uppercased()
        }
        
        self.dataSourceSectionKeys = Array(sortedUsers.keys).sorted(by: {$0 < $1}) // add sort
        self.dataSource = sortedUsers
    }
    
    //MARK: - Private functions
    
    /** Exlude contact user that is in users*/
    private func filterUserContacts() {
        
        let truncatedPhones = HaikuManager.shared.friends.map { (user) -> String in
            
            return user.phoneNumber.replacingOccurrences(of: "[-() +]", with: "", options: [.regularExpression])
        }

        self.contactUsers = self.contactUsers.filter { (contactUser) -> Bool in
            
            var result: Bool = true
            
            for phone in contactUser.phones {
                
                let trimmedPhone = phone.replacingOccurrences(of: "[^0-9]", with: "", options: [.regularExpression])
                if truncatedPhones.contains(trimmedPhone) {
                    
                    result = false
                }
            }
            
            return result
        }
        
    }
}
