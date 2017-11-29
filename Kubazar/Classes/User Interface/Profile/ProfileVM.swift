//
//  ProfileVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class ProfileVM: BaseVM {
    
    static let nameHeaderTitle = "ProfileVM_nameHeaderTitle"
    static let infoHeaderTitle = "ProfileVM_infoHeaderTitle"
    static let changePasswordTitle = "ProfileVM_changePasswordTitle"
    static let infoHeaderButtonTitle = "ProfileVM_infoHeaderButtonTitle"
    
    enum ProfileFilter: Int {
        
        case profile = 0
        case info = 1
    }
    
    public var filter: ProfileFilter = .profile
    public var tableViewData : [(title: String, buttonTitle: String, hasDisclosure: Bool)] = []
    
    override init(client: Client) {
        
        super.init(client: client)
        self.createTableViewData()
    }
    
    //MARK: - Public functions
    
    public func getCountOfTableViewCells() -> Int {
        
        return self.tableViewData.count
    }
    
    public func createTableViewData() {
        
        self.tableViewData = [(NSLocalizedString(ProfileVM.nameHeaderTitle, comment: ""), "", false),
                              (self.client.authenticator.getUserDisplayName(), "", false),
                              (NSLocalizedString(ProfileVM.infoHeaderTitle, comment: ""), "", false),
                              (self.client.authenticator.getUserEmail(), "", false),
                              (self.client.authenticator.getUserPhone(), "", false),
                              (NSLocalizedString(ProfileVM.changePasswordTitle, comment: ""), "", true)]
    }
    
    public func getProfileHeaderCellVM(forIndexPath indexPath: IndexPath) -> ProfileHeaderCellVM {
        
        if indexPath.row >= self.tableViewData.count {
            fatalError("ProfileVM")
        }
        
        let data: (String, String, Bool) = self.tableViewData[indexPath.row]
        return ProfileHeaderCellVM(header: data.0, button: data.1)
    }
    
    public func getProfileInfoCellVM(forIndexPath indexPath: IndexPath) -> ProfileInfoCellVM {
        
        if indexPath.row >= self.tableViewData.count {
            fatalError("ProfileInfoCellVM")
        }
        
        let data: (String, String, Bool) = self.tableViewData[indexPath.row]
        return ProfileInfoCellVM(header: data.0, hasDisclosure: data.2)
    }
}
