//
//  ParticipantsCountView.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

protocol ParticipantsCountViewDelegate : class {
    
    func participantsCountViewWasPressed(view: ParticipantsCountView)
}

class ParticipantsCountView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var participantImageView: UIImageView!
    @IBOutlet weak var participantButton: UIButton!
    
    weak var delegate: ParticipantsCountViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.view = loadViewFromNib()
        addSubview(self.view)
        self.view.frame = bounds
        
        self.contentView.dropShadow()
        self.contentView.addCornerRadius(cornerRadius: 5.0, borderWidth: 0.5, borderColor: UIColor.lightGray)
    }
}
