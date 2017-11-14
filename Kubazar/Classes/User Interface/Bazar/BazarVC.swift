//
//  BazarVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class BazarVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var tblView: UITableView?
    private var scFilter: UISegmentedControl!
    
    private let viewModel: BazarVM
    
    override init(client: Client) {
        self.viewModel = BazarVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scFilter = UISegmentedControl(items: [NSLocalizedString("Bazar_all_haikus", comment: ""),
                                                   NSLocalizedString("My Haikus", comment: ""),
                                                   NSLocalizedString("Bazar_active_haikus", comment: "")])
        
        self.scFilter.addTarget(self, action: #selector(BazarVC.didSelectSegment), for: .valueChanged)
        self.scFilter.selectedSegmentIndex = self.viewModel.filter.rawValue
        self.navigationItem.titleView = self.scFilter
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconSort"), style: .plain, target: self, action: #selector(BazarVC.didPressSortButton))
        
        self.tblView?.register(UINib.init(nibName: "BazarCell", bundle: nil), forCellReuseIdentifier: BazarCell.reuseID)
        
        self.updateContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarAppearance()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
    }
    
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    //MARK: - Private functions
    private func updateContent() {
    
        self.tblView?.reloadData()
    }
    
    //MARK: - Actions
    @objc private func didPressSortButton(_ sender: UIBarButtonItem) {
        //TODO: set sort rule to viewModel
    }
    
    @objc private func didSelectSegment(_ sender: UISegmentedControl) {
        
        if let value = BazarVM.BazarFilter(rawValue: sender.selectedSegmentIndex) {
            
           self.viewModel.filter = value
           self.updateContent()
        }
    }
    
    @objc private func didPressLikeButton (_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        switch self.viewModel.filter {
        case .all:
            print("like")
        case .mine:
            print("like")
        case .active:
            print("publish")
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BazarCell.reuseID, for: indexPath) as! BazarCell
        cell.viewModel = self.viewModel.getCellVM(forIndexPath: indexPath)
        cell.btnLike.addTarget(self, action: #selector(BazarVC.didPressLikeButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let ctrl = BazarDetailVC(client: self.client, viewModel: self.viewModel.getDetailVM(forIndexPath: indexPath))
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }


}
