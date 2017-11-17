//
//  EditorVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

protocol StyleEditorDelegate {
    
    func styleDidChanged(viewController: StyleEditorDelegate)
}

class EditorVC: ViewController {
    
    let viewModel: EditorVM
    @IBOutlet private weak var actionBar: UIView!
    @IBOutlet fileprivate var barButtons: [UIButton]!    
    
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
        
        self.updateContent()
    }

    //MARK: - Actions

    @IBAction private func didPressContinueButton(_ sender: UIButton) {
        
    }
    
    @IBAction private func didPressColorPickButton( _ sender: UIButton) {
       
        sender.isSelected = true
        
        let ctrl = ColorVC()
        ctrl.preferredContentSize = CGSize(width: 98.0, height: 82.0)
        ctrl.modalPresentationStyle = .popover        
        
        let popover = ctrl.popoverPresentationController
        popover?.permittedArrowDirections = [.down]
        popover?.sourceView = sender
        popover?.sourceRect = CGRect(x: sender.bounds.width / 2, y: 5, width: 0, height: 0)
        popover?.delegate = self
        popover?.backgroundColor = UIColor.init(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1.0)
        
        self.present(ctrl, animated: true)
    }
    
    @IBAction private func didPressFontPickButton( _ sender: UIButton) {
    
        sender.isSelected = true
        
        let ctrl = FontsVC()
        ctrl.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 257.0)
        ctrl.modalPresentationStyle = .popover
        
        let popover = ctrl.popoverPresentationController
        popover?.permittedArrowDirections = [.down]
        popover?.sourceView = actionBar
        popover?.sourceRect = sender.frame
        popover?.delegate = self
        popover?.backgroundColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.7)
        
        self.present(ctrl, animated: true)
    }
    
    //MARK: - Private functions
    
    private func updateContent() {
        
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
