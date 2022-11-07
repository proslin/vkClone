//
//  AvatarView.swift
//  vkClient
//
//  Created by Lina Prosvetova on 10.10.2022.
//

import UIKit

class AvatarView: UIView {
    
    var imageView: UIImageView!
    
    private func setupView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let image = UIImage(named: "cat")
        imageView.image = image
        self.addSubview(imageView)
        
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
}
