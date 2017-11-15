//
//  StartPhoneVerificationVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class StartPhoneVerificationVM: BaseVM {
    
    private var codeName: String = ""
    private var numberToSend: String = ""
    
    override init(client: Client) {
        super.init(client: client)
    }
    
    //MARK: - Public functions
    
    public func setCountryCode(code: String) {
        
        self.codeName = code
    }
    
    public func getCountryCode() -> String {
        
        return self.codeName
    }
}
