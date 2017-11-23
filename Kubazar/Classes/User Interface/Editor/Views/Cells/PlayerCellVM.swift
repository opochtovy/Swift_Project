//
//  PlayerCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum PlayerStatus {
    
    case waiting
    case done
    case inProgress
    
    var writeText: String {
        
        switch self {
        case .waiting:      return NSLocalizedString("PlayerCell_writes", comment: "")
        case .done:         return NSLocalizedString("PlayerCell_wrote", comment: "")
        case .inProgress:   return NSLocalizedString("PlayerCell_write", comment: "")
        }
    }
}

class PlayerCellVM {
    
    public var status: PlayerStatus = .waiting
    public var userURL: URL?
    public var statusText = ""
    
    init(withPlayer player: User, status: PlayerStatus, syllablesCount: Int) {
        
        if let url: URL = URL(string: player.avatarURL ?? "") {
            
            self.userURL = url
        }
        
        self.status = status
        self.statusText = "\(player.firstName) \(self.status.writeText) \(syllablesCount) \(NSLocalizedString("PlayerCell_syllables", comment: ""))"        
    }
}
