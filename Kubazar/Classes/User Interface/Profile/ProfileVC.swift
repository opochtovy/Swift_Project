//
//  ProfileVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let profileSegmentTitle = "ProfileVC_profileSegmentTitle"
    static let infoSegmentTitle = "ProfileVC_infoSegmentTitle"
    static let descriptionLabelText = "ProfileVC_descriptionLabelText"
    static let thankYouLabelText = "ProfileVC_thankYouLabelText"
    static let termsOfServiceButtonTitle = "ProfileVC_termsOfServiceButtonTitle"

    @IBOutlet weak var profileContentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet private var tblView: UITableView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    
    private var scFilter: UISegmentedControl!
    
    private let viewModel: ProfileVM
    private var isTblViewEditable: Bool = false
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        self.viewModel = ProfileVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarAppearance()
        self.localizeTitles()
        self.customizeEditImageButton()
        self.updateContent()
        
        self.tblView.register(UINib.init(nibName: ProfileHeaderCell.reuseID, bundle: nil), forCellReuseIdentifier: ProfileHeaderCell.reuseID)
        self.tblView.register(UINib.init(nibName: ProfileInfoCell.reuseID, bundle: nil), forCellReuseIdentifier: ProfileInfoCell.reuseID)
        self.tblView.separatorStyle = .none
        
        self.downloadProfileImage()
    }
    
    //MARK: - Private functions
    
    private func downloadProfileImage() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel.client.authenticator.downloadProfileImage { (imageData, success) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if let imageData = imageData {
                self.profileImageView.image = UIImage(data: imageData)
            } else {
                self.profileImageView.image = UIImage(named:"testProfileImage")
            }
        }
    }
    
    private func setNavigationBarAppearance() {
        
        self.scFilter = UISegmentedControl(items: [NSLocalizedString(ProfileVC.profileSegmentTitle, comment: ""),
                                                   NSLocalizedString(ProfileVC.infoSegmentTitle, comment: "")])
        
        self.scFilter.addTarget(self, action: #selector(ProfileVC.didSelectSegment), for: .valueChanged)
        self.scFilter.selectedSegmentIndex = self.viewModel.filter.rawValue
        self.navigationItem.titleView = self.scFilter
    }
    
    private func updateUserProfile(displayName: String, email: String) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.client.authenticator.updateUserProfile(displayName: displayName, email: email) { (errorDescription, success) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if !success {
                
                self.showWrongResponseAlert(message: errorDescription)
                
            }
        }
    }
    
    private func localizeTitles() {
        
        self.editImageButton.setTitle(" " + NSLocalizedString(ButtonTitles.editButtonTitle, comment: ""), for: .normal)
        self.descriptionLabel.text = NSLocalizedString(ProfileVC.descriptionLabelText, comment: "")
        self.thankYouLabel.text = NSLocalizedString(ProfileVC.thankYouLabelText, comment: "")
        self.termsOfServiceButton.setTitle(NSLocalizedString(ProfileVC.termsOfServiceButtonTitle, comment: ""), for: .normal)
    }
    
    private func customizeEditImageButton() {
        
        self.editImageButton.layer.cornerRadius = 4.0
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.getCountOfTableViewCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderCell.reuseID, for: indexPath) as! ProfileHeaderCell
            cell.viewModel = self.viewModel.getProfileHeaderCellVM(forIndexPath: indexPath)
            cell.rightButton.addTarget(self, action: #selector(self.pressRightButton(button:)), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoCell.reuseID, for: indexPath) as! ProfileInfoCell
            cell.viewModel = self.viewModel.getProfileInfoCellVM(forIndexPath: indexPath)            
            cell.bottomLine.isHidden = true
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderCell.reuseID, for: indexPath) as! ProfileHeaderCell
            cell.viewModel = self.viewModel.getProfileHeaderCellVM(forIndexPath: indexPath)
            cell.rightButton.addTarget(self, action: #selector(self.pressRightButton(button:)), for: .touchUpInside)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoCell.reuseID, for: indexPath) as! ProfileInfoCell
            cell.viewModel = self.viewModel.getProfileInfoCellVM(forIndexPath: indexPath)
            cell.infoTextField.textColor = #colorLiteral(red: 0.4588235294, green: 0.7803921569, blue: 0.7725490196, alpha: 1)
            cell.bottomLine.isHidden = true
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoCell.reuseID, for: indexPath) as! ProfileInfoCell
            cell.viewModel = self.viewModel.getProfileInfoCellVM(forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        switch(indexPath.row) {
        case 1: return !self.isTblViewEditable
        case self.viewModel.getCountOfTableViewCells() - 1: return !self.isTblViewEditable
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tblView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: - Actions
    
    @objc func pressRightButton(button: UIButton) {
        
        print("right button was pressed")
        let title = self.isTblViewEditable ? NSLocalizedString(ProfileVM.infoHeaderButtonTitle, comment: "") : NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "")
        button.setTitle(title, for: .normal)
        self.isTblViewEditable = !self.isTblViewEditable
        
        var displayName = ""
        var email = ""
        for cell in self.tblView.visibleCells {
            if cell != self.tblView.visibleCells.last, cell is ProfileInfoCell {
                let cell = cell as! ProfileInfoCell
                if let cellIndex = self.tblView.visibleCells.index(of: cell) {
                    
                    switch(cellIndex) {
                    case 1: cell.infoTextField.isEnabled = self.isTblViewEditable
                    if let text = cell.infoTextField.text {
                        displayName = text
                    }
                        
                    case 3: cell.infoTextField.isEnabled = self.isTblViewEditable
                    if let text = cell.infoTextField.text {
                        email = text
                    }
                        
                    default: continue
                    }
                }
            }
        }
        
        if !self.isTblViewEditable {
            
            self.updateUserProfile(displayName: displayName, email: email)
        }
    }
    
    @objc private func didSelectSegment(_ sender: UISegmentedControl) {
        
        if let value = ProfileVM.ProfileFilter(rawValue: sender.selectedSegmentIndex) {
            
            self.viewModel.filter = value
            self.updateContent()
        }
    }
    
    private func updateContent() {
        
        self.profileContentView.isHidden = self.viewModel.filter == .info
    }
    
    @IBAction func actionEditImage(_ sender: UIButton) {
        
        print("edit image button was pressed")
    }
}
