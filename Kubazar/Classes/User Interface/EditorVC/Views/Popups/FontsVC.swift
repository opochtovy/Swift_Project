//
//  FontsVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import Foundation

class FontsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet private weak var pvFonts: UIPickerView!
    @IBOutlet private weak var slScaleSize: UISlider!
    
    public var delegate: StyleEditorDelegate?
    
    private var dataSource : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slScaleSize.setThumbImage(#imageLiteral(resourceName: "iconSliderThumb"), for: .normal)
        self.dataSource = UIFont.familyNames
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.cornerRadius = 0
        self.view.superview?.layer.cornerRadius = 4.0
    }
    
    //MARK: -  UIPickerViewDataSource,
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource.count
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if pickerLabel == nil {
            
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = UIColor.white
        }
        
        let familyName = self.dataSource[row]
        pickerLabel?.font = UIFont(name: familyName, size: 23)
        pickerLabel?.text = familyName
        
        return pickerLabel!;
    }
}
