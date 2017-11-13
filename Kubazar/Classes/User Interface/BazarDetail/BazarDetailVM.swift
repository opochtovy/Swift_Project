//
//  BazarDetailVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BazarDetailVM: BaseVM {

    private let haiku : Haiku
    
    public var dateText : String = ""
    public var haikuImageURL : URL?
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
        self.haikuImageURL = URL(string: self.haiku.pictureURL ?? "")
        
        self.userViewVMs = []
        
        for user in self.haiku.participants {
            self.userViewVMs.append(UserViewVM(withUser: user))
        }
    }
}
