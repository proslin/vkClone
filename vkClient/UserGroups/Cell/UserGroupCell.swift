//
//  UserGroupCell.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit

final class UserGroupCell: UITableViewCell {

    @IBOutlet private weak var groupName: UILabel!
    @IBOutlet private weak var groupAvatar: AvatarView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupAvatar.setEmptyAvatarImage()
    }
    
    func set(group: GroupModel) {
        let deleteAction = UIContextualAction()
        deleteAction.title = "Удалить"
        groupName.text = group.groupName
        groupName.numberOfLines = 2
        groupName.textColor = VKColors.labelColor
        NetworkService.shared.downloadAvatar(from: group.groupAvatarURL, to: groupAvatar.getAvatarImageView())
    }
    
}
