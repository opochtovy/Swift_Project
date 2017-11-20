//
//  EditorVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class EditorVM: BaseVM {

    enum EditingScope {
        /** Creator setup fonts, colors etc. Input first field is available*/
        case creatorSetup
        
        /** Player input field */
        case playerInput
    }
    
    var fields: [String] = []
    public var scope: EditingScope = .creatorSetup
    private let haiku: Haiku
    
    public var nextActionEnabled: Bool = false //TODO: add condition
    
    init(client: Client, haiku: Haiku) {
        self.haiku = haiku
        super.init(client: client)
        self.prepareModel()
    }
    
    //MARK: - Private functions
    
    private func prepareModel() {
        
        self.fields = self.haiku.fields.flatMap({$0.text})
    }
    
    //MARK: - Public functions
    
    public func inputText(forIndex index: Int, text: String) {
        
        if self.haiku.fields.count < index + 1 {
            
            self.haiku.fields.append(Field(user: HaikuManager.shared.currentUser, text: text))
            print("-- Field appended")
        }
        else if self.haiku.fields.count < index + 1 {
            
            self.haiku.fields[index].text = text
            print("-- Field updated")
        }
        else {
            
             print("-- Field update failed")
        }
    }
    
    public func isEditingEnabled(forIndex index: Int) -> Bool {
        
        var result = false
        
        if self.fields.count == 0 {
            
            result = true
        }
        else if self.fields.count > 0 {
            
        }
        
        return result
    }
    
    public func isTextFieldHidden(forIndex index: Int) -> Bool {
        
        return self.haiku.fields[safe: index] != nil
    }
    
    
    
}
