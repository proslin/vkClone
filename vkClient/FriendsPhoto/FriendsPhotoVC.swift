//
//  FriendsPhotoVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit

//private let reuseIdentifier = "Cell"

class FriendsPhotoVC: UIViewController {
    
    @IBOutlet weak var navigationBar: NavigationBarCustom!
    @IBOutlet weak var collectionView: UICollectionView!
    var offset = 0
    var photosCount: Int = 0
    var selectedModel: Friend?
    var photos: [Photo] = []
    var photosURL: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos(offset: 0)
        print(photos.count)
        configureCollectionView()
        setNavigationBar()
        
    }
    
    func configureCollectionView() {
        self.collectionView.register(UINib(nibName: String(describing: FriendPhotoCellXib.self), bundle: nil), forCellWithReuseIdentifier: String(describing: FriendPhotoCellXib.self))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = UIHelper.createThreeColumnFlowLayout(in: view)
    }
    
    private func setNavigationBar() {
        navigationBar.setTitle(title: "Фотографии")
        navigationBar.showLeftButton()
        navigationBar.setLeftButtonAction {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getPhotos(offset: Int) {
        guard let selectedModel = selectedModel else { return }
        let ownerId = selectedModel.friendId
        NetworkManager.shared.getPhotos(for: String(ownerId), offset: offset) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let photosResponse):
                self.photosCount = photosResponse.response.count
                print("Текущее смещение \(self.offset)")
                let currentPhotoResponse = photosResponse.response.items
                self.photos.append(contentsOf: currentPhotoResponse)
                let currentUrlPhoto = currentPhotoResponse.compactMap { self.getPhotoUrl(photo: $0) }
                self.photosURL.append(contentsOf: currentUrlPhoto)
                DispatchQueue.main.async { self.collectionView.reloadData() }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
}

    private func getPhotoUrl(photo: Photo) -> String? {
        photo.sizes.first(where: { $0.type == "m" })?.url
    }
}

// MARK: UICollectionViewDataSource
extension FriendsPhotoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FriendPhotoCellXib.self), for: indexPath) as! FriendPhotoCellXib
        NetworkManager.shared.downloadAvatar(from: photosURL[indexPath.row], to: cell.photo)
        return cell
        
    }

}

// MARK: UICollectionViewDelegate
extension FriendsPhotoVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if offset < photosCount && indexPath.row == photos.count - 1 {
            offset += 200
            getPhotos(offset: offset)
        }
    }
}
