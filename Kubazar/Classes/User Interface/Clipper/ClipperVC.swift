//
//  ClipperVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ClipperVC: ViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var vClipFrame: UIView!
    @IBOutlet private weak var ivCroped: UIImageView!
    
    private var btnCrop: UIBarButtonItem!
    private var btnReset: UIBarButtonItem!
    private var btnContinue: UIBarButtonItem!
    
    private let viewModel: ClipperVM
    
    //MARK: - LifeCycle
    
    init(client: Client, viewModel: ClipperVM) {
        
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.imageView.image = UIImage(data: self.viewModel.imageData)
        
        self.btnCrop = UIBarButtonItem(title: NSLocalizedString("Clipper_crop", comment: ""), style: .plain, target: self, action: #selector(ClipperVC.didPressCropImage(_:)))
        self.btnReset = UIBarButtonItem(title: NSLocalizedString("Clipper_reset", comment: ""), style: .plain, target: self, action: #selector(ClipperVC.didPressResetButton(_:)))
        self.btnContinue = UIBarButtonItem(title: NSLocalizedString("Picture_continue", comment: ""), style: .plain, target: self, action: #selector(ClipperVC.didPressContinueButton(_:)))
        
        
        self.vClipFrame.layer.cornerRadius = 4.0
        self.imageView.alpha = 0.0
        
        self.updateContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let insetValue = (self.scrollView.bounds.height - self.vClipFrame.bounds.height) / 2
        self.scrollView.contentInset = UIEdgeInsetsMake(insetValue, 0, insetValue, 0)
        
        UIView.animate(withDuration: 0.3) {
            
            self.imageView.alpha = 1.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    //MARK: - Private functions
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        
        guard let image = self.imageView.image else { return }
        
        let widthScale = size.width / image.size.width
        let heightScale = size.height / image.size.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func updateContent() {
        
        if self.ivCroped?.image == nil {
           
            self.navigationItem.rightBarButtonItems = [self.btnCrop]
            
            self.ivCroped.isHidden = true
            self.scrollView.isHidden = false
        }
        else {
            
            self.navigationItem.rightBarButtonItems = [self.btnContinue , self.btnReset]
            
            self.ivCroped.isHidden = false
            self.scrollView.isHidden = true
        }
    }
    
    private func cropImage() {
        
        guard let image = imageView.image else { return }
        
        let clipViewRect = self.vClipFrame.bounds
        let scaleMultiplier = 1 / self.scrollView.zoomScale
        let verticalInset = self.scrollView.contentInset.top
        
        let cropOrigin = CGPoint(x: self.scrollView.contentOffset.x * scaleMultiplier,
                                 y: (self.scrollView.contentOffset.y + verticalInset) * scaleMultiplier)
        
        let cropRect = CGRect(origin: cropOrigin,
                              size: CGSize(width: clipViewRect.width * scaleMultiplier,
                                           height: clipViewRect.height * scaleMultiplier))
        
        if let cropedImafeRef = image.cgImage?.cropping(to: cropRect) {
            
            let resultImage: UIImage = UIImage.init(cgImage: cropedImafeRef)
            
            self.ivCroped.image = resultImage
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func didPressCropImage(_ sender: Any) {
        
        self.cropImage()
        self.updateContent()
    }
    
    @IBAction private func didPressResetButton(_ sender: Any) {
    
        self.ivCroped.image = nil
        self.updateContent()
    }
    
    @IBAction private func didPressContinueButton(_ sender: Any) {
        
        let ctrl = EditorVC(client: self.client, viewModel: self.viewModel.getEditorVM())
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
}

extension ClipperVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return imageView
    }
}
