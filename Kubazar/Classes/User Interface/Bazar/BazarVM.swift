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
        
        let haiku = self.numberOfItems() > 0 ? self.dataSource[indexPath.row] : Haiku()
        return BazarCellVM(client: self.client, haiku: haiku)
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
        
        for haiku in haikus {
            
            if !self.dataSource.contains(haiku) {
                
                self.dataSource.append(haiku)
            }
        }
        
        switch self.filter {
            
        case .all: self.allHaikus = self.dataSource
            
        case .mine: self.personalHaikus = self.dataSource
            
        case .active: self.activeHaikus = self.dataSource
            
        }
        
        print("BazarVM - getHaikusFromNewHaikus : self.dataSource.count =", self.dataSource.count)
    }
    
    public func updateDataSource(isSortButtonPressed: Bool) {
        
        switch self.filter {
            
        case .all: self.dataSource = self.allHaikus
            
        case .mine: self.dataSource = self.personalHaikus
        print("self.dataSource.count =", self.dataSource.count)
        print("self.personalHaikus.count =", self.personalHaikus.count)
            
        case .active: self.dataSource = self.activeHaikus
            
        }
        
        if isSortButtonPressed && !self.didEndReached {
            
            self.dataSource = []
        }
        
        switch self.sort {
            
        case .date: self.dataSource = self.dataSource.sorted(by: { $0.finishDate > $1.finishDate })
        case .likes: self.dataSource = self.dataSource.sorted(by: { $0.likesCount > $1.likesCount })
        }
        
        print("BazarVM - updateDataSource : self.dataSource.count =", self.dataSource.count)
    }
    
    public func deleteHaiku(haiku: Haiku) {
        
        switch self.filter {
            
        case .mine:
            self.dataSource.remove(object: haiku)
            self.personalHaikus.remove(object: haiku)
            
        default: self.personalHaikus.remove(object: haiku)
            
        }
        
        print("BazarVM - deleteHaiku : self.dataSource.count =", self.dataSource.count)
    }
}
