//
//  FriendsPhotoVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit
import RealmSwift

final class FriendsPhotoViewController: UIViewController {
    
    @IBOutlet private weak var navigationBarContainer: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var offset = 0
    private var photosCount: Int = 0
    private var photos: Results<PhotoModel>?
    private var token: NotificationToken?
    var selectedModel: FriendModel?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        getPhotos(offset: 0)
        configureCollectionView()
        setupNavBar()
    }
    
    // MARK: - Private methods
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: String(describing: FriendPhotoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: FriendPhotoCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = UIHelper.createThreeColumnFlowLayout(width: view.bounds.width, padding: VKDimensions.padding)
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
                    if let error = RealmService.shared.savePhoto(currentResponseWithURL, ownerId: ownerId, isLoadimgMorePhoto: isLoadingMorePhotos) {
                        self.presentAlertVC(title: "Ошибка записи в БД", message: error.localizedDescription)
                    } else {
                        self.refreshControl.endRefreshing()
                        self.pairTableAndRealm()
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlertVC(title: "Ошибка", message: error.rawValue)
                }
            }
        }
    }
    
    private func pairTableAndRealm() {
        guard let realm = try? Realm(), let owner = realm.object(ofType: FriendModel.self, forPrimaryKey: selectedModel?.friendId) else { return }
        photos = realm.objects(PhotoModel.self).filter("ownerId == %@", owner.friendId)
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
                self?.presentAlertVC(title: "Ошибка", message: "\(error)")
            }
        }
        
    }
    
    private func getPhotoUrl(photo: PhotoModel) -> String? {
        photo.sizes.first(where: { $0.type == "m" })?.url
    }
    
    
    @objc func refresh(sender: UIRefreshControl) {
        getPhotos(offset: 0)
    }
}

// MARK: UICollectionViewDataSource
extension FriendsPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FriendPhotoCell.self), for: indexPath) as? FriendPhotoCell,
           let photo = photos?[indexPath.row] {
            cell.set(photo: photo)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: UICollectionViewDelegate
extension FriendsPhotoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if offset < photosCount  && photosCount > (200 + offset) && indexPath.row == (photos?.count ?? 0) - 1 {
            offset += 200
            getPhotos(offset: offset, isLoadingMorePhotos: true)
        }
    }
}
