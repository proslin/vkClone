//
//  AllGroupCell.swift
//  vkClient
//
//  Created by Lina Prosvetova on 26.10.2022.
//

import UIKit

final class AllGroupCell: UITableViewCell {


    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupAvatar: AvatarView!
    @IBOutlet weak var memberCount: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupAvatar.imageView.image = UIImage()
    }
    
    func set(group: Group) {
        groupName.textColor = VKColors.labelColor
        groupName.text = group.groupName
        groupAvatar.imageView.image = UIImage(named: group.groupAvatarURL)
        memberCount.textColor = VKColors.secondLabelColor
        memberCount.text = "\(group.membersCount ?? 0) участников"
        NetworkService.shared.downloadAvatar(from: group.groupAvatarURL, to: groupAvatar.imageView)
    }
}
