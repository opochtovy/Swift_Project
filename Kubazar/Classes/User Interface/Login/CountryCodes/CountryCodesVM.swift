//
//  CountryCodesVM.swift
//  Kubazar
//
//  Created by Oleg Pochtovy on 12.11.17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class CountryCodesVM: BaseVM {
    
    public var countryCodeCellVMs: [CountryCodeCellVM]
    public var selectedIndex: Int = -1
    
    override init(client: Client) {
        
        self.countryCodeCellVMs = [CountryCodeCellVM]()
        super.init(client: client)
    }
    
    //MARK: - Public functions
    
    public func getCellVM(forIndexPath indexPath: IndexPath) -> CountryCodeCellVM {

        return self.countryCodeCellVMs[indexPath.row]
    }
    
    public func getCountryCodes(path: String) {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let countries = jsonResult["countries"] as? [Dictionary<String, String>] {
                
                for country in countries {
                    
                    if let key = country["name"], let value = country["code"] {
                        
                        self.countryCodeCellVMs.append(CountryCodeCellVM(code: value, country: key))
                    }
                }
            }
        } catch { }
    }
    
    public func numberOfCountryCodes() -> Int {
        
        return self.countryCodeCellVMs.count
    }
}
