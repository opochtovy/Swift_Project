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
    
    //For Pagination
    public var isDataLoading: Bool = false
    public var page: Int = 0
    public var perPage: Int = 5
    public var didEndReached: Bool = false
    
    private var dataSource: [Haiku] = []
    private var allHaikus: [Haiku] = []
    private var personalHaikus: [Haiku] = []
    private var activeHaikus: [Haiku] = []
    
    //MARK: - Public functions
    public func numberOfItems() -> Int {
        
        return self.dataSource.count
    }
    
    public func getCellVM(forIndexPath indexPath: IndexPath) -> BazarCellVM {
        
        return BazarCellVM(client: self.client, haiku: self.dataSource[indexPath.row])
    }
    
    public func getDetailVM(forIndexPath indexPath: IndexPath) -> BazarDetailVM {
        
        return BazarDetailVM(client: self.client, haiku: self.dataSource[indexPath.row])
    }
    
    public func getEditorVM(forIndexPath indexPath: IndexPath) -> EditorVM {
     
        return EditorVM(client: self.client, haiku: self.dataSource[indexPath.row])
    }
    
    public func getHaikusFromNewHaikus(newHaikus: [Haiku], owners: [User]) {
        
        let haikus = HaikuManager.shared.addNewHaikus(newHaikus: newHaikus, haikusType: 0, owners: owners)
        
        self.didEndReached = haikus.count < self.perPage
        self.dataSource.append(contentsOf: haikus)
        
        switch self.filter {
            
        case .all: self.allHaikus = self.dataSource
            
        case .mine: self.personalHaikus = self.dataSource
            
        case .active: self.activeHaikus = self.dataSource
            
        }
        
        print("BazarVM - getHaikusFromNewHaikus : self.dataSource =", self.dataSource)
    }
    
    public func getImagePathForHaiku(forIndexPath indexPath: IndexPath) -> String? {
        
        let haiku = self.dataSource[indexPath.row]
        return haiku.haikuImage?.urlString
    }
    
    public func updateDataSource() {
        
        switch self.filter {
            
        case .all: self.dataSource = self.allHaikus
            
        case .mine: self.dataSource = self.personalHaikus
            
        case .active: self.dataSource = self.activeHaikus
            
        }
        
        switch self.sort {
            
        case .date: self.dataSource = self.dataSource.sorted(by: { $0.finishDate > $1.finishDate })
        case .likes: self.dataSource = self.dataSource.sorted(by: { $0.likesCount > $1.likesCount })
        }
        
        print("BazarVM - updateDataSource : self.dataSource =", self.dataSource)
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
    
    public func deleteHaiku(haiku: Haiku) {
        
        self.dataSource.remove(object: haiku)
        
        switch self.filter {
            
        case .all: self.allHaikus = self.dataSource
            
        case .mine: self.personalHaikus = self.dataSource
            
        case .active: self.activeHaikus = self.dataSource
            
        }
        
        print("BazarVM - deleteHaiku : self.dataSource =", self.dataSource)
    }
}
