//
//  FriendsPhotoVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit
import RealmSwift

class FriendsPhotoVC: UIViewController {
    
   
    @IBOutlet weak var navigationBarContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var offset = 0
    var photosCount: Int = 0
    var selectedModel: Friend?
    var photos: Results<Photo>?
    var token: NotificationToken?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        getPhotos(offset: 0)
        pairTableAndRealm()
        configureCollectionView()
        setupNavBar()
        
    }
    
    // MARK: - Private methods
    private func configureCollectionView() {
        self.collectionView.register(UINib(nibName: String(describing: FriendPhotoCellXib.self), bundle: nil), forCellWithReuseIdentifier: String(describing: FriendPhotoCellXib.self))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.collectionViewLayout = UIHelper.createThreeColumnFlowLayout(in: view)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        getPhotos(offset: 0)
    }
    
    private func setupNavBar() {
        let navBarButtonModel = NavBarButton(image: SFSymbols.shevron, action: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        let navBarModel = NavigationBarModel(title: "Фотографии пользователя", leftButton: navBarButtonModel)
        let _ = NavigationBarCustom.instanceFromNib(model: navBarModel, parentView: navigationBarContainer)
    }
    
    private func getPhotos(offset: Int, isLoadingMorePhotos: Bool = false) {
        showSpinner()
        
        guard let selectedModel = selectedModel else { return }
        let ownerId = selectedModel.friendId
        NetworkService.shared.getPhotos(for: String(ownerId), offset: offset) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.removeSpinner()
            }
            switch result {
                
            case .success(let photosResponse):
                self.photosCount = photosResponse.response.count
                let currentPhotoResponse = photosResponse.response.items
                let currentResponseWithURL = currentPhotoResponse
                for photo in currentResponseWithURL {
                    photo.photoURL = photo.sizes.first(where: { $0.type == "m" })?.url ?? ""
                }
                
                DispatchQueue.main.async {
                    RealmService.shared.savePhoto(currentResponseWithURL, ownerId: ownerId, isLoadimgMorePhoto: isLoadingMorePhotos)
                    self.refreshControl.endRefreshing()
                    self.pairTableAndRealm()
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func pairTableAndRealm() {
        guard let realm = try? Realm(), let owner = realm.object(ofType: Friend.self, forPrimaryKey: selectedModel?.friendId) else { return }
        photos = realm.objects(Photo.self).filter("ownerId == %@", owner.friendId)
        token = photos?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({ collectionView.insertItems(at: insertions.map({
                    IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({
                        IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({
                        IndexPath(row: $0, section: 0) })) }, completion: nil)
            case .error(let error):
                fatalError("\(error)") }
        }
        
    }

    private func getPhotoUrl(photo: Photo) -> String? {
        photo.sizes.first(where: { $0.type == "m" })?.url
    }
}

// MARK: UICollectionViewDataSource
extension FriendsPhotoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FriendPhotoCellXib.self), for: indexPath) as! FriendPhotoCellXib
        NetworkService.shared.downloadAvatar(from: photos?[indexPath.row].photoURL ?? "", to: cell.photo)
        return cell
        
    }
}

// MARK: UICollectionViewDelegate
extension FriendsPhotoVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if offset < photosCount  && photosCount > (200 + offset) && indexPath.row == (photos?.count ?? 0) - 1 {
            offset += 200
            getPhotos(offset: offset, isLoadingMorePhotos: true)
        }
    }
}
