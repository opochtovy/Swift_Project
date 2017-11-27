//
//  FriendListVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class FriendListVM: BaseVM {
    
    enum Filter: Int {
        
        case kubazar = 0
        case all = 1
    }
    
    public var filter: Filter = .all
    private var users: [User] = []
    
    override init(client: Client) {
        super.init(client: client)
        self.prepareModel()
    }
    
    
    //MARK: - Public functions
    public func numberOfSections() -> Int {
        
        return 10 //mocked
    }
    
    public func numberOfItems(forSection: Int) -> Int {
        
        return self.users.count //mocked
    }
    
    public func titleForSection(section: Int) -> String {
        
        return "A" //mocked
    }
    
    public func getFriendListCellVM(forIndexPath indexPath: IndexPath) -> FriendListCellVM{
        
        return FriendListCellVM(withUser: self.users[indexPath.row], haikuCount: 2, showInvite: true)
    }
    
    public func getSectionIndexTitles() -> [String] {
        
        return ["A", "B", "C", "D"] //mocked
    }
    
    //MARK: - Private functions
    
    private func prepareModel() {
        //mocked content
        
        self.users = HaikuManager.shared.haikus.flatMap({$0.players})
    }
    
    private func requestContacts() {
        
        ContactsManager.shared.requestAssess { (success, error) in
            
            if success {
                
                ContactsManager.shared.getAllContacts(completion: { (success, error, contacts) in
                    
                    if success {
                        
                        print(contacts)
                    }
                })
            }
        }
    }
}
