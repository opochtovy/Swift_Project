//
//  PictureVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PictureVC: ViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private enum Constants {
        
        static let numberOfItemsInRow : CGFloat = 3
        static let numberOfItemsInSection : CGFloat = 2
    }
    
    @IBOutlet private weak var cvPictures: UICollectionView!
    @IBOutlet private weak var btnSeeAll: UIButton!
    @IBOutlet private weak var btnTakePhoto: ChoosePictureButton!
    @IBOutlet private weak var btnRandomPhoto: ChoosePictureButton!
    @IBOutlet private weak var vAccessAlert: AccessAlertView!
    @IBOutlet weak var cnstrLeftToPictures: NSLayoutConstraint!
    @IBOutlet weak var cnstrCollectionContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstrCollectionContainerToBottom: NSLayoutConstraint!
    
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
        
        self.edgesForExtendedLayout = []
        self.cvPictures.register(UINib.init(nibName: "PictureCell", bundle: nil), forCellWithReuseIdentifier: PictureCell.reuseID)
        self.title = NSLocalizedString("Picture_choose_photo", comment: "")

        //-- mock start
        let barButtonContinue = UIBarButtonItem(title: "Continue", style: .plain, target: self, action: #selector(PictureVC.didPressContinueButton(_:)))
        self.navigationItem.rightBarButtonItem = barButtonContinue
        //-- mock end
        
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
    
    //-- mock start
    @IBAction private func didPressContinueButton(_ sender: UIButton) {
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        //TODO: add check image
        let ctrl = EditorVC(client: self.client, viewModel: self.viewModel.getEditorVM())
        ctrl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    //-- mock end
    
    @IBAction private func didPressSeeAll(_ sender: UIButton) {
        
        self.viewModel.isCollectionExpanded = !self.viewModel.isCollectionExpanded
        
        self.updateCollectionViewSize()
    }
    
    @IBAction private func didPressTakeNewPhoto(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
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
        
        self.updateCollectionViewSize()
    }
    
    private func updateCollectionViewSize() {

        if self.viewModel.isCollectionExpanded == false {
            
            let layout = self.cvPictures.collectionViewLayout as! UICollectionViewFlowLayout
            let cellHeight = self.collectionView(self.cvPictures, layout: layout, sizeForItemAt: IndexPath(row: 0, section: 0)).height
                
            self.cnstrCollectionContainerHeight.constant = cellHeight * Constants.numberOfItemsInSection + layout.minimumInteritemSpacing * (Constants.numberOfItemsInSection - 1)
            self.cnstrCollectionContainerHeight.priority = UILayoutPriority(900.0)
            self.cnstrCollectionContainerToBottom.priority = UILayoutPriority(500.0)
            
            self.cvPictures.isScrollEnabled = false
            self.btnTakePhoto.isHidden = false
            self.btnRandomPhoto.isHidden = false
            
            self.btnSeeAll.setTitle(NSLocalizedString("Picture_see_all", comment: ""), for: .normal)
            self.cvPictures.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        else {
   
            self.cnstrCollectionContainerHeight.priority = UILayoutPriority(500.0)
            self.cnstrCollectionContainerToBottom.priority = UILayoutPriority(900.0)
            
            self.cvPictures.isScrollEnabled = true
            self.btnTakePhoto.isHidden = true
            self.btnRandomPhoto.isHidden = true
            
            self.btnSeeAll.setTitle(NSLocalizedString("Picture_collapse", comment: ""), for: .normal)
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
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.viewModel.chooseImage(atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interItemSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let side: CGFloat = (UIScreen.main.bounds.width - interItemSpacing * (Constants.numberOfItemsInRow - 1) - self.cnstrLeftToPictures.constant * 2) / Constants.numberOfItemsInRow
        return CGSize(width: side, height: side)
    }
    
    //MARK: - UICollectionViewDataSource
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.viewModel.chosenImageData = UIImageJPEGRepresentation(image, 1.0)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
