//
//  BazarDetailVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import Social
import FBSDKShareKit

protocol BazarDetailVCDelegate : class {
    
    func deleteButtonWasPressed(vc: BazarDetailVC, haiku: Haiku)
    func unpublishButtonWasPressed(vc: BazarDetailVC, haiku: Haiku)
}

class BazarDetailVC: ViewController {
    
    static let facebookSheetTitle = "BazarDetailVC_facebookSheetTitle"
    static let facebookAlertTitle = "BazarDetailVC_facebookAlertTitle"
    static let facebookAlertMessage = "BazarDetailVC_facebookAlertMessage"
    static let noNativeFacebookAppAlertMessage = "BazarDetailVC_noNativeFacebookAppAlertMessage"
    
    private enum BackColors {
        
        static let black = UIColor(red: 22/255.0, green: 22/255.0, blue: 22/255.0, alpha: 1.0)
    }

    let viewModel: BazarDetailVM
    
    @IBOutlet private weak var lbDate: UILabel!
    @IBOutlet private weak var vHaikuContent: HaikuPreview!
    
    @IBOutlet private weak var vUser1: UserView!
    @IBOutlet private weak var vUser2: UserView!
    @IBOutlet private weak var vUser3: UserView!
    
    @IBOutlet private weak var toolBar: UIToolbar!
    
    weak var bazarDetailDelegate: BazarDetailVCDelegate?
    
    //MARK: - LifeCycle
    init(client: Client, viewModel: BazarDetailVM) {
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.updateContent()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.setStatusBarAppearance()
        
        
        self.navigationController?.navigationBar.backgroundColor = BackColors.black
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "iconClose"), style: .plain, target: self, action: #selector(BazarDetailVC.didPressCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = back
    }
    
    //MARK:- Actions
    
    @objc private func didPressCloseButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Toolbar  actions
    
    @objc private func didPressLikeButton(_ sender: UIButton) {
        print("-- Like Detail")
        sender.isSelected = !sender.isSelected
        self.viewModel.like(completionHandler: { [weak self](errorDescription, success) in
            
            guard let weakSelf = self else { return }
            
            weakSelf.updateToolBar()
        })
    }
    
    @objc private func didPressShareButton(_ sender: UIBarButtonItem) {
        
        let facebookUrl = URL(string: "fb://")
        if let facebookUrl = facebookUrl {
            
            let isInstalled = UIApplication.shared.canOpenURL(facebookUrl)
            if isInstalled {
                
//                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
//                    let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//                    facebookSheet.setInitialText(NSLocalizedString(BazarDetailVC.facebookSheetTitle, comment: ""))
//                    
//                    let image = self.vHaikuContent.textToImage()
//                    facebookSheet.add(image)
//                    
//                    self.present(facebookSheet, animated: true, completion: nil)
//                } else {
//                    
//                    self.ios11Sharing()
//                }
                
                self.ios11Sharing()
                
            } else {
                
                self.showAlertNoNativeFacebookApp()
            }
        } else {
            
            self.showAlertNoNativeFacebookApp()
        }
    }
    
    private func showAlertNoNativeFacebookApp() {
        
        let alert = UIAlertController(title: NSLocalizedString(BazarDetailVC.facebookSheetTitle, comment: ""), message: NSLocalizedString(BazarDetailVC.noNativeFacebookAppAlertMessage, comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func ios11Sharing() {
        
        let image = self.vHaikuContent.textToImage()
        let photo = FBSDKSharePhoto(image: image, userGenerated: true)
        let content = FBSDKSharePhotoContent()
        content.photos = [photo]
        
//        try FBSDKShareDialog.show(from: self, with: content, delegate: nil)
//        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = .shareSheet
        dialog.show()
    }
    
    @objc private func didPressPublishButton(_ sender: UIBarButtonItem) {
        print("-- Publish")
        self.viewModel.publish(completionHandler: { [weak self](errorDescription, success) in
            
            guard let weakSelf = self else { return }
            
            if weakSelf.viewModel.shouldLeaveBazarDetail() {
                
                weakSelf.bazarDetailDelegate?.unpublishButtonWasPressed(vc: weakSelf, haiku: weakSelf.viewModel.getHaiku())
                weakSelf.navigationController?.popViewController(animated: true)
            }
            
            weakSelf.updateToolBar()
        })
    }
    
    @objc private func didPressDeleteButton(_ sender: UIBarButtonItem) {
        
        let alertTitle: String = NSLocalizedString("BazarDetail_alert_removing_title", comment: "")
        let alertMessageSingle: String = NSLocalizedString("BazarDetail_alert_removing_message", comment: "")
        let multipleAlertMessage: String = NSLocalizedString("BazarDetail_alert_removing_message_multiple", comment: "")
        let alertMessage = self.viewModel.isUserSinglePlayer() ? alertMessageSingle : multipleAlertMessage
        
        let alertCtrl = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: NSLocalizedString("BazarDetail_alert_removing_delete", comment: ""), style: .destructive) { (_) in
            
            self.viewModel.delete(completionHandler: { [weak self](errorDescription, success) in
                
                guard let weakSelf = self else { return }
                
                weakSelf.bazarDetailDelegate?.deleteButtonWasPressed(vc: weakSelf, haiku: weakSelf.viewModel.getHaiku())
                weakSelf.navigationController?.popViewController(animated: true)
            })
        }
        let action2 = UIAlertAction(title: NSLocalizedString("BazarDetail_alert_cancel", comment: ""), style: .cancel, handler: nil)
        alertCtrl.addAction(action1)
        alertCtrl.addAction(action2)
        
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    //MARK: - Private functions
    
    private func updateContent() {
        
        lbDate.text = viewModel.dateText
        
        vHaikuContent.viewModel = self.viewModel.getPreviewVM()
        
        vUser1.viewModel = viewModel.getUserViewVM(forIndex: 0)
        vUser2.viewModel = viewModel.getUserViewVM(forIndex: 1)
        vUser3.viewModel = viewModel.getUserViewVM(forIndex: 2)
        
        self.updateToolBar()
    }
    
    private func updateToolBar() {
        
        var barItems : [UIBarButtonItem] = []
        
        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barItems.append(flexItem)

        //Publish
        let barButtonPublish = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(BazarDetailVC.didPressPublishButton(_:)))
        barButtonPublish.image = self.viewModel.isPublished ? #imageLiteral(resourceName: "iconUnPublish") : #imageLiteral(resourceName: "iconPublish")
        barButtonPublish.tintColor = UIColor.lightGray
        
        //Like
        let btnLike = ActionButton(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        btnLike.addTarget(self, action: #selector(BazarDetailVC.didPressLikeButton(_:)), for: .touchUpInside)
        btnLike.isSelected = self.viewModel.isLiked
        btnLike.title = self.viewModel.likesCount
        let barButtonLike = UIBarButtonItem(customView: btnLike)
        barButtonLike.width = 40
        
        //Delete
        let barButtonDelete = UIBarButtonItem(image: #imageLiteral(resourceName: "iconDelete"), style: .plain, target: self, action: #selector(BazarDetailVC.didPressDeleteButton(_:)))
        barButtonDelete.tintColor = UIColor.lightGray
        
        //Share
        let barButtonShare = UIBarButtonItem(image: #imageLiteral(resourceName: "iconShare"), style: .plain, target: self, action: #selector(BazarDetailVC.didPressShareButton(_:)))
        barButtonShare.tintColor = UIColor.lightGray
        
        switch self.viewModel.mode {
        case .soloPrivate:
            
            barItems.append(barButtonPublish)
            barItems.append(flexItem)
            barItems.append(barButtonDelete)
            
        case .soloPublic:
            
            barItems.append(barButtonLike)
            barItems.append(flexItem)
            barItems.append(barButtonShare)
            barItems.append(flexItem)
            barItems.append(barButtonPublish)
            barItems.append(flexItem)
            barItems.append(barButtonDelete)
            
        case .read:
            
            barItems.append(barButtonLike)
            barItems.append(flexItem)
            barItems.append(barButtonShare)
            
        case .partyMember:
            
            barItems.append(barButtonLike)
            barItems.append(flexItem)
            barItems.append(barButtonShare)
            barItems.append(flexItem)
            barItems.append(barButtonDelete)
            
        case .partyAuthor:
            
            barItems.append(barButtonLike)
            barItems.append(flexItem)
            barItems.append(barButtonShare)
            barItems.append(flexItem)
            barItems.append(barButtonDelete)
        }
        
        barItems.append(flexItem)
        self.toolBar.items = barItems
    }
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = BackColors.black
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
