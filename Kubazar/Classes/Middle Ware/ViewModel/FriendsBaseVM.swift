//
//  FriendsBaseVM.swift
//  Kubazar
//
//  Created by Mobexs on 12/1/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

/** FriendsBaseVM is responsable for fetching user contacts and friends */

class FriendsBaseVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
        self.prepareModel()
    }
    
    /** override prepareModel to set viewModel data */
    internal func prepareModel() {
        
    }
    
    public func getContacts(completion: @escaping BaseCompletion) {
        
        ContactsManager.shared.requestAssess { (success, error) in
            
            if success {
                
                ContactsManager.shared.getAllContacts(completion: { (success, error) in
                    
                    if success {
                        
                        self.getFriends(completion: { (success, error) in
                            
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
    
    private func getFriends(completion: @escaping BaseCompletion) {
        
        let phones = ContactsManager.shared.userContacts.flatMap({$0.phones})
        self.client.authenticator.fetchFriends(phones: phones).then { users -> Void in
            
            HaikuManager.shared.friends = users
            self.filterUserContacts()
            completion(true, nil)
            
            }.catch { (error) in
                
                completion(false, error)
        }
    }
    
    /** Exlude contact user that is in users*/
    private func filterUserContacts() {
        
        let truncatedPhones = HaikuManager.shared.friends.map { (user) -> String in
            
            return user.phoneNumber.replacingOccurrences(of: "[-() +]", with: "", options: [.regularExpression])
        }
        
        ContactsManager.shared.userContacts = ContactsManager.shared.userContacts.filter { (contactUser) -> Bool in
            
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
