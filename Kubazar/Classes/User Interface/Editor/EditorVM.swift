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
    
    enum Tips {
        
        static let firstLane = "Enter first line of haiku: 5 syllables"
        static let secondLane = "Enter second line of haiku: 7 syllables"
        static let thirdLane = "Enter third line of haiku: 5 syllables"
    }
    
    var fields: [String] = []
    public var scope: EditingScope = .creatorSetup
    public var fontSize: Float = Decorator.defaults.fontSize
    public var fontHexColor: String = Decorator.defaults.fontColor
    public var fontFamilyName: String = Decorator.defaults.familyName
    
    private let haiku: Haiku
    public var imageData: Data?
    public var haikuBackURL: URL?
    
    public var nextActionEnabled: Bool = false //TODO: add condition
    
    init(client: Client, haiku: Haiku, imageData: Data? = nil) {
        self.haiku = haiku
        self.imageData = imageData
        super.init(client: client)
        self.prepareModel()
    }
    
    //MARK: - Private functions
    
    private func prepareModel() {
        
        self.haikuBackURL = URL(string: self.haiku.pictureURL ?? "")
        self.fields = self.haiku.fields.flatMap({$0.text})
        self.prepareDecorator()
    }
    
    //MARK: - Public functions
    
    public func prepareDecorator() {
        
        self.fontHexColor = self.haiku.decorator.fontHexColor
        self.fontSize = self.haiku.decorator.fontSize
        self.fontFamilyName = self.haiku.decorator.fontFamily
    }
    
    public func inputText(forIndex index: Int, text: String) {
        
        if self.haiku.fields.count < index + 1 {
            
            self.haiku.fields.append(Field(user: HaikuManager.shared.currentUser, text: text))
            print("-- Field appended")
        }
        else if self.haiku.fields.count == index + 1 {
            
            self.haiku.fields[index].text = text
            print("-- Field updated")
        }
        else {
            
             print("-- Field update failed")
        }
    }
    
    public func isEditingEnabled(forIndex index: Int) -> Bool {
        
        var result = false
        
        if self.fields.count == 0 && index == 0{
            
            result = true
        }
        else if self.fields.count > 0 {
            
        }
        
        return result
    }
    
    public func isTextFieldHidden(forIndex index: Int) -> Bool {
        
        return self.haiku.fields[safe: index] != nil
    }
    
    public func getTipText(forIndexPath index: Int) -> String {
        
        var result: String = ""
        
        switch index {
            
        case 0:     result = Tips.firstLane
        case 1:     result = Tips.secondLane
        case 2:     result = Tips.thirdLane
        default:    break
        }
        
        return result
    }
    
    public func getColorVM() -> ColorVM {
        
        return ColorVM(withDecorator: self.haiku.decorator)
    }
    
    public func getFontVM() -> FontVM {
        
        return FontVM(withDecorator: self.haiku.decorator)
    }
    
    public func resetDecorator() {
        
        self.haiku.decorator = Decorator()
        self.prepareDecorator()
    }
}
