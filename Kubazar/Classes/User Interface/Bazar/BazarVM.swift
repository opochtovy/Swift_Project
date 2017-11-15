//
//  BazarVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BazarVM: BaseVM {
    
    enum BazarFilter: Int {
        
        case all = 0
        case mine = 1
        case active = 2
    }
    
    enum BazarSort {
        
        case date
        case likes
    }
    
    public var filter: BazarFilter = .all
    public var sort: BazarSort = .date
    
    private var dataSource: [Haiku] = []
    
    //MARK: - Public functions
    public func numberOfItems() -> Int {
        
        return self.dataSource.count
    }
    
    public func getCellVM(forIndexPath indexPath: IndexPath) -> BazarCellVM {
        
        return BazarCellVM(haiku: self.dataSource[indexPath.row])
    }
    
    public func getDetailVM(forIndexPath indexPath: IndexPath) -> BazarDetailVM {
        
        return BazarDetailVM(client: self.client, haiku: self.dataSource[indexPath.row])
    }    

    public func refreshData() {
        
        switch self.filter {
        case .all:
            
            self.dataSource = HaikuManager.shared.haikus.filter({ (haiku) -> Bool in
                haiku.published == true
            })
            
        case .active:
            
            self.dataSource = HaikuManager.shared.haikus.filter({ (haiku) -> Bool in
                
                let isHaikuIncompleted: Bool = haiku.fields.count < 3
                let isUserParticipant: Bool = haiku.players.contains(where: { (user) -> Bool in
                    return user.id == HaikuManager.shared.currentUser.id
                })
                
                return isUserParticipant && isHaikuIncompleted
            })
            
        case .mine:
            
            self.dataSource = HaikuManager.shared.haikus.filter({ (haiku) -> Bool in
                
                let isUserCreator = haiku.creator?.id == HaikuManager.shared.currentUser.id
                let isUserActiveParticipant = haiku.activePlayers.contains(where: { (user) -> Bool in
                    return user.id == HaikuManager.shared.currentUser.id
                })
                
                return isUserCreator && isUserActiveParticipant && haiku.isCompleted
            })
        }
    }
}
