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
    @IBOutlet weak var ivWaterMark: UIImageView!
    
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
    
    public func getImageToShare() -> UIImage? {
        
        return self.ivHaiku.image
    }
    
    public func textToImage() -> UIImage {
        
        let inImage = self.ivHaiku.image ?? UIImage()
//        self.saveImageToFile1(anImage: inImage)
        let imageScale = inImage.size.height / self.view.frame.height
        
        // Setup the font specific variables
        let textColor = UIColor.init(hex: self.viewModel.fontHexColor)// UIColor.white
        let fontSize = CGFloat(self.viewModel.fontSize) * imageScale
        let textFont: UIFont = UIFont(name: self.viewModel.fontfamilyName, size: fontSize)!
        
        //Put the image into a rectangle as large as the original image.
        let rect: CGRect = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        
        inImage.draw(in: rect)
        
        //Now Draw the text into an image.
        let label = UILabel(frame: rect)
        label.font = textFont
        
        // 1st line
        var drawText = self.lbField1.text
        label.text = drawText
        label.sizeToFit()
        var labelTop = 90 * imageScale
        var labelWidth = label.bounds.size.width
        let labelHeight = label.bounds.size.height
        let labelsVertSpacing = 15 * imageScale
        if let drawText = drawText {
            drawText.draw(in: CGRect(x: (inImage.size.width - labelWidth) / 2, y: labelTop, width: labelWidth, height: labelHeight), withAttributes: textFontAttributes)
        }
        
        // 2nd line
        drawText = self.lbField2.text
        label.text = drawText
        label.sizeToFit()
        labelTop = labelTop + labelHeight + labelsVertSpacing
        labelWidth = label.bounds.size.width
        if let drawText = drawText {
            drawText.draw(in: CGRect(x: (inImage.size.width - labelWidth) / 2, y: labelTop, width: labelWidth, height: labelHeight), withAttributes: textFontAttributes)
        }
        
        // 3rd line
        drawText = self.lbField3.text
        label.text = drawText
        label.sizeToFit()
        labelTop = labelTop + labelHeight + labelsVertSpacing
        labelWidth = label.bounds.size.width
        if let drawText = drawText {
            drawText.draw(in: CGRect(x: (inImage.size.width - labelWidth) / 2, y: labelTop, width: labelWidth, height: labelHeight), withAttributes: textFontAttributes)
        }
        
        if let waterMarkImage = self.ivWaterMark.image {
            let width = (waterMarkImage.size.width / self.view.bounds.width) * inImage.size.width
            let height = (waterMarkImage.size.height / self.view.bounds.height) * inImage.size.height
            let bottomMargin = 17 * imageScale
            waterMarkImage.draw(in: CGRect(x: (inImage.size.width - width) / 2, y: (inImage.size.height - bottomMargin - height), width: width, height: height))
        }
        
        // Create a new image out of the images we have created
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage ?? UIImage()
    }
/*
    // after drawing
    public func saveImageToFile(anImage: UIImage) {
        
        if let data = UIImageJPEGRepresentation(anImage, 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("kubazar_image_copy.png")
            try? data.write(to: filename)
        }
    }
    
    public func saveImageToFile1(anImage: UIImage) {
        
        if let data = UIImageJPEGRepresentation(anImage, 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("kubazar_image_copy1.png")
            try? data.write(to: filename)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("file path = ", paths[0])
        return paths[0]
    }
*/
    public func imageWithHaiku() -> UIImage? {
        
        let inImage = self.ivHaiku.image ?? UIImage()
//        self.saveImageToFile1(anImage: inImage)
        
        self.ivWaterMark.isHidden = false
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.ivWaterMark.isHidden = true        
        return img
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
