//
//  UserThumbnailVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class UserThumbnailVM {
    
    private(set) var userImageURL: URL?
    private(set) var userImageData: Data?
    private(set) var userInitials: String = ""
    private(set) var needBorders: Bool = false
    
    
    init(withUser user: UserProtocol, needBorders: Bool = false) {
        
        self.needBorders = needBorders
        
        if let url = URL(string: user.avatarURL ?? ""){
            
            userImageURL = url
        }
        
        userImageData = user.avatarImageData
        
        if let firstChar = user.firstName.first {
            
            userInitials.append(firstChar)
        }
        
        if let secondchar = user.lastName.first {
            
            userInitials.append(secondchar)
        }
    }
}
