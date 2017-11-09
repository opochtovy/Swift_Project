//
//  BazarCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation


class BazarCellVM {
    
    private(set) var authorName: String = ""
    private(set) var participants: String = ""
    private(set) var dateInfo: String = ""
    private(set) var authorPictureURL: String?
    private(set) var haikuPictureURL: String?
    
    private(set) var btnText: String = "Likes"
    
    init() {
        self.prepareData()
    }
    
    private func prepareData() {
        
        //map object data to string data
        authorName = "Serge Rylko"
        participants = "Bear and Vodka"
        dateInfo = "23 min ago".uppercased()
        authorPictureURL = nil
        haikuPictureURL = nil
        btnText = "123 \(NSLocalizedString("Bazar_likes", comment: ""))"
    }
}
