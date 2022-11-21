//
//  FriendCellXib.swift
//  vkClient
//
//  Created by Lina Prosvetova on 07.10.2022.
//

import UIKit

final class FriendCell: UITableViewCell {
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.imageView.image = UIImage()
    }
    
    func set(friend: Friend) {
        friendName.text =  "\(friend.firstName) \(friend.lastName)"
        friendName.textColor = VKColors.labelColor
        NetworkService.shared.downloadAvatar(from: friend.friendAvatarURL, to: avatarView.imageView)
    }
    
}
