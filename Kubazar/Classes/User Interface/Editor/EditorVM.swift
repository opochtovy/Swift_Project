//
//  EditorVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import PromiseKit

enum HaikuCreationError: Error {
    
    case shortField
}

extension HaikuCreationError: LocalizedError {
    
    var localizedDescription: String {
        
        switch self {
        case .shortField:
            return NSLocalizedString("Line is too short", comment: "")
        }
    }
}

class EditorVM: BaseVM {

    enum EditScope {
       
        case creator
        case player
    }
    
    enum PlayserScope {
        
        case solo
        case multi
    }
    
    private enum Tips {
        
        static let firstLane = NSLocalizedString("Editor_tip_firstLine", comment: "")
        static let secondLane = NSLocalizedString("Editor_tip_secondLine", comment: "")
        static let thirdLane = NSLocalizedString("Editor_tip_thirdLine", comment: "")
    }
    
    public var fields: [String] = []
    public var editScope: EditScope = .creator
    public var playerScope: PlayserScope = .solo
    public var fontSize: Float = Decorator.defaults.fontSize
    public var fontHexColor: String = Decorator.defaults.fontColor
    public var fontFamilyName: String = Decorator.defaults.familyName
    private var monoField: String?
    
    private let haiku: Haiku
    public var imageData: Data?
    public var haikuBackURL: URL?
    
    public var nextActionEnabled: Bool {
        
        var result = false
        
        if self.editScope == .creator {
            
            result = true
        }
        else if self.editScope == .player {
            
            let turnUser = self.haiku.currentTurnUser
            result = turnUser == HaikuManager.shared.currentUser
        }
        return result
    }
    
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
        self.editScope = self.haiku.id.count > 0 ? .player : .creator
        self.playerScope = self.haiku.players.count == 1 ? .solo : .multi
        self.prepareDecorator()
    }
    
    //MARK: - Public functions
    
    public func prepareDecorator() {
        
        self.fontHexColor = self.haiku.decorator.fontHexColor
        self.fontSize = self.haiku.decorator.fontSize
        self.fontFamilyName = self.haiku.decorator.fontFamily
    }
        public func inputText(forIndex index: Int, text: String?) {
        

        if self.editScope == .creator {
            
            self.haiku.fields[index].text = text
        }
        else {
            
            self.monoField = text
        }
    }
    
    public func isEditingEnabled(forIndex index: Int) -> Bool {
        
        var result = false

        if self.editScope == .creator && self.playerScope == .solo {
            
            result = true
        }
        else {
            
            let turnUser = self.haiku.currentTurnUser
            let isCurrentUserTurn: Bool = turnUser == HaikuManager.shared.currentUser
            let field = self.haiku.fields[index]
            let isFieldCompleted = field.text != nil
            
            if isCurrentUserTurn == true && field.owner == turnUser && !isFieldCompleted {
                
                result = true
            }
        }

        return result
    }
    
    public func isTextFieldShown(forIndex index: Int) -> Bool {
        
        var result = false
        
        if self.editScope == .creator && self.playerScope == .solo {
            
            //show all fields
            result = true
        }
        else if self.editScope == .creator && self.playerScope == .multi {
            
            //show first field
            result = index == 0
        }
        else if self.playerScope == .multi {
            
            //show completed fields or your field if your turn
            let field = self.haiku.fields[index]
            let isCurrentUserTurn = self.haiku.currentTurnUser == field.owner
            result = field.text != nil || isCurrentUserTurn
        }
        
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
        
        var status : PlayerStatus = .none
        
        let field: Field = self.haiku.fields[indexPath.row]
        let turnUser = self.haiku.currentTurnUser
        if field.text != nil {
            
            status = .done
        }
        else if field.owner == turnUser {
            
            status = .inProgress
        }
        
        let syllablesCount : Int = indexPath.row == 1 ? 7 : 5
        let isCurrentUserField = field.owner == HaikuManager.shared.currentUser
        return PlayerCellVM(withPlayer: field.owner, status: status, syllablesCount: syllablesCount, isCurrentUserField: isCurrentUserField)
    }
    
    public func numberOfItems() -> Int {
        
        guard self.editScope == .player else { return 0 }
        return self.haiku.fields.count
    }
    
    public func resetDecorator() {
        
        self.haiku.decorator = Decorator()
        self.prepareDecorator()
    }
    
    public func createSingleHaiku(completion: @escaping BaseCompletion) {
        
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
    
    public func createMultiHaiku(completion: @escaping BaseCompletion) {
        
        guard let imageData = self.imageData else { completion(false, AppError.nilFound); return }
        self.client.authenticator.postMultiHaiku(self.haiku).then { (haiku) -> Promise<Haiku> in
            
            return self.client.authenticator.postHaikuImage(imageData, haiku)
            
        }.then { haiku -> Void in
            
            print(haiku)
            completion(true, nil)
            
        }.catch { error -> Void in
            
            completion(false, error)
        }
    }
    
    public func addLine(completion: @escaping BaseCompletion) {
        
        guard let field = self.monoField, field.count > 1 else { return completion(false, HaikuCreationError.shortField) }
        
        self.client.authenticator.putLine(haiku: self.haiku, fieldText: field).then { haiku -> Void in

            completion(true, nil)
            
        }.catch { error -> Void in
            
            completion(false, error)
        }
    }
}
