//
//  FriendsBaseVM.swift
//  Kubazar
//
//  Created by Mobexs on 12/1/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import PromiseKit

/** FriendsBaseVM is responsable for fetching user contacts and friends */

class FriendsBaseVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
        self.prepareModel()
    }
    
    /** override prepareModel to set child viewModel data */
    internal func prepareModel() {
        
    }
    
    public func getContacts(completion: @escaping BaseCompletion) {
        
        ContactsManager.shared.requestAccessSmart().then { _ -> Promise<Void> in
         
            return ContactsManager.shared.getAllContactsSmart()
            
        }.then { _ -> Promise<[User]> in
                
            let phones = ContactsManager.shared.userContacts.flatMap({$0.phones})
            return self.client.authenticator.fetchFriends(phones: phones)
                
        }.then { users -> Void in
            
            HaikuManager.shared.friends = users
            self.filterUserContacts()
            self.prepareModel()
            completion(true, nil)
            
        }.catch { error in
            
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
