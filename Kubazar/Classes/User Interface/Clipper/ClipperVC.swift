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
    
    @IBOutlet fileprivate weak var vClipFrame: UIView!
    
    @IBOutlet private weak var cstrImageViewTop: NSLayoutConstraint!
    @IBOutlet private weak var cstrImageViewBottom: NSLayoutConstraint!
    
    
    
    private let viewModel: ClipperVM
    
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
        //self.imageView = UIImageView(frame: UIScreen.main.bounds)
        self.imageView.image = UIImage(data: self.viewModel.imageData)
        //self.imageView.contentMode = .scaleAspectFill
        //self.scrollView.addSubview(self.imageView)
        //self.scrollView.contentSize = self.imageView.image!.size
        self.scrollView.contentInset = UIEdgeInsetsMake(150, 0, 150, 0)
        

    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        //let widthScale = size.width / imageView.image!.size.width
        let heightScale = size.height / imageView.image!.size.height
//        let minScale = min(widthScale, heightScale)
//
        scrollView.minimumZoomScale = heightScale//minScale
        scrollView.maximumZoomScale = 10
        scrollView.zoomScale = heightScale
//
        
        
        print("updateMinZoomScaleForSize")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(view.bounds.size)
        self.scrollView.zoom(to: self.view.frame, animated: true)
        let newContentOffsetX = (scrollView.contentSize.width/2) - (scrollView.bounds.size.width/2)
        let newContentOffsetY = (scrollView.contentSize.height/2) - (scrollView.bounds.size.height/2)
        self.scrollView.contentOffset = CGPoint(x: newContentOffsetX, y: newContentOffsetY)
        
    }
    
    func updateImageViewContstraints() {
        
    }
    
    fileprivate var isZoomed = false
}

extension ClipperVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        
        print(scrollView.contentSize)
        //print(scrollView.zoomScale)
        return imageView
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.updateImageViewContstraints()
//    }
    
}
