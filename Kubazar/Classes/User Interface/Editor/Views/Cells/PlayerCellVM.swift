//
//  PlayerCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class PlayerCellVM {
    
    enum Status {
        
        case waiting
        case done
        case inProgress
        
        var writeText: String {
            
            switch self {
            case .waiting:      return "writes"
            case .done:         return "wrote"
            case .inProgress:   return "write"
            }
        }
    }
    
    public var status: Status = .waiting
    public var userURL: URL?
    public var statusText = ""
    
    init(withField field: Field) {
        
        if let url: URL = URL(string: field.owner.avatarURL ?? "") {
            
            self.userURL = url
        }
        
        self.status = .waiting
        
        let statusText = "\(field.owner.firstName) \(self.status.writeText)"
        
    }
}
