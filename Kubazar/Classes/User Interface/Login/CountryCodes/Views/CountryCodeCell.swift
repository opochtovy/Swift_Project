//
//  CountryCodeCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {
    
    static let reuseID: String = "CountryCodeCell"
    static let cellHeight: CGFloat = 44
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var selectCellImageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    public weak var viewModel: CountryCodeCellVM! {
        
        didSet {
            
            self.codeLabel.text = viewModel.codeName
            self.countryLabel.text = viewModel.countryName
        }
    }
    
    public var isCellSelected: Bool = true {
        
        didSet {
            
            self.selectCellImageView.image = isCellSelected ? #imageLiteral(resourceName: "selectCountryCodeButton-on").imageWithColor(color: #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)) : #imageLiteral(resourceName: "selectCountryCodeButton-off")
        }
    }

    override func awakeFromNib() {
        
        super.awakeFromNib()
    }    
}
