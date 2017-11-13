//
//  BazarDetailVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BazarDetailVM: BaseVM {

    enum DetailBazarMode {
        
        case solo
        case read
        case party
        case partyAuthor
    }
    
    private let haiku : Haiku
    public var mode : DetailBazarMode = .party
    
    public var dateText : String = ""
    public var isPublished : Bool = false
    public var isLiked: Bool = false
    
    private var userViewVMs : [UserViewVM] = []
    
    init(client: Client, haiku: Haiku) {
        
        self.haiku = haiku
        super.init(client: client)
        self.prepareModel()
    }
    
    //MARK: - Public functions
    public func getUserViewVM(forIndex index: Int) -> UserViewVM? {
        
        return self.userViewVMs[safe: index]
    }
    
    public func getPreviewVM() -> HaikuPreviewVM {
        
        return HaikuPreviewVM(withHaiku: self.haiku)
    }
    
    //MARK: - Private functions
    private func prepareModel() {
    
        self.dateText = "23 Min Ago" //TODO: add date stamp
        self.isPublished = self.haiku.published
        self.isLiked = self.haiku.liked
        
        self.userViewVMs = []
        
        for user in self.haiku.friends {
            self.userViewVMs.append(UserViewVM(withUser: user))
        }
    }
}
