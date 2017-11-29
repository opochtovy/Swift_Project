//
//  HaikuPreview.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import AlamofireImage

class HaikuPreview: UIView {
    
    static let placeholder = Placeholders.haiku.getRandom()
    
    @IBOutlet private weak var view: UIView!
    
    @IBOutlet private weak var ivHaiku: UIImageView!
    @IBOutlet private weak var lbField1: UILabel!
    @IBOutlet private weak var lbField2: UILabel!
    @IBOutlet private weak var lbField3: UILabel!
    
    private var gradient: CAGradientLayer?
    
    private let imageCache = AutoPurgingImageCache()
    private let downloader = ImageDownloader()
    
    public var viewModel: HaikuPreviewVM! {
        didSet {
            
            let color : UIColor = UIColor(hex: viewModel.fontHexColor)
            let font = UIFont(name: self.viewModel.fontfamilyName, size: CGFloat(self.viewModel.fontSize))

            self.lbField1.textColor = color
            self.lbField2.textColor = color
            self.lbField3.textColor = color
            
            self.lbField1.text = viewModel.field1
            self.lbField2.text = viewModel.field2
            self.lbField3.text = viewModel.field3
            
            self.lbField1.font = font
            self.lbField2.font = font
            self.lbField3.font = font
            
            self.ivHaiku.image = nil
            
            if let url = viewModel.haikuPictureURL {
                
                self.ivHaiku.af_setImage(withURL: url, placeholderImage: HaikuPreview.placeholder, imageTransition: .crossDissolve(0.2))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.addGradient()
    }    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradientFrame()        
    }
    
    override func draw(_ rect: CGRect) {
        self.view.frame = self.bounds
        self.updateGradientFrame()
    }
    
    //MARK: Public functions
    
    public func setImageForHaikuPreview(imageURL: URL) {
        
//        self.ivHaiku.image = image == nil ? UIImage(named:"testProfileImage") : image
        self.ivHaiku.image = nil
        if let cachedImage = self.imageCache.image(withIdentifier: imageURL.absoluteString) {
            
            self.ivHaiku.image = cachedImage
        
        } else {
            
//            self.ivHaiku.af_setImage(withURL: imageURL)
            let urlRequest = URLRequest(url: imageURL)
            self.downloader.download(urlRequest) { response in
                
                if let image = response.result.value {
                    
                    self.ivHaiku.image = image
                    self.imageCache.add(image, withIdentifier: imageURL.absoluteString)
                }
            }
        }
    }
    
    public func isImageNil() -> Bool {
        
        return self.ivHaiku.image == nil
    }
    
    //MARK: Private functions
    
    private func setup() {
        
        self.ivHaiku.layer.cornerRadius = 5.0
        self.ivHaiku.layer.masksToBounds = true
    }
    
    private func addGradient() {
        
        let gradients = self.ivHaiku.layer.sublayers?.filter { $0 is CAGradientLayer}
        
        guard gradients == nil || gradients?.count == 0 else { return }
        
        let firstColor = UIColor.clear.cgColor
        let secondColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        let colors = [firstColor,
                      firstColor,
                      firstColor,
                      firstColor,
                      secondColor]
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.ivHaiku.bounds
        gradientLayer.colors = colors;
        
        gradientLayer.locations = [0.0,
                                   0.24,
                                   0.5,
                                   0.73,
                                   1.0]
        
        self.ivHaiku.layer.insertSublayer(gradientLayer, at: UInt32(self.ivHaiku.layer.sublayers?.count ?? 0))
        
        self.gradient = gradientLayer
    }
    
    private func updateGradientFrame() {
        
        self.ivHaiku.frame = self.bounds
        self.gradient?.frame = self.ivHaiku.bounds
    }
}
