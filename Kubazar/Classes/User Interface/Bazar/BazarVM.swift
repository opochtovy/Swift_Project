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
    
    public func getEditorVM(forIndexPath indexPath: IndexPath) -> EditorVM {
     
        return EditorVM(client: self.client, haiku: self.dataSource[indexPath.row])
    }
    
    public func getHaikusFromNewHaikus(haikus: [Haiku]) {
        
        self.didEndReached = haikus.count < self.perPage
        self.dataSource.append(contentsOf: haikus)
    }
    
    public func getImagePathForHaiku(forIndexPath indexPath: IndexPath) -> String? {
        
        let haiku = self.dataSource[indexPath.row]
        return haiku.haikuImage?.urlString
    }
    
    public func deleteAllDataSource() {
        
        self.dataSource = []
    }
}
