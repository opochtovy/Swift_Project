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
    
    enum BazarSort: Int {
        
        case date = 0
        case likes = 1
    }
    
    public var filter: BazarFilter = .all {
        didSet {
            self.updateData()
        }
    }
    public var sort: BazarSort = .date
    
    private var dataSource: [Haiku] = []
    
    //MARK: - init
    
    override init(client: Client) {
        super.init(client: client)
        self.updateData()
    }
    
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
    
    //MARK: - Private functions
    private func updateData() {
        
        switch self.filter {
        case .all:
            
            self.dataSource = HaikuManager.shared.haikus.filter({ (haiku) -> Bool in
                haiku.published == true
            })
            
        case .active:
            
            self.dataSource = HaikuManager.shared.haikus.filter({ (haiku) -> Bool in
                
                haiku.participants.contains(where: { (user) -> Bool in
                    return user.id == 1 //-- Mocked
                })
            })
            
        case .mine:
            
            self.dataSource = HaikuManager.shared.haikus.filter({ (haiku) -> Bool in
                haiku.creator?.id == 1 //-- Mocked
            })
        }
    }
}
