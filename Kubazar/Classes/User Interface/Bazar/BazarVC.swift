//
//  BazarVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class BazarVC: ViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet private var tblView: UITableView!
    private var scFilter: UISegmentedControl!
    private var vReachabilityAlert: ReachabilityAlertView?
    
    private let viewModel: BazarVM
    
    override init(client: Client) {
        self.viewModel = BazarVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client.reachabilityManager?.listener = { status in
            
            switch status {
            case .reachable(.ethernetOrWiFi):
                print("-- reachable")
                self.hideReachabilityAlert()
            case .notReachable:
                print("-- not  reachable")
                self.showReachabilityAlert()
            default: break
            }
        }
        
        self.scFilter = UISegmentedControl(items: [NSLocalizedString("Bazar_all_haikus", comment: ""),
                                                   NSLocalizedString("My Haikus", comment: ""),
                                                   NSLocalizedString("Bazar_active_haikus", comment: "")])
        
        self.scFilter.addTarget(self, action: #selector(BazarVC.didSelectSegment), for: .valueChanged)
        self.scFilter.selectedSegmentIndex = self.viewModel.filter.rawValue
        self.navigationItem.titleView = self.scFilter
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconSort"), style: .plain, target: self, action: #selector(BazarVC.didPressSortButton))
        
        self.tblView.register(UINib.init(nibName: "BazarCell", bundle: nil), forCellReuseIdentifier: BazarCell.reuseID)
        
        self.setupObserving()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarAppearance()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.updateContent()
    }
    
    //MARK: - Private functions
    
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func updateContent() {
        
        self.tblView.reloadSections(IndexSet.init(integer: 0), with: .fade)
    }
    
    private func updateContentWithJSONObject(dict: [Dictionary<String, Any>], owners: [User]) {
        
        let previousCount = self.viewModel.numberOfItems()
        self.viewModel.getHaikusFromJSONObject(dict: dict, owners: owners)
        
        if self.viewModel.numberOfItems() >= previousCount {
            
            self.updateCells(previousCount: previousCount)
            
        }
    }
    
    func updateCells(previousCount: Int) {
        
        var indexPaths: [IndexPath] = []
        for i in (previousCount...self.viewModel.numberOfItems() - 1) {
            
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        self.tblView.beginUpdates()
        self.tblView.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        self.tblView.endUpdates()
    }
    
    private func showReachabilityAlert() {
        
        self.vReachabilityAlert = ReachabilityAlertView(frame: self.view.frame)
        self.vReachabilityAlert?.btnRefresh.addTarget(self, action: #selector(BazarVC.didPressRefreshButton(_:)), for: .touchUpInside)
        self.view.addSubview(self.vReachabilityAlert!)
    }
    
    private func hideReachabilityAlert() {
        
        for subView in self.view.subviews {
            
            if subView.isKind(of: ReachabilityAlertView.self) {
                
                subView.removeFromSuperview()
            }
        }
    }
    
    @objc private func getPersonalHaikus(page: Int, perPage: Int) {
        
        if self.client.authenticator.state == .authorized {
            
            self.client.authenticator.getPersonalHaikus(page: self.viewModel.page, perPage: self.viewModel.perPage) { [weak self](haikusJSONResponse, owners, success) in
                
                guard let weakSelf = self else { return }
                
                if !success {
                    
                    weakSelf.showWrongResponseAlert(message: "")
                } else {
                    
                    weakSelf.updateContentWithJSONObject(dict: haikusJSONResponse, owners: owners)
                }
            }
        }
    }
    
    private func setupObserving() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(BazarVC.getPersonalHaikus), name: NSNotification.Name(rawValue: FirebaseServerClient.DeviceTokenDidPutNotification), object: nil)
    }
    
    //MARK: - Actions
    @objc private func didPressSortButton(_ sender: UIBarButtonItem) {
        
        let alertCtrl = UIAlertController(title: NSLocalizedString("Bazar_sort_title", comment: ""), message: "", preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: NSLocalizedString("Bazar_sort_bylike", comment: ""), style: .default){ (_) in
            
            self.viewModel.sort = .likes
        }
        
        let action2 = UIAlertAction(title: NSLocalizedString("Bazar_sort_bydate", comment: ""), style: .default){ (_) in
            
            self.viewModel.sort = .date
        }
        
        let action3 = UIAlertAction(title: NSLocalizedString("BazarDetail_alert_cancel", comment: ""), style: .cancel, handler: nil)
        
        alertCtrl.addAction(action1)
        alertCtrl.addAction(action2)
        alertCtrl.addAction(action3)
        
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    @objc private func didSelectSegment(_ sender: UISegmentedControl) {
        
        if let value = BazarVM.BazarFilter(rawValue: sender.selectedSegmentIndex) {
            
            self.viewModel.filter = value
            self.updateContent()
            self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBAction private func didPressRefreshButton(_ sender: UIButton) {
        
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BazarCell.reuseID, for: indexPath) as! BazarCell
        cell.viewModel = self.viewModel.getCellVM(forIndexPath: indexPath)
        if cell.isHaikuPreviewImageNil() {
            
            self.downloadHaikuImageForCell(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    //MARK: Public functions
    
    private func downloadHaikuImageForCell(cell: BazarCell, indexPath: IndexPath) {
        
        if let imagePath = self.viewModel.getImagePathForHaiku(forIndexPath: indexPath), let url = URL(string: imagePath) {
            
            cell.setImageForCell(imageURL: url)
        }
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch self.viewModel.filter {
            
        case .all, .mine:
            
            let ctrl = BazarDetailVC(client: self.client, viewModel: self.viewModel.getDetailVM(forIndexPath: indexPath))
            ctrl.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ctrl, animated: true)
            
        case .active:
            
            let vm = self.viewModel.getEditorVM(forIndexPath: indexPath)
            let ctrl = EditorVC(client: self.client, viewModel: vm)
            ctrl.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.viewModel.isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((self.tblView.contentOffset.y + 2 * self.tblView.frame.size.height) >= self.tblView.contentSize.height) {
            
            if !self.viewModel.isDataLoading, !self.viewModel.didEndReached {
                
                self.viewModel.isDataLoading = true
                self.viewModel.page = self.viewModel.page + 1
                self.getPersonalHaikus(page: self.viewModel.page, perPage: self.viewModel.perPage)
                
            }
        }
        
        
    }
}
