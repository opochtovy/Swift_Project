//
//  FriendListVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class FriendListVC: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
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
        self.tblFriends.register(UINib.init(nibName: "FriendListCell", bundle: nil), forCellReuseIdentifier: FriendListCell.reuseID)
        self.updateContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Private functions
    
    private func updateContent() {
        
        self.scFilter.selectedSegmentIndex = self.viewModel.filter.rawValue
        
        
    }
    private func setStatusBarAppearance() {
            
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    //MARK: - Actions
    
    @IBAction private func didSelectSegmentControl(_ sender: UISegmentedControl) {
        
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
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.viewModel.getSectionIndexTitles()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
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
        print("searchText")
    }
    
}
