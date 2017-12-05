//
//  FriendListVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MessageUI

protocol InviteContactDelegate: class {
    
    func shouldInviteContact(userName: String, phoneNumbers: [String]) -> ()
}

class FriendListVC: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate, InviteContactDelegate {
    
    private var scFilter: UISegmentedControl!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tblFriends: UITableView!
    
    
    let viewModel: FriendListVM
    
    //MARK: - LifeCycle
    
    init(client: Client, viewModel: FriendListVM) {
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = [NSLocalizedString("FriendList_kubazar", comment: ""),
                      NSLocalizedString("FriendList_all", comment: "")]
        self.scFilter = UISegmentedControl(items: titles)
        self.scFilter.addTarget(self, action: #selector(FriendListVC.didSelectSegmentControl(_:)), for: .valueChanged)
        self.navigationItem.titleView = self.scFilter
        self.tblFriends.sectionIndexColor = #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)
        self.tblFriends.sectionIndexBackgroundColor = UIColor.white
        self.tblFriends.register(UINib.init(nibName: "FriendListCell", bundle: nil), forCellReuseIdentifier: FriendListCell.reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBarAppearance()
        self.fetchAndResreshContent()
    }
    
    //MARK: - Private functions
    
    private func fetchAndResreshContent() {
        
        self.updateContent()
        
        self.viewModel.getContacts { [weak self](success, error) in
            
            guard let weakSelf = self else { return }
            
            if success {
                
                weakSelf.updateContent()
            }
            else {
                
                print("\(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    private func updateContent() {
        
        self.scFilter.selectedSegmentIndex = self.viewModel.filter.rawValue
        self.tblFriends.reloadData()

    }
    
    private func setBarAppearance() {
            
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func showInviteAlert(_ inviteViewController: UINavigationController) {
        
        let title = NSLocalizedString("FriendList_invite_alert_title", comment: "")
        let message = NSLocalizedString("FriendList_invite_alert_message", comment: "")
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: NSLocalizedString("Editor_congrats_alert_ok", comment: ""), style: .default) { (_) in
            
            self.navigationController?.pushViewController(inviteViewController, animated: true)
        }
        
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    //MARK: - Actions
    
    @IBAction private func didSelectSegmentControl(_ sender: UISegmentedControl) {
        
        if let value = FriendListVM.Filter(rawValue: sender.selectedSegmentIndex) {
            
            self.viewModel.filter = value
            self.viewModel.prepareModel()
            self.updateContent()
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfItems(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendListCell.reuseID, for: indexPath) as! FriendListCell
        cell.viewModel = self.viewModel.getFriendListCellVM(forIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.viewModel.getSectionIndexTitles()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.viewModel.getFriendListCellVM(forIndexPath: indexPath).showInviteButton == false {
            
            if let vm = self.viewModel.getFriendDetailVM(forIndexPath: indexPath) {
                
                let ctrl = FriendDetailVC(client: self.client, viewModel: vm)
                ctrl.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ctrl, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = FriendListHeaderView(frame: CGRect.zero)
        header.lbTitle.text = self.viewModel.titleForSection(section: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {        

        let footer = FriendListFooterView(frame: CGRect.zero)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 28.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 11.0
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel.searchFilter = searchText
        self.updateContent()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    //MARK: - InviteContactDelegate
    
    func shouldInviteContact(userName: String, phoneNumbers: [String]) {
        
        guard phoneNumbers.count > 0 else { return }
        guard let phoneNumber = phoneNumbers.first else { return }
        
        let ctrl = MFMessageComposeViewController.init(rootViewController: self)
        ctrl.body = "\(userName), You have been invited to Kubazar "
        ctrl.subject = "Invite friend"
        ctrl.delegate = self
        ctrl.recipients = [phoneNumber]
        
        if phoneNumbers.count == 1 {
            
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        else if phoneNumbers.count > 1 {
            
            self.showInviteAlert(ctrl)
        }
    }
}

extension FriendListVC: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        print(result)
    }
}
