//
//  ContactsManager.swift
//  Kubazar
//
//  Created by Mobexs on 11/27/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Contacts

enum ContactsError: Error {
    
    case accessDeclined
    case fetchException
}

class ContactsManager {
    
    typealias ContactsAccessCompletion = (_ success: Bool, _ error: Error?) -> Void
    typealias ContactsRequestCompletion = (_ success: Bool, _ error: Error?, _ contacts: [CNContact]) -> Void
    
    public static let shared: ContactsManager = ContactsManager()
    private var store = CNContactStore()
    
    public func requestAssess(completion: @escaping ContactsAccessCompletion) {
        
        self.store.requestAccess(for: .contacts) { (success, error) in
            
            if success {
                
                completion(true, nil)
            }
            else {
                
                completion(false, ContactsError.accessDeclined)
            }
        }
    }
    
    public func getAllContacts(completion: ContactsRequestCompletion) {
        
//        let containerID = self.store.defaultContainerIdentifier()
        
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]

        var allContainers: [CNContainer] = []
        do {
            
            allContainers = try self.store.containers(matching: nil)
        }
        catch {
            
            completion(false, ContactsError.fetchException, [])
        }
        
        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try self.store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                results.append(contentsOf: containerResults)
                
                completion(true, nil, results)
            }
            catch {
                
                completion(false, ContactsError.fetchException, [])
            }
        }
    }
}
