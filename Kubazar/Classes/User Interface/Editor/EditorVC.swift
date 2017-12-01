//
//  EditorVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol DecoratorDelegate {
    
    func didUpdateDecorator(viewController: UIViewController)
}

class EditorVC: ViewController, DecoratorDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private enum PopoverSettings {
        
        case fontPicker
        case colorPicker
        
        var contentSize: CGSize {
            switch self {
            case .fontPicker:   return CGSize(width: UIScreen.main.bounds.width, height: 257.0)
            case .colorPicker:  return CGSize(width: 98.0, height: 82.0)
            }
        }
        
        var background: UIColor {
            switch self {
            case .fontPicker:   return UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.7)
            case .colorPicker:  return UIColor(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1.0)
            }
        }
    }
    
    @IBOutlet private weak var actionBar: UIView!
    @IBOutlet private weak var ivHaikuBack: UIImageView!
    @IBOutlet fileprivate weak var btnColor: UIButton!
    @IBOutlet fileprivate weak var tblPlayers: UITableView!
    @IBOutlet fileprivate var barButtons: [UIButton]!
    @IBOutlet private var fields: [EditTextField]!
    @IBOutlet private weak var cstrTableHeight: NSLayoutConstraint!
    let viewModel: EditorVM
    
    init(client: Client, viewModel: EditorVM) {
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ivHaikuBack.dropShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 5))
        self.title = NSLocalizedString("TabBarTitles_write", comment: "")
        
        let barButton = UIBarButtonItem(title:NSLocalizedString("Picture_continue", comment: ""), style: .plain, target: self, action: #selector(EditorVC.didPressContinueButton(_:)))
        self.navigationItem.setRightBarButton(barButton, animated: true)
        
        self.tblPlayers.register(UINib.init(nibName: "PlayerCell", bundle: nil), forCellReuseIdentifier: PlayerCell.reuseID)
        
        self.updateContent()
    }

    //MARK: - Actions

    @IBAction private func didPressContinueButton(_ sender: UIButton) {
        
        if self.viewModel.editScope == .creator && self.viewModel.playerScope == .solo {
            //create solo haiku
            print("-- Create solo haiku")
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel.createSingleHaiku {[weak self](success, error) in
                
                guard let weakSelf = self else { return }
                MBProgressHUD.showAdded(to: weakSelf.view, animated: true)
                if success {
                    weakSelf.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    weakSelf.showErrorAlert()
                }
            }
        }
        else if self.viewModel.editScope == .creator && self.viewModel.playerScope == .multi {
            //create multi haiku
            print("-- Create multi haiku")
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel.createMultiHaiku(completion: { [weak self](success, error) in
                
                guard let weakSelf = self else { return }
                MBProgressHUD.hide(for: weakSelf.view, animated: true)
                if success {
                    weakSelf.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    weakSelf.showErrorAlert()
                }
            })
        }
        else if self.viewModel.editScope == .player {
            //add line to haiku
            
        }
    }
    
    @IBAction private func didPressColorPickButton( _ sender: UIButton) {
       
        sender.isSelected = true
        
        let ctrl = ColorVC(withViewModel: self.viewModel.getColorVM())
        ctrl.delegate = self
        ctrl.preferredContentSize = PopoverSettings.colorPicker.contentSize
        ctrl.modalPresentationStyle = .popover        
        
        let popover = ctrl.popoverPresentationController
        popover?.permittedArrowDirections = [.down]
        popover?.sourceView = sender
        popover?.sourceRect = CGRect(x: sender.bounds.width / 2, y: 5, width: 0, height: 0)
        popover?.delegate = self
        popover?.backgroundColor = PopoverSettings.colorPicker.background
        
        self.present(ctrl, animated: true)
    }
    
    @IBAction private func didPressFontPickButton( _ sender: UIButton) {
    
        sender.isSelected = true
        
        let ctrl = FontsVC(withViewModel: self.viewModel.getFontVM())
        ctrl.delegate = self
        ctrl.preferredContentSize = PopoverSettings.fontPicker.contentSize
        ctrl.modalPresentationStyle = .popover
        
        let popover = ctrl.popoverPresentationController
        popover?.permittedArrowDirections = [.down]
        popover?.sourceView = actionBar
        popover?.sourceRect = sender.frame
        popover?.delegate = self
        popover?.backgroundColor = PopoverSettings.fontPicker.background
        
        self.present(ctrl, animated: true)
    }
    
    @IBAction private func didPressResetButton(_ sender: UIButton) {
        
        self.viewModel.resetDecorator()
        self.updateContent()
    }
    
    //MARK: - Private functions
    
    private func updateContent() {        
  
        if self.viewModel.editScope == .creator {
            
            self.actionBar.isHidden = false
            self.tblPlayers.isHidden = true
            self.cstrTableHeight.constant = 0
        }
        else {
            
            self.actionBar.isHidden = true
            self.tblPlayers.isHidden = false
            self.cstrTableHeight.constant = CGFloat(self.viewModel.numberOfItems()) * self.tableView(self.tblPlayers, heightForRowAt: IndexPath(row: 0, section: 0))
        }
        
 
        var i: Int = 0
        for textField in self.fields {
            
            textField.isHidden = self.viewModel.isTextFieldHidden(forIndex: i)
            textField.isSelected = self.viewModel.isEditingEnabled(forIndex: i)
            textField.text = self.viewModel.fields[safe: i]
            i += 1
        }
        
        if let imageData = self.viewModel.imageData, let image = UIImage(data: imageData) {
            
            self.ivHaikuBack.image = image
        }
        else if let url = self.viewModel.haikuBackURL {
            
            self.ivHaikuBack.af_setImage(withURL: url)
        }
        
        self.updateRightBarButton()
        self.updateDecoreContent()
    }
    
    private func updateDecoreContent() {
        
        guard let font = UIFont.init(name: self.viewModel.fontFamilyName, size: CGFloat(self.viewModel.fontSize)) else { return }
        
        for field in self.fields {
            
            field.font = font
            field.textColor = UIColor(hex: self.viewModel.fontHexColor)
            field.text = field.text // iOS 8.2 bug. need set text after color change
        }
        
        self.btnColor.tintColor = UIColor(hex: self.viewModel.fontHexColor)
    }
    
    private func updateRightBarButton() {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = self.viewModel.nextActionEnabled
    }
    
    private func showCongratsAlert() {
        
        let messageTitle = NSLocalizedString("Editor_congrats_alert_title", comment: "")
        let message = ""
        let alertCtrl = UIAlertController(title: messageTitle, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: NSLocalizedString("Editor_congrats_alert_ok", comment: ""), style: .default) { (_) in
            // Ok action
        }
        
        alertCtrl.addAction(action1)
        
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        
        let alertTitle = NSLocalizedString("Editor_alert_fail_title", comment: "")
        let alertMessage = NSLocalizedString("Editor_alert_fail_message", comment: "")
        let alertCtrl = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action1 = UIAlertAction(title: NSLocalizedString("Editor_congrats_alert_ok", comment: ""), style: .default, handler: nil)
        alertCtrl.addAction(action1)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    //MARK: - DecoratorDelegate
    func didUpdateDecorator(viewController: UIViewController) {
        
        self.viewModel.prepareDecorator()
        self.updateDecoreContent()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.viewModel.inputText(forIndex: textField.tag, text: textField.text ?? "")
        TipView.hideTip(fromView: textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let result = self.viewModel.isEditingEnabled(forIndex: textField.tag)
        
        if result == true {
            
            let position: TipPosition = textField.tag == 0 ? .top : .bottom
            let tipText = self.viewModel.getTipText(forIndexPath: textField.tag)
            TipView.showTip(fromView: textField, position: position, title: tipText)
        }
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
     //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseID, for: indexPath) as! PlayerCell
        cell.viewModel = self.viewModel.getPlayerCellVM(forIndexPath: indexPath)
        
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension EditorVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
        for button in self.barButtons {
            
            button.isSelected = false
        }
    }
}
