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
    
    enum BazarSort: Int { //Tested
        
        case latest
        case author
    }
    
    public var filter: BazarFilter = .all
    
    private var cellViewModels: [BazarCellVM] = []
    //MARK: -
    
    override init(client: Client) {
        super.init(client: client)
        self.prepareVMs()
    }
    
    //MARK: - Public functions
    public func numberOfItems() -> Int {
        
        return self.cellViewModels.count
    }
    
    public func getCellVM(forIndexPath indexPath: IndexPath) -> BazarCellVM {
        
        return self.cellViewModels[indexPath.row]
    }
    
    //MARK: - Private functions
    
    private func prepareVMs() {
        
        //TESTED start
        
        let vm1 = BazarCellVM()
        let vm2 = BazarCellVM()
        let vm3 = BazarCellVM()
        let vm4 = BazarCellVM()
        let vm5 = BazarCellVM()
        let vm6 = BazarCellVM()
        
        self.cellViewModels = [vm1, vm2, vm3, vm4, vm5, vm6]
        
        //TESTED end
    }
}
