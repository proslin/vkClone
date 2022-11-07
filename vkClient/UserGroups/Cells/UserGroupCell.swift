//
//  UserGroupCell.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit

class UserGroupCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupAvatar: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func set(group: Group) {
        groupName.text = group.groupName
        groupName.textColor = VKColors.labelColor
        NetworkManager.shared.downloadAvatar(from: group.groupAvatarURL, to: groupAvatar.imageView)
    }
    
}
