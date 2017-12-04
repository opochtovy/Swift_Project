//
//  NotificationsVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD

class NotificationsVC: ViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet private weak var tblNotifications: UITableView!
    
    private let viewModel: NotificationsVM
    private var scrollViewPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    init(client: Client, viewModel: NotificationsVM) {
        self.viewModel = viewModel
        super.init(client: client)
        self.title = NSLocalizedString(TabBarTitles.notifications, comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblNotifications.register(UINib.init(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: NotificationCell.reuseID)
        self.tblNotifications.register(UINib.init(nibName: "RememberCell", bundle: nil), forCellReuseIdentifier: RememberCell.reuseID)
        self.tblNotifications.rowHeight = UITableViewAutomaticDimension
        self.tblNotifications.estimatedRowHeight = 75

        self.getNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarAppearance()
    }

    //MARK: - private functions
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
    }
    
    private func getNotifications() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel.getNotifications { [weak self](success, error) in
            
            guard let weakSelf = self else { return }
            
            MBProgressHUD.hide(for: weakSelf.view, animated: true)
            weakSelf.tblNotifications.reloadData()
            weakSelf.getMoreNotificationsDuringScrolling()
        }
    }
    
    private func getMoreNotificationsDuringScrolling() {
        
        if ((self.tblNotifications.contentOffset.y + 2 * self.tblNotifications.frame.size.height) >= self.tblNotifications.contentSize.height) {
            
            if !self.viewModel.isDataLoading, !self.viewModel.didEndReached {
                
                self.viewModel.isDataLoading = true
                self.viewModel.page = self.viewModel.page + 1
                self.scrollViewPosition = self.tblNotifications.contentOffset
                self.viewModel.getNotifications { [weak self](success, error) in
                    
                    guard let weakSelf = self else { return }
                    
                    if !success {
                        
                        weakSelf.showWrongResponseAlert(message: "")
                    } else {
                        
                        weakSelf.tblNotifications.reloadData()
                        weakSelf.tblNotifications.setContentOffset(weakSelf.scrollViewPosition, animated: false)
                    }
                }
                
            }
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
        
        let vm = self.viewModel.getNotificationCellVM(forIndexPath: indexPath)
        let reuseID = self.viewModel.getReuseID(forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! NotificationBaseCell
        cell.viewModel = vm
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let ctrl = BazarDetailVC(client: self.client, viewModel: self.viewModel.getBazarDetailVM(forIndexPath: indexPath))
        ctrl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ctrl, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NotificationsHeader(frame: CGRect.zero)
        header.lbTitle.text = self.viewModel.getSectionTitle(forSection: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect.zero)
        footerView.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.viewModel.isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.getMoreNotificationsDuringScrolling()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        self.getMoreNotificationsDuringScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.getMoreNotificationsDuringScrolling()
    }
}
