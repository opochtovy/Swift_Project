//
//  BazarVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD

class BazarVC: ViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, BazarDetailVCDelegate {
    
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
        
        if !self.client.authenticator.isJustAfterAuth {
            
            let notification = Notification(name: Notification.Name(rawValue: FirebaseServerClient.FCMTokenDidPutNotification))
            NotificationCenter.default.post(notification)
        }
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
    
    private func updateContentWithNewHaikus(haikus: [Haiku], shouldResetDataSource: Bool) {
        
        let previousCount = self.viewModel.numberOfItems()
        self.viewModel.getHaikusFromNewHaikus(newHaikus: haikus, shouldResetDataSource: shouldResetDataSource)
        
        if haikus.count == 0 || shouldResetDataSource {
            
            self.tblView.reloadData()
            return
            
        }
        
        if previousCount > 0, self.viewModel.numberOfItems() >= previousCount {
            
            self.updateCells(previousCount: previousCount)
            
        } else if self.viewModel.numberOfItems() > previousCount {
            
            self.reloadTableView()
        }
    }
    
    func updateCells(previousCount: Int) {
        
        var indexPaths: [IndexPath] = []
        if self.viewModel.numberOfItems() == 0 || previousCount >= self.viewModel.numberOfItems() { return }
        
        for i in (previousCount...self.viewModel.numberOfItems() - 1) {
            
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        self.tblView.beginUpdates()
        self.tblView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        self.tblView.endUpdates()
    }
    
    private func showReachabilityAlert() {
        
        self.vReachabilityAlert = ReachabilityAlertView(frame: self.view.bounds)
        self.vReachabilityAlert?.btnRefresh.addTarget(self, action: #selector(BazarVC.didPressRefreshButton(_:)), for: .touchUpInside)
        self.view.addSubview(self.vReachabilityAlert!)
        
        self.tblView.isHidden = true
    }
    
    private func hideReachabilityAlert() {
        
        for subView in self.view.subviews {
            
            if subView.isKind(of: ReachabilityAlertView.self) {
                
                subView.removeFromSuperview()
            }
        }
        
        self.tblView.isHidden = false
    }
    
    private func setupObserving() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(BazarVC.getPersonalHaikus), name: NSNotification.Name(rawValue: FirebaseServerClient.FCMTokenDidPutNotification), object: nil)
    }
    
    @objc private func getPersonalHaikus(page: Int, perPage: Int, shouldResetDataSource: Bool) {
        
        if self.client.authenticator.state == .authorized, self.viewModel.checkStateOfCurrentUser() {
            
            let sortType = self.viewModel.sort == .date ? 0 : 1
            self.client.authenticator.getHaikus(page: self.viewModel.page, perPage: self.viewModel.perPage, sort: sortType, filter: self.viewModel.filter.rawValue) { [weak self](haikus, success) in
                
                guard let weakSelf = self else { return }
                
                MBProgressHUD.hide(for: weakSelf.view, animated: true)
                
                if !success {
                    
                    weakSelf.tblView.reloadData()
//                    weakSelf.showWrongResponseAlert(message: "")
                    weakSelf.reauthenticateUser(shouldResetDataSource: true)
                } else {
                    
                    weakSelf.updateContentWithNewHaikus(haikus: haikus, shouldResetDataSource: shouldResetDataSource)
                }
            }
        } else {
            
            self.showUnexpectedErrorAlert(message: nil)
        }
    }
    
    public func reauthenticateUser(shouldResetDataSource: Bool) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel.reauthenticateUser() { [weak self](haikus, success) in
            
            guard let weakSelf = self else { return }
            
            MBProgressHUD.hide(for: weakSelf.view, animated: true)
            
            if !success {
                
                weakSelf.tblView.reloadData()
            } else {
                
                weakSelf.updateContentWithNewHaikus(haikus: haikus, shouldResetDataSource: shouldResetDataSource)
            }
        }
    }
    
    override func showWrongResponseAlert(message: String?) {
        
        let alertTitle = NSLocalizedString(CommonTitles.errorTitle, comment: "")
        var alertMessage = NSLocalizedString(CommonTitles.wrongResponseMessage, comment: "")
        if let message = message {
            
            alertMessage = message
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: ""), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
            self.reauthenticateUser(shouldResetDataSource: true)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showUnexpectedErrorAlert(message: String?) {
        
        let alertTitle = NSLocalizedString(CommonTitles.errorTitle, comment: "")
        var alertMessage = NSLocalizedString(CommonTitles.wrongResponseMessage, comment: "")
        if let message = message, message.count > 0 {
            
            alertMessage = message
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: ""), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
            self.viewModel.signOut()
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @objc private func didPressSortButton(_ sender: UIBarButtonItem) {
        
        let previousSort = self.viewModel.sort
        
        let alertCtrl = UIAlertController(title: NSLocalizedString("Bazar_sort_title", comment: ""), message: "", preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: NSLocalizedString("Bazar_sort_bylike", comment: ""), style: .default){ (_) in
            
            self.viewModel.sort = .date
            self.getPersonalHaikusDuringSorting(previousSort: previousSort)
        }
        
        let action2 = UIAlertAction(title: NSLocalizedString("Bazar_sort_bydate", comment: ""), style: .default){ (_) in
            
            self.viewModel.sort = .likes
            self.getPersonalHaikusDuringSorting(previousSort: previousSort)
        }
        
        let action3 = UIAlertAction(title: NSLocalizedString("BazarDetail_alert_cancel", comment: ""), style: .cancel, handler: nil)
        
        alertCtrl.addAction(action1)
        alertCtrl.addAction(action2)
        alertCtrl.addAction(action3)
        
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    private func getPersonalHaikusDuringSorting(previousSort: BazarVM.BazarSort) {
        
        if self.viewModel.sort != previousSort {
            
            self.getHaikus(isSortButtonPressed: true)
        }
    }
    
    private func getHaikus(isSortButtonPressed: Bool) {
        
        self.viewModel.updateDataSource(isSortButtonPressed: isSortButtonPressed )
        self.viewModel.page = 0
        self.reloadTableView()
        if self.viewModel.numberOfItems() == 0 {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        self.getPersonalHaikus(page: self.viewModel.page, perPage: self.viewModel.perPage, shouldResetDataSource: true)
    }
    
    private func reloadTableView() {
        
        if self.viewModel.numberOfItems() > 0 {
            
            self.tblView.reloadSections(IndexSet.init(integer: 0), with: .fade)
            self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @objc private func didSelectSegment(_ sender: UISegmentedControl) {
        
        if let value = BazarVM.BazarFilter(rawValue: sender.selectedSegmentIndex) {
            
            self.viewModel.filter = value
            self.getHaikus(isSortButtonPressed: false)
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
        
        return cell
    }
    
    // MARK: - BazarDetailVCDelegate
    
    func deleteButtonWasPressed(vc: BazarDetailVC, haiku: Haiku) {
        
        self.viewModel.deleteHaiku(haiku: haiku)
        self.tblView.reloadData()
    }
    
    
    func unpublishButtonWasPressed(vc: BazarDetailVC, haiku: Haiku) {
        
        self.viewModel.unpublishHaiku(haiku: haiku)
        self.tblView.reloadData()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch self.viewModel.filter {
            
        case .all, .mine:
            
            let ctrl = BazarDetailVC(client: self.client, viewModel: self.viewModel.getDetailVM(forIndexPath: indexPath))
            ctrl.hidesBottomBarWhenPushed = true
            ctrl.bazarDetailDelegate = self
            self.navigationController?.pushViewController(ctrl, animated: true)
            
        case .active:
            
            let vm = self.viewModel.getEditorVM(forIndexPath: indexPath)
            let ctrl = EditorVC(client: self.client, viewModel: vm)
            ctrl.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 452.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.viewModel.isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.getPersonalHaikusDuringScrolling()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        self.getPersonalHaikusDuringScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.getPersonalHaikusDuringScrolling()
    }
    
    private func getPersonalHaikusDuringScrolling() {
        
        if ((self.tblView.contentOffset.y + 2 * self.tblView.frame.size.height) >= self.tblView.contentSize.height) {
            
            if !self.viewModel.isDataLoading, !self.viewModel.didEndReached {
                
                self.viewModel.isDataLoading = true
                self.viewModel.page = self.viewModel.page + 1
                self.getPersonalHaikus(page: self.viewModel.page, perPage: self.viewModel.perPage, shouldResetDataSource: false)
                
            }
        }
    }
}
