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
        
        self.fields = ["", "", ""]
       
        var i = 0
        for haikuField in self.haiku.fields {
            
            self.fields[i] = haikuField.text ?? ""
            i += 1
        }
//        self.fields = self.haiku.fields.flatMap({$0.text})
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

        guard let text = text else { return }
        
        if self.editScope == .creator {
            
            self.fields[index] = text
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
            let isCurrentUserTurn = self.haiku.currentTurnUser == HaikuManager.shared.currentUser
            let isCurrentUserField = field.owner == HaikuManager.shared.currentUser
            result = field.text != nil || (isCurrentUserTurn && isCurrentUserField)
        }
        
        print("\(result)")
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
        
        //Check fields is not empty
        for field in fields {
            
            if field.count == 0 {
                
                completion(false, HaikuCreationError.shortField)
            }
        }
        let texts = self.fields
        var font: [String: Any] = [:]
        font["color"]   = haiku.decorator.fontHexColor
        font["family"]  = haiku.decorator.fontFamily
        font["size"]    = haiku.decorator.fontSize
        
        let bodyParams: [String : Any] = ["text" : texts,
                                          "font" : font]
        
        self.client.authenticator.postSingleHaiku(bodyParams).then { (haiku) -> Promise<Haiku> in
            
            return self.client.authenticator.postHaikuImage(imageData, haiku)
            
        }.then { haiku -> Void in
        
            print(haiku)
            completion(true, nil)
            
        }.catch { error -> Void in
            
            completion(false, error)
        }
    }
    
    public func createMultiHaiku(completion: @escaping BaseCompletion) {
        
        guard let imageData = self.imageData        else { completion(false, AppError.nilFound); return }
        guard self.fields[0].count > 0  else { completion(false, HaikuCreationError.shortField); return }
        
        let texts: [String] = [self.fields[0]]
        let friends = haiku.friends.flatMap({ (friend) -> String? in
            return friend.id
        })
        var font: [String: Any] = [:]
        font["color"]   = haiku.decorator.fontHexColor
        font["family"]  = haiku.decorator.fontFamily
        font["size"]    = haiku.decorator.fontSize
        
        let bodyParams: [String : Any] = ["text"    : texts,
                                          "font"    : font,
                                          "friends" : friends]
        
        self.client.authenticator.postMultiHaiku(bodyParams).then { (haiku) -> Promise<Haiku> in
            
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
        
        var arguments: [String: Any] = [:]
        arguments["haikuID"] = self.haiku.id
        
        var bodyParams : [String: Any] = [:]
        bodyParams["line"] = field
        
        self.client.authenticator.putLine(arguments: arguments, bodyparameters: bodyParams).then { haiku -> Void in

            completion(true, nil)
            
        }.catch { error -> Void in
            
            completion(false, error)
        }
    }
}
