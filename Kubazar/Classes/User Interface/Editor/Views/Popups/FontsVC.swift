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
    
    public var delegate: DecoratorDelegate?
    
    private lazy var dataSource : [String] = {
        
        var fontNames = UIFont.familyNames
        fontNames.insert(Decorator.defaults.familyName, at: 0)
        
        return fontNames
    }()
    
    private let viewModel : FontVM
    
    //MARK: - Lifecycle
    
    init(withViewModel viewModel: FontVM) {
        self.viewModel = viewModel
        super.init(nibName: "FontsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slScaleSize.setThumbImage(#imageLiteral(resourceName: "iconSliderThumb"), for: .normal)
        self.slScaleSize.setThumbImage(#imageLiteral(resourceName: "iconSliderThumb"), for: .highlighted)
        
        self.slScaleSize.minimumValue = Float(Decorator.defaults.minFontSize)
        self.slScaleSize.maximumValue = Float(Decorator.defaults.maxFontSize)
        
        self.updateContent()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.cornerRadius = 0
        self.view.superview?.layer.cornerRadius = 4.0
    }
    
    //MARK: -  Private functions
    
    private func updateContent() {
        
        self.slScaleSize.value = Float(self.viewModel.fontSize)
        
        if let fontFamilyIndex = self.dataSource.index(of: self.viewModel.fontFamilyName) {
            
            self.pvFonts.selectRow(fontFamilyIndex, inComponent: 0, animated: true)
        }        
    }
    
    private func sendDecoratorChanges() {
        
        if let delegate = self.delegate {
            
            delegate.didUpdateDecorator(viewController: self)
        }
    }
    
    //MARK: - Actions
    @IBAction func didChangeScaleSizeValue(_ sender: UISlider) {
        
        self.viewModel.updateDecoratorFontSize(value: sender.value)
        self.sendDecoratorChanges()
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if UIFont.init(name: self.dataSource[row], size: CGFloat(self.slScaleSize.value)) != nil {
            
            self.viewModel.updateDecoratorFontFamily(fontFamilyName: self.dataSource[row])
            self.sendDecoratorChanges()
        }
        else {
            
            print("-- Decorator error")
        }
    }
}
