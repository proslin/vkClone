//
//  FriendPhotoCell.swift
//  vkClient
//
//  Created by Lina Prosvetova on 11.10.2022.
//

import UIKit

final class FriendPhotoCell: UICollectionViewCell {

    @IBOutlet private weak var photo: UIImageView!
    
    func set(photo: PhotoModel) {
        NetworkService.shared.downloadAvatar(from: photo.photoURL, to: self.photo)
    }
}
