//
//  CompleteEditProfileVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class CompleteEditProfileVC: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let imagePickerMinSide: CGFloat = 200
    
    var viewModel: CompleteEditProfileVM
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    lazy private var imagePicker: UIImagePickerController = {

        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self

        return picker
    }()
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = CompleteEditProfileVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localizeTitles()
        self.setNavigationBarAppearance()
        self.usernameTextField.becomeFirstResponder()
        
        self.profileImageView.addCornerRadius(cornerRadius: self.profileImageView.frame.size.width / 2, borderWidth: 1, borderColor: #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1))
        self.profileImageView.clipsToBounds = true
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(StartEditProfileTitles.title, comment: "Title for Edit Profile")
        
        self.descriptionLabel.text = NSLocalizedString(CompleteEditProfileTitles.descriptionLabel, comment: "Description on Edit Profile")
        self.usernameLabel.text = NSLocalizedString(CompleteEditProfileTitles.usernameLabel, comment: "Username Label on Edit Profile")
        self.profileLabel.text = NSLocalizedString(CompleteEditProfileTitles.profileLabel, comment: "Profile Picture Label on Edit Profile")
        
        self.usernameTextField.placeholder = NSLocalizedString(SignInTitles.usernamePlaceholder, comment: "Placelholder for Username TextField")
    }
    
    private func setNavigationBarAppearance() {
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title"), style: .plain, target: self, action: #selector(CompleteEditProfileVC.done))
    }
    
    @objc private func done() {
        
    }

    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let size = pickedImage.size
            let minSide = min(size.width, size.height)
            var scale: CGFloat = 1
            while minSide / scale > CompleteEditProfileVC.imagePickerMinSide {
                
                scale = scale + 0.2
            }
            
            if let editedImage = UIImage().resizePhoto(image: pickedImage, scale: scale) {
                
                self.profileImageView.image = editedImage
            }
        }
        
        self.profileLabel.isHidden = self.profileImageView.image != nil
        
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.profileLabel.isHidden = self.profileImageView.image != nil
        
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - Actions
    
    @IBAction private func actionAddPhoto(_ sender: UIButton) {
        
        self.usernameTextField.resignFirstResponder()
        
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}
