//
//  PictureVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PictureVC: ViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet private weak var cvPictures: UICollectionView!    
    @IBOutlet private weak var btnTakePhoto: ChoosePictureButton!
    @IBOutlet private weak var btnRandomPhoto: ChoosePictureButton!
    @IBOutlet private weak var vAccessAlert: AccessAlertView!
    
    private lazy var imagePicker: UIImagePickerController = {
        
        let ctrl = UIImagePickerController.init()
        ctrl.sourceType = .camera
        ctrl.delegate = self
        return ctrl
    }()
    
    private let viewModel: PictureVM
    
    init(client: Client, viewModel: PictureVM) {
        
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvPictures.register(UINib.init(nibName: "PictureCell", bundle: nil), forCellWithReuseIdentifier: PictureCell.reuseID)
        self.title = NSLocalizedString("Picture_choose_photo", comment: "")

        self.btnTakePhoto.lbTitle.text = ""
        self.btnTakePhoto.ivButton.image = #imageLiteral(resourceName: "iconTakePhoto")
        self.btnTakePhoto.lbDetails.text = NSLocalizedString("Picture_take_new_photo", comment: "")

        self.btnRandomPhoto.lbTitle.text = NSLocalizedString("Picture_surprise_me", comment: "")
        self.btnRandomPhoto.ivButton.image = #imageLiteral(resourceName: "iconRandomPhoto")
        self.btnRandomPhoto.lbDetails.text = NSLocalizedString("Picture_get_random_photo", comment: "")
        
        self.vAccessAlert.btnAskAccess.addTarget(self, action: #selector(PictureVC.didPressEnableLibraryAccess(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContent()
    }
    
    //MARK: - Actions
    
    @IBAction private func didPressSeeAll(_ sender: UIButton) {
        
    }
    
    @IBAction private func didPressTakeNewPhoto(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        self.present(self.imagePicker, animated: true) {
         
            self.updateContent()
        }
    }
    
    @IBAction private func didPressSurpriseMe(_ sender: UIButton) {
        
        self.viewModel.chooseRandomImage() //may be completion needed?
    }
    
    @IBAction private func didPressEnableLibraryAccess(_ sender: UIButton) {
        
        PhotoLibraryManager.shared.requestAccess { (success) in
            
            if success {
                
                DispatchQueue.main.async {
                    
                    self.updateContent()
                }
            }
        }
    }
    //MARK: - Private functions
    
    private func updateContent () {
        
        if self.viewModel.accessAllowed == true {
            
            self.vAccessAlert.isHidden = true
            self.cvPictures.isHidden = false
            self.viewModel.prepareModel()
            self.cvPictures.reloadData()
        }
        else {
            
            self.vAccessAlert.isHidden = false
            self.cvPictures.isHidden = true
        }
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseID, for: indexPath) as! PictureCell
        cell.viewModel = self.viewModel.getPictureCellVM(forIndexPath: indexPath)
        
        return cell
    }
    
    //MARK: - UICollectionViewDataSource
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.viewModel.chosenImageData = UIImageJPEGRepresentation(image, 1.0)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.viewModel.chooseImage(atIndexPath: indexPath)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
