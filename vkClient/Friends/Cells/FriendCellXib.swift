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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func set(friend: Friend) {
        friendName.text =  "\(friend.firstName) \(friend.lastName)"
        friendName.textColor = VKColors.labelColor
        NetworkManager.shared.downloadAvatar(from: friend.friendAvatarURL, to: avatarView.imageView)
    }
    
}
