//
//  BazarVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import PromiseKit

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
        
        return BazarDetailVM(client: self.client, haiku: self.dataSource[indexPath.row], filter: self.filter.rawValue)
    }
    
    public func getEditorVM(forIndexPath indexPath: IndexPath) -> EditorVM {
     
        return EditorVM(client: self.client, haiku: self.dataSource[indexPath.row])
    }
    
    public func getHaikusFromNewHaikus(newHaikus: [Haiku], shouldResetDataSource: Bool) {
        
        self.didEndReached = newHaikus.count < self.perPage
        
        if shouldResetDataSource {
            
            self.dataSource = newHaikus
            
        } else {
            
            for haiku in newHaikus {
                
                if !self.dataSource.contains(haiku) {
                    
                    self.dataSource.append(haiku)
                }
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
            
        case .active:
            self.dataSource = self.activeHaikus
            self.sort = .date
        }
        
        if isSortButtonPressed && !self.didEndReached {
            
            self.dataSource = []
        }
        
        switch self.sort {
            
        case .date:
            if self.filter == .active {
                self.dataSource = self.dataSource.sorted(by: { $0.createDate > $1.createDate })
            } else {
                self.dataSource = self.dataSource.sorted(by: { $0.finishDate > $1.finishDate })
            }
        case .likes:
            if self.filter != .active {
                
                self.dataSource = self.dataSource.sorted(by: { $0.likesCount > $1.likesCount })
            }
        }
        
        print("BazarVM - updateDataSource : self.dataSource.count =", self.dataSource.count)
    }
    
    public func deleteHaiku(haiku: Haiku) {
        
        self.dataSource.remove(object: haiku)
        self.allHaikus.remove(object: haiku)
        self.personalHaikus.remove(object: haiku)
        
        print("BazarVM - deleteHaiku : self.dataSource.count =", self.dataSource.count)
    }
    
    public func unpublishHaiku(haiku: Haiku) {
        
        self.dataSource.remove(object: haiku)
        self.allHaikus.remove(object: haiku)
    }
 
    public func reauthenticateUser(completionHandler:@escaping ([Haiku], Bool) -> ()) {
        
        self.client.authenticator.reauthenticateUser().then { () -> Promise<Void> in
            
            return self.client.authenticator.getToken()
            
            }.then { () -> Promise<[Haiku]> in
                
                let sortType = self.sort == .date ? 0 : 1
                return self.client.authenticator.getHaikusPromise(page: self.page, perPage: self.perPage, sort: sortType, filter: self.filter.rawValue)
                
            }.then { haikus -> Void in
                
                completionHandler(haikus, true)
            
            }.catch { error in
                
                completionHandler([], false)
        }
        
        print("BazarVM - deleteHaiku : self.dataSource.count =", self.dataSource.count)
    }
    
    public func checkStateOfCurrentUser() -> Bool {
        
        return self.client.authenticator.checkStateOfCurrentUser()
    }
    
    public func signOut() {
        
        self.client.authenticator.signOut { (errorDescription, success) in
            
            self.client.authenticator.state = .unauthorized
            UserDefaults.standard.set(false, forKey: StoreKeys.isUserAuthorized)
            UserDefaults.standard.synchronize()
            self.client.authenticator.authToken = ""
            self.client.authenticator.sessionManager.adapter = nil
            HaikuManager.shared.currentUser = User()
            
            if let authToken = self.client.authenticator.authToken, authToken.count > 0 {
                
                print("BazarVM : authToken =", authToken)
                print("Error")
            }
        }
    }
}
