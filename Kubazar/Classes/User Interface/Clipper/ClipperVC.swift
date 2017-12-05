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
    private var btnDone: UIBarButtonItem!
    
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
        
        self.title = NSLocalizedString("Clipper_edit_photo", comment: "")
        self.imageView.image = UIImage(data: self.viewModel.imageData)

        self.btnDone = UIBarButtonItem(title: NSLocalizedString("Picture_continue", comment: ""), style: .plain, target: self, action: #selector(ClipperVC.didPressDoneButton(_:)))
        self.navigationItem.rightBarButtonItem = self.btnDone
        
        let btnCancel = UIBarButtonItem(title: NSLocalizedString("ButtonTitles_cancelButtonTitle", comment: ""), style: .plain, target: self, action: #selector(ClipperVC.didPressCancelButton(_:)))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btnCancel
        
        self.imageView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let insetVertical: CGFloat = (self.scrollView.bounds.height - self.vClipFrame.bounds.height) / 2
        let insetHorizontal: CGFloat = 5.0
        
        self.scrollView.contentInset = UIEdgeInsetsMake(insetVertical, insetHorizontal, insetVertical, insetHorizontal)
        
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
    
    private func cropImage() {
        
        guard let image = imageView.image else { return }
        
        let resImage = image.fixedOrientation()
        
        let clipViewRect = self.vClipFrame.bounds
        let scaleMultiplier = 1 / self.scrollView.zoomScale
        let verticalInset = self.scrollView.contentInset.top
        let horizontalInset = self.scrollView.contentInset.left
        
        let cropOrigin = CGPoint(x: (self.scrollView.contentOffset.x + horizontalInset) * scaleMultiplier,
                                 y: (self.scrollView.contentOffset.y + verticalInset) * scaleMultiplier)
        
        let cropRect = CGRect(origin: cropOrigin,
                              size: CGSize(width: clipViewRect.width * scaleMultiplier,
                                           height: clipViewRect.height * scaleMultiplier))
        
        if let cropedImafeRef = resImage.cgImage?.cropping(to: cropRect) {
            
            let resultImage: UIImage = UIImage.init(cgImage: cropedImafeRef)
            self.viewModel.cropedImageData = UIImageJPEGRepresentation(resultImage, 1.0)
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func didPressDoneButton(_ sender: Any) {
        
        self.cropImage()
        
        if self.viewModel.cropedImageData != nil {
            
            let ctrl = EditorVC(client: self.client, viewModel: self.viewModel.getEditorVM())
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        else {
            
            print("unExpected clipper error")
        }
    }
    
    @IBAction private func didPressCancelButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension ClipperVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return imageView
    }
}
