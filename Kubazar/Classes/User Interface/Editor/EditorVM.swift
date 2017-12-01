//
//  EditorVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import PromiseKit

class EditorVM: BaseVM {

    enum EditScope {
       
        case creator
        case player
    }
    
    private enum Tips {
        
        static let firstLane = NSLocalizedString("Editor_tip_firstLine", comment: "")
        static let secondLane = NSLocalizedString("Editor_tip_secondLine", comment: "")
        static let thirdLane = NSLocalizedString("Editor_tip_thirdLine", comment: "")
    }
    
    var fields: [String] = []
    public var scope: EditScope = .creator
    public var fontSize: Float = Decorator.defaults.fontSize
    public var fontHexColor: String = Decorator.defaults.fontColor
    public var fontFamilyName: String = Decorator.defaults.familyName
    
    private let haiku: Haiku
    public var imageData: Data?
    public var haikuBackURL: URL?
    
    public var nextActionEnabled: Bool = true //TODO: add condition
    
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
        self.scope = self.haiku.id.count > 1 ? .player : .creator
        self.prepareDecorator()
    }
    
    //MARK: - Public functions
    
    public func prepareDecorator() {
        
        self.fontHexColor = self.haiku.decorator.fontHexColor
        self.fontSize = self.haiku.decorator.fontSize
        self.fontFamilyName = self.haiku.decorator.fontFamily
    }
    
    public func inputText(forIndex index: Int, text: String) {
        

        self.haiku.fields[index].text = text
        print("-- Field updated")
        

    }
    
    public func isEditingEnabled(forIndex index: Int) -> Bool {
        
        var result = false
        
        // is user solo
        if self.haiku.players.count == 1 && self.haiku.players.contains(HaikuManager.shared.currentUser) {
            
            result = true
        }
        else {

            let player = self.haiku.players[safe: index]
            
            result = player == HaikuManager.shared.currentUser
        }
        print("is editing selecting \(index) - \(result)")
        return result
    }
    
    public func isTextFieldHidden(forIndex index: Int) -> Bool {
        
        var result = true
        
        if self.haiku.players.count == 1 &&  self.haiku.players.contains(HaikuManager.shared.currentUser) {
            
            result = false
        }
        else if self.haiku.finishedFieldsCount >= index {
            
            result = false
        }
        print("is hidden \(index) - \(result)")
        return result
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
    
    public func getPlayerCellVM(forIndexPath indexPath: IndexPath) -> PlayerCellVM {
        
        let status : PlayerStatus = PlayerStatus.done // TODO: add status logic
        let syllablesCount : Int = 7 // MOcked
        return PlayerCellVM(withPlayer: self.haiku.players[indexPath.row], status: status, syllablesCount: syllablesCount)
    }
    
    public func numberOfItems() -> Int {
        
        guard self.scope == .player else { return 0 }
        return self.haiku.players.count
    }
    
    public func resetDecorator() {
        
        self.haiku.decorator = Decorator()
        self.prepareDecorator()
    }
    
    public func sendSingleHaiku(completion: @escaping BaseCompletion) {
        
        guard let imageData = self.imageData else { completion(false, AppError.nilFound); return }
        
        self.client.authenticator.postSingleHaiku(self.haiku).then { (haiku) -> Promise<Haiku> in
            
            return self.client.authenticator.postHaikuImage(imageData, haiku)
            
        }.then { haiku -> Void in
        
            print(haiku)
            completion(true, nil)
            
        }.catch { error -> Void in
            
            completion(false, error)
        }
    }
}
