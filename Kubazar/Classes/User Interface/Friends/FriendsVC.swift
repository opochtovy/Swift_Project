//
//  FriendsVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class FriendsVC: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tblView: UITableView!

    private let viewModel: FriendsVM
    
    init(client: Client, viewModel: FriendsVM) {
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  self.viewModel.title
        
        let barBtnNext = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(FriendsVC.didPressNextButton))
        self.navigationItem.rightBarButtonItem = barBtnNext
        
        self.tblView.register(UINib.init(nibName: "FriendsCell", bundle: nil), forCellReuseIdentifier: FriendsCell.reuseID)
        self.tblView.tableFooterView = UIView()
        
        self.viewModel.getFriends { (success, error) in
            self.updateContent()
        }
    }

    //MARK: - Actions
    
    @objc private func didPressNextButton(_ sender: UIButton) {
        
        let ctrl = PictureVC(client: self.client, viewModel: self.viewModel.getPictureVM())
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    @objc private func didSelectUser(_ sender: UIButton) {
        
       self.chooseFriend(row: sender.tag)
    }
    
    //MARK: - Private functions
    private func updateContent() {
        
        self.tblView.reloadData()
        self.updateBarButton()
    }
    
    private func updateBarButton() {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = self.viewModel.nextActionAllowed()
    }
    
    private func chooseFriend(row: Int) {
        
        self.viewModel.chooseFriend(row: row)
        self.tblView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        self.updateBarButton()
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.reuseID, for: indexPath) as! FriendsCell
        cell.viewModel = self.viewModel.getFriendsCellVM(forIndexPath: indexPath)
        cell.btnCheck.addTarget(self, action: #selector(FriendsVC.didSelectUser(_:)), for: .touchUpInside)
        cell.btnCheck.tag = indexPath.row
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        self.chooseFriend(row: indexPath.row)
    }
}
