//
//  FriendDetailVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/27/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class FriendDetailVC: ViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var lbUsername: UILabel!
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var lbPhone: UILabel!
    @IBOutlet private weak var cvHaikus: UICollectionView!

    private let viewModel: FriendDetailVM
    
    init(client: Client, viewModel: FriendDetailVM) {
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cvHaikus.register(UINib.init(nibName: "FriendHaikuCell", bundle: nil), forCellWithReuseIdentifier: FriendHaikuCell.reuseID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setBarAppearance()
        
        self.viewModel.getUserData { (success, error) in
            
            self.updateContent()
        }
    }
    
    //MARK: - Private functions
    
    private func updateContent() {
        
        if let url = self.viewModel.userAvatarURL {

            self.ivUser.af_setImage(withURL: url)
        }
        else {

            self.ivUser.image = Placeholders.profile.getRandom()
        }

        self.lbUsername.text = self.viewModel.userName
        self.lbPhone.text = self.viewModel.phoneNumber
        self.cvHaikus.reloadData()
    }
    
    private func setBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = UIColor.clear
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberIfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendHaikuCell.reuseID, for: indexPath) as! FriendHaikuCell
        cell.viewModel = self.viewModel.getFriendHaikuCellVM(forIndexPath: indexPath)
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let ctrl = BazarDetailVC(client: self.client, viewModel: self.viewModel.getHaikuDetailVM(forIndexPath: indexPath))
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let side = (collectionView.bounds.width - spacing) / 2
        let rect = CGSize(width: side, height: side)
        return rect
        
    }
}
