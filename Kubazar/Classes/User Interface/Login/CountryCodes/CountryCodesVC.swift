//
//  CountryCodesVC.swift
//  Kubazar
//
//  Created by Oleg Pochtovy on 12.11.17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

protocol CountryCodesVCDelegate : class {
    
    func backButtonWasPressed(vc: CountryCodesVC, code: String, country: String)
}

class CountryCodesVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let titleText = "CountryCodesVC_title"
    
    var viewModel: CountryCodesVM
    
    @IBOutlet private var tableView: UITableView!
    
    weak var delegate: CountryCodesVCDelegate?
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = CountryCodesVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarAppearance()
        self.localizeTitles()
        
        if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
            
            self.viewModel.getCountryCodes(path: path)
        }
        
        self.tableView?.register(UINib.init(nibName: CountryCodeCell.reuseID, bundle: nil), forCellReuseIdentifier: CountryCodeCell.reuseID)
        self.tableView?.estimatedRowHeight = CountryCodeCell.cellHeight
    }
    
    //MARK: - Private functions
    
    private func setNavigationBarAppearance() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.backButtonTitle, comment: ""), style: .plain, target: self, action: #selector(CountryCodesVC.cancel))
    }
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(CountryCodesVC.titleText, comment: "")
    }

    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfCountryCodes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryCodeCell.reuseID, for: indexPath) as! CountryCodeCell
        cell.viewModel = self.viewModel.getCellVM(forIndexPath: indexPath)
        cell.isCellSelected = indexPath.row == self.viewModel.selectedIndex
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let previousIndex = self.viewModel.selectedIndex
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.selectedIndex = indexPath.row
        
        if previousIndex >= 0, previousIndex < self.viewModel.numberOfCountryCodes() {
            
            let previousIndexPath = IndexPath(row: previousIndex, section: indexPath.section)
            let previousCell = self.tableView.cellForRow(at: previousIndexPath) as? CountryCodeCell
            if let previousCell = previousCell {
                
                previousCell.isCellSelected = false
            }
        }
        
        let cell = self.tableView.cellForRow(at: indexPath) as! CountryCodeCell
        cell.isCellSelected = true
        
    }
    
    @objc private func cancel() {
        
        let selectedIndex = self.viewModel.selectedIndex
        if selectedIndex >= 0, selectedIndex < self.viewModel.numberOfCountryCodes() {
            
            let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
            let vm = self.viewModel.getCellVM(forIndexPath: selectedIndexPath)
            self.delegate?.backButtonWasPressed(vc: self, code: vm.codeName, country: vm.countryName)
        }
        
        if let navigationController = self.navigationController {
            
            navigationController.popViewController(animated: true)
        }
    }
}
