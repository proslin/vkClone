//
//  FriendCellXib.swift
//  vkClient
//
//  Created by Lina Prosvetova on 07.10.2022.
//

import UIKit

class FriendCellXib: UITableViewCell {
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func set(friend: Friend) {
        friendName.text = friend.firstName + friend.lastName
        friendName.textColor = VKColors.labelColor
        //guard let avatarImage = avatarView.imageView.image else { return }
            // avatarView.imageView.image = UIImage(named: friend.friendAvatarURL)
        NetworkManager.shared.downloadAvatar(from: friend.friendAvatarURL, to: avatarView.imageView)
    }
    
}
