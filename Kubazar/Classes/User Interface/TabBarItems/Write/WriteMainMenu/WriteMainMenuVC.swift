//
//  WriteMainMenuVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class WriteMainMenuVC: ViewController {
    
    var viewModel: WriteMainMenuVM
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    private var participantsCountViews = [ParticipantsCountView]()

    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = WriteMainMenuVM(client: client)
        super.init(client: client)
        
        self.drawParticipantsCountViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        self.drawParticipantsCountViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localizeTitles()
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(WriteMainMenuTitles.title, comment: "Title for Write Main Menu")
        
        self.headerLabel.text = NSLocalizedString(WriteMainMenuTitles.headerLabel, comment: "Header title").uppercased()
    }
    
    private func drawParticipantsCountViews() {
        let titles = ["1", "1"]
        for view in self.participantsCountViews {
            self.stackView.removeArrangedSubview(view)
        }
        self.participantsCountViews.removeAll()
        
        var index : CGFloat = 0
        for item in titles {
            
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
            default: break
            }
            participantsCountView.participantImageView.image = image
            participantsCountView.participantButton.setTitle(item as String, for: .normal)
            participantsCountView.tag = Int(index)
            participantsCountView.participantButton.tag = Int(index)
            participantsCountView.participantButton.addTarget(self, action: #selector(didPressParticipantButton(sender:)), for: .touchUpInside)
            
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
