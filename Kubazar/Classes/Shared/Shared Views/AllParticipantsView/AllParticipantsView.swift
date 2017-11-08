//
//  AllParticipantsView.swift
//  Kubazar
//
//  Created by Oleg Pochtovy on 07.11.17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

protocol AllParticipantsViewDataSource : class {
    
    func titlesForAllParticipants(view: AllParticipantsView) -> [String]
}

class AllParticipantsView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    public weak var dataSource: AllParticipantsViewDataSource? {
        
        didSet {
            drawParticipantsCountViews()
        }
    }
    
    private var participantsCountViews = [ParticipantsCountView]()
    
    //MARK: - LyfeCycle
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    // MARK: - Public Functions
    
    public func countOfAllParticipants() -> Int {
        
        return self.participantsCountViews.count
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        
        self.view = loadViewFromNib()
        addSubview(self.view)
        self.view.frame = self.bounds
        self.drawParticipantsCountViews()
    }
    
    private func drawParticipantsCountViews() {
        
        guard let dataSource = self.dataSource else { return }
        let titles = dataSource.titlesForAllParticipants(view: self)
        for view in self.participantsCountViews {
            self.stackView.removeArrangedSubview(view)
        }
        self.participantsCountViews.removeAll()
        
        var index : CGFloat = 0
        for buttonTitle in titles {
            
            let participantsCountView = ParticipantsCountView()
            var image: UIImage = UIImage()
            switch index {
                
            case 0:
                if let anImage = UIImage(named: TabBarImages.bazar) {
                    image = anImage
                }
            case 1:
                if let anImage = UIImage(named: TabBarImages.write) {
                    image = anImage
                }
            case 2:
                if let anImage = UIImage(named: TabBarImages.write) {
                    image = anImage
                }
            default: break
            }
            participantsCountView.participantImageView.image = image
            
            participantsCountView.tag = Int(index)
            participantsCountView.participantButton.setTitle(buttonTitle as String, for: .normal)
            participantsCountView.participantButton.addTarget(self, action: #selector(didPressParticipantButton(sender:)), for: .touchUpInside)
            participantsCountView.participantButton.tag = Int(index)
            
            self.stackView.addArrangedSubview(participantsCountView)
            self.participantsCountViews.append(participantsCountView)
            
            index += 1
        }
    }
    
    // MARK: -  Actions
    
    @objc private func didPressParticipantButton(sender: UIButton) {
        
//        self.currentIndex = sender.tag
//        self.selectItem(atIndex: sender.tag)
    }

}
