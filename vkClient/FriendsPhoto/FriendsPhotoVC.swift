//
//  FriendsPhotoVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendsPhotoVC: UIViewController {
    
    @IBOutlet weak var navigationBar: NavigationBarCustom!
    @IBOutlet weak var collectionView: UICollectionView!
   // var isLoadingMorePhotos = false
   // var hasMorePhotos = true
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
        //view.addSubview(collectionView)
        
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
               // self.photos = photosUrl
                
                
                //print(photosUrl)
                DispatchQueue.main.async { self.collectionView.reloadData() }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }

}
    
//    func updateUI(with photos: [Photo]) {
//        if photos.count < 200 { self.hasMorePhotos = false}
//        self.photos.append(contentsOf: photos)
//        if self.photos.isEmpty {
//            let message = "This user doesn't have any followers. Go follow them 😀"
////            DispatchQueue.main.async {
////                //self.navigationItem.searchController?.searchBar.isHidden = true
////                self.showEmptyStateView(with: message, in: self.view)
////
////            }
//            return
//        }
//        self.updateData(on: self.followers)
//    }
    
    private func getPhotoUrl(photo: Photo) -> String? {
        photo.sizes.first(where: { $0.type == "m" })?.url
    }
}

// MARK: UICollectionViewDataSource
extension FriendsPhotoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photos.count)
        return photos.count
        // return selectedModel?.friendPhotoAlbum.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FriendPhotoCellXib.self), for: indexPath) as! FriendPhotoCellXib
        
        // Configure the cell
        //cell.photo.image = UIImage(named: "cat")
        NetworkManager.shared.downloadAvatar(from: photosURL[indexPath.row], to: cell.photo)
            //cell.photo.image = UIImage(named: photos[indexPath.row])
        return cell
        
    }

}

// MARK: UICollectionViewDelegate
extension FriendsPhotoVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//        if offsetY > contentHeight - height {
//            offset += 200
//            getPhotos(offset: offset)
//
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if offset < photosCount && indexPath.row == photos.count - 1 {
            offset += 200
            getPhotos(offset: offset)
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        <#code#>
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.width / 2), height: collectionView.frame.width / 2)
//    }
}


//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: (collectionView.frame.width / 7), height: collectionView.frame.width / 7)
//}
