//
//  PlayerCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum PlayerStatus {
    
    case none
    case done
    case inProgress
    
    func getWriteText(isMyself: Bool) -> String {
        
        var result = ""
        switch self {
        
        case .done:          result = NSLocalizedString("PlayerCell_wrote", comment: "")
        case .inProgress, .none:
            
            if isMyself {
                
                result = NSLocalizedString("PlayerCell_write", comment: "")
            }
            else {
                result = NSLocalizedString("PlayerCell_writes", comment: "")
            }
        }
        
        return result
    }
}

class PlayerCellVM {
    
    public var status: PlayerStatus = .none
    public var userURL: URL?
    public var statusText = ""
    private let player: User
    
    init(withPlayer player: User, status: PlayerStatus, syllablesCount: Int, isCurrentUserField: Bool = false) {
        
        self.player = player
        if let url: URL = URL(string: player.avatarURL ?? "") {
            
            self.userURL = url
        }
        
        self.status = status

        let playerName = isCurrentUserField ? NSLocalizedString("PlayerCell_you", comment: "") : player.firstName
        let writeText = self.status.getWriteText(isMyself: isCurrentUserField)
        self.statusText = "\(playerName) \(writeText) \(syllablesCount) \(NSLocalizedString("PlayerCell_syllables", comment: ""))"
    }
    
    public func getThumbnailVM() -> UserThumbnailVM {
        
        return UserThumbnailVM(withUser: self.player)
    }
}
