//
//  CountryCodeCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class CountryCodeCellVM {
    
    private(set) var codeName: String = ""
    private(set) var countryName: String = ""
    
    init(code: String, country: String) {
        
        codeName = code
        countryName = country
    }

}
