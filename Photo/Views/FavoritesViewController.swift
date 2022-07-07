//
//  FavoritesViewController.swift
//  Photo
//
//  Created by Ilya on 30.06.2022.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private Properties
    private var viewModel: PhotoViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupRefreshControl()
        setupBinders()
    }
    
    // MARK: - Private Methods
    private func setupViewModel() {
        let tabBar = tabBarController as! BaseTabBarController
        viewModel = tabBar.viewModel
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing ...")
        collectionView.refreshControl?.addTarget(self,
                                            action: #selector(didPullToRefresh),
                                            for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        viewModel.loadFavorites()
    }
    
    private func setupBinders() {
        viewModel.$favorites.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                if self?.collectionView.refreshControl?.isRefreshing == true {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            }
        }.store(in: &cancellables)
    }

    // MARK: - Navigation
    private func showDetailInfo(photoId: String) {
        let controller = storyboard?.instantiateViewController(withIdentifier: K.detailsViewControllerIndentifier) as! PhotoDetailsViewController
        
        controller.photoId = photoId
        controller.isFavorite = true
        controller.viewModel = viewModel
        controller.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photo = viewModel.favorites[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetailInfo(photoId: viewModel.favorites[indexPath.item].id)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
    }
    
}
