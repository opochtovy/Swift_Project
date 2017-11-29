//
//  SMSCodeTextField.swift
//  Kubazar
//
//  Created by Mobexs on 11/20/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

protocol SMSCodeTextFieldDelegate : class {
    
    func backwardButtonWasPressed(textField: SMSCodeTextField)
}

class SMSCodeTextField: UITextField {
    
    weak var smsCodeDelegate: SMSCodeTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func deleteBackward() {
        
        super.deleteBackward()
        self.smsCodeDelegate?.backwardButtonWasPressed(textField: self)
    }

}
