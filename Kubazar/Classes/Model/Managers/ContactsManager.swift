//
//  ContactsManager.swift
//  Kubazar
//
//  Created by Mobexs on 11/27/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Contacts
import PromiseKit

enum ContactsError: Error {
    
    case accessDeclined
    case fetchException
}

class ContactsManager {
    
    typealias ContactsAccessCompletion = (_ success: Bool, _ error: Error?) -> Void
    typealias ContactsRequestCompletion = (_ success: Bool, _ error: Error?, _ contacts: [ContactUser]) -> Void
    
    public static let shared: ContactsManager = ContactsManager()
    private var store = CNContactStore()
    public var userContacts: [ContactUser] = []
    
    public func requestAccessSmart() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            switch CNContactStore.authorizationStatus(for: .contacts) {
                
            case .authorized:           fulfill(())
            case .denied, .restricted:  reject(ContactsError.accessDeclined)
            case .notDetermined:
                
                self.store.requestAccess(for: .contacts) { (success, error) in
                    
                    if success {
                        
                        fulfill(())
                    }
                    else {
                        
                        reject(ContactsError.accessDeclined)
                    }
                }
            }
        }
    }
    
    public func getAllContactsSmart() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactImageDataKey,
                CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
            
            var allContainers: [CNContainer] = []
            do {
                
                allContainers = try self.store.containers(matching: nil)
            }
            catch {
                
                reject(ContactsError.fetchException)
            }
            
            var results: [CNContact] = []
            
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try self.store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                    results.append(contentsOf: containerResults)
                    let filteredContacts = self.filterContactsByPhoneNumber(contacts: results)
                    
                    let contactUsers = filteredContacts.map({ (contact) -> ContactUser in
                        ContactUser(withContact: contact)
                    })
                    
                    self.userContacts = contactUsers
                    
                    fulfill(())
                }
                catch {
                    
                    reject(ContactsError.fetchException)
                }
            }
        }
    }
    
    /** filter contacts. Cantacts without phone number excluded */
    private func filterContactsByPhoneNumber(contacts: [CNContact]) ->  [CNContact] {
        
        let result = contacts.filter { (contact) -> Bool in
            
            contact.phoneNumbers.count > 0
        }
        
        return result
    }
}
