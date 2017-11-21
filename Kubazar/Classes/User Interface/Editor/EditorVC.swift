//
//  EditorVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

protocol DecoratorDelegate {
    
    func didUpdateDecorator(viewController: UIViewController)
}

class EditorVC: ViewController, DecoratorDelegate, UITextFieldDelegate {
    
    let viewModel: EditorVM
    @IBOutlet private weak var actionBar: UIView!
    @IBOutlet fileprivate var barButtons: [UIButton]!
    @IBOutlet private var fields: [EditTextField]!
    private var decorator: Decorator = Decorator()
    
    init(client: Client, viewModel: EditorVM) {
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("TabBarTitles_write", comment: "")
        
        let barButton = UIBarButtonItem(title:NSLocalizedString("Picture_continue", comment: ""), style: .plain, target: self, action: #selector(EditorVC.didPressContinueButton(_:)))
        self.navigationItem.setRightBarButton(barButton, animated: true)
        
        self.updateContent()
    }

    //MARK: - Actions

    @IBAction private func didPressContinueButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didPressColorPickButton( _ sender: UIButton) {
       
        sender.isSelected = true
        
        let ctrl = ColorVC(withDecorator: self.decorator)
        ctrl.delegate = self
        ctrl.preferredContentSize = CGSize(width: 98.0, height: 82.0)
        ctrl.modalPresentationStyle = .popover        
        
        let popover = ctrl.popoverPresentationController
        popover?.permittedArrowDirections = [.down]
        popover?.sourceView = sender
        popover?.sourceRect = CGRect(x: sender.bounds.width / 2, y: 5, width: 0, height: 0)
        popover?.delegate = self
        popover?.backgroundColor = UIColor(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1.0)
        
        self.present(ctrl, animated: true)
    }
    
    @IBAction private func didPressFontPickButton( _ sender: UIButton) {
    
        sender.isSelected = true
        
        let ctrl = FontsVC(withDecorator: self.decorator)
        ctrl.delegate = self
        ctrl.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 257.0)
        ctrl.modalPresentationStyle = .popover
        
        let popover = ctrl.popoverPresentationController
        popover?.permittedArrowDirections = [.down]
        popover?.sourceView = actionBar
        popover?.sourceRect = sender.frame
        popover?.delegate = self
        popover?.backgroundColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.7)
        
        self.present(ctrl, animated: true)
    }
    
    //MARK: - Private functions
    
    private func updateContent() {
        
        self.fields[0].isSelected = true
        
        self.actionBar.isHidden = self.viewModel.scope != .creatorSetup
        
        var i = 0
        for field in self.viewModel.fields
        {
            self.fields[i].text = field
            i += 1
        }
        
        self.updateRightBarButton()
        self.updateDecoreContent()
    }
    
    private func updateDecoreContent() {
        
        guard let font = self.decorator.font else { return }
        
        for field in self.fields {
            
            field.font = font
            field.textColor = self.decorator.fontColor
            field.text = field.text // iOS 8.2 bug. need set text after color change
        }
    }
    
    private func updateRightBarButton() {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = self.viewModel.nextActionEnabled
    }
    
    //MARK: - DecoratorDelegate
    func didUpdateDecorator(viewController: UIViewController) {
        
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
