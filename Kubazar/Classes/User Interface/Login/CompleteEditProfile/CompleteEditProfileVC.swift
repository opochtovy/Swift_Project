//
//  CompleteEditProfileVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD

class CompleteEditProfileVC: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    static let shortUsernameAlertTitle = "CompleteEditProfileVC_shortUsernameAlertTitle"
    static let shortUsernameAlertMessage = "CompleteEditProfileVC_shortUsernameAlertMessage"
    static let emptyPhotoAlertTitle = "CompleteEditProfileVC_emptyPhotoAlertTitle"
    static let emptyPhotoAlertMessage = "CompleteEditProfileVC_emptyPhotoAlertMessage"
    static let unsuccessfulDisplayNameUpdateAlertTitle = "CompleteEditProfileVC_unsuccessDisplayNameUpdateAlertTitle"
    static let unsuccessfulDisplayNameUpdateAlertMessage = "CompleteEditProfileVC_unsuccessDisplayNameUpdateAlertMessage"
    static let unsuccessfulPhotoUploadAlertTitle = "CompleteEditProfileVC_unsuccessfulPhotoUploadAlertTitle"
    static let unsuccessfulPhotoUploadAlertMessage = "CompleteEditProfileVC_unsuccessfulPhotoUploadAlertMessage"
    
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
        
        self.edgesForExtendedLayout = []
        
        self.localizeTitles()
        self.setNavigationBarAppearance()
        self.usernameTextField.becomeFirstResponder()
        
        self.profileImageView.addCornerRadius(cornerRadius: self.profileImageView.frame.size.width / 2, borderWidth: 1, borderColor: #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1))
        self.profileImageView.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
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
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title"), style: .plain, target: self, action: #selector(CompleteEditProfileVC.done))
    }
    
    private func showShortUsernameAlert() {
        
        let alertTitle = NSLocalizedString(CompleteEditProfileVC.shortUsernameAlertTitle, comment: "Title for short username alert on Complete Edit Profile")
        let alertMessage = NSLocalizedString(CompleteEditProfileVC.shortUsernameAlertMessage, comment: "Message for short username alert on Complete Edit Profile")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Complete Edit Profile"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showEmptyPhotoAlert() {
        
        let alertTitle = NSLocalizedString(CompleteEditProfileVC.emptyPhotoAlertTitle, comment: "Title for empty photo alert on Complete Edit Profile")
        let alertMessage = NSLocalizedString(CompleteEditProfileVC.emptyPhotoAlertMessage, comment: "Message for empty photo alert on Complete Edit Profile")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Complete Edit Profile"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showUnsuccessfulDisplayNameUpdateAlert() {
        
        let alertTitle = NSLocalizedString(CompleteEditProfileVC.unsuccessfulDisplayNameUpdateAlertTitle, comment: "Title for unsuccessful displayName update alert on Complete Edit Profile")
        let alertMessage = NSLocalizedString(CompleteEditProfileVC.unsuccessfulDisplayNameUpdateAlertMessage, comment: "Message for unsuccessful displayName update alert on Complete Edit Profile")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Complete Edit Profile"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showUnsuccessfulPhotoUploadAlert() {
        
        let alertTitle = NSLocalizedString(CompleteEditProfileVC.unsuccessfulPhotoUploadAlertTitle, comment: "Title for unsuccessful photo upload alert on Complete Edit Profile")
        let alertMessage = NSLocalizedString(CompleteEditProfileVC.unsuccessfulPhotoUploadAlertMessage, comment: "Message for unsuccessful photo upload alert on Complete Edit Profile")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Complete Edit Profile"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func createProfileChangeRequest(displayName: String, photoURL: URL?) {
        
        self.client.authenticator.createProfileChangeRequest(displayName: displayName, photoURL: photoURL, completionHandler: { errorDescription, success in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if !success {
                
                self.showWrongResponseAlert(message: errorDescription)
                
            } else {
                
                self.client.authenticator.state = .authorized
            }
        })
    }
    
    //MARK: - Actions
    
    @objc private func done() {
        
        if let username = self.usernameTextField.text {
            
            if username.count < 3 {
                
                self.showShortUsernameAlert()
                return
                
            }
            
            var photoData = Data()
            if let photo = self.profileImageView.image {
                
                photoData = UIImageJPEGRepresentation(photo, 1.0)!
            }
            if photoData.count == 0 {
                
//                self.showEmptyPhotoAlert()
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.createProfileChangeRequest(displayName: username, photoURL: nil)
                return
            }
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.client.authenticator.uploadPhotoToUserProfile(displayName: username, photoData: photoData, completionHandler: { downloadURL, uploadSuccess in
                
                if !uploadSuccess {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showUnsuccessfulPhotoUploadAlert()
                    
                } else {
                    
                    self.createProfileChangeRequest(displayName: username, photoURL: downloadURL)
                }
            })
        }
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
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    //MARK: - IBActions
    
    @IBAction private func actionAddPhoto(_ sender: UIButton) {
        
        self.usernameTextField.resignFirstResponder()
        
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}
