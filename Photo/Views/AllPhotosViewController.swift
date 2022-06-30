//
//  ViewController.swift
//  Photo
//
//  Created by Ilya on 28.06.2022.
//

import UIKit
import Combine

class AllPhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = PhotoCollectionViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    //var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinders()
        viewModel.fetchPhotoList()
//        viewModel.fetchRandomPhotos(path: K.randomPhotosPath)
        setupSearchBar()
    }

    private func setupBinders() {
        viewModel.$data.sink { [weak self] fetchedPhotos in
            //self?.photos = fetchedPhotos
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    // MARK: - Navigation
    
    private func showDetailInfo(photoId: String) {
        let controller = storyboard?.instantiateViewController(withIdentifier: K.detailsViewControllerIndentifier) as! PhotoDetailsViewController
        controller.photoId = photoId
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension AllPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //photos.count
        viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        //cell.photo = photos[indexPath.item]
        cell.photo = viewModel.data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let currentPhoto = photos[indexPath.row]
        //showDetailInfo(photo: currentPhoto)
        showDetailInfo(photoId: viewModel.data[indexPath.item].id)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AllPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
    }
    
}

// MARK: - UISearchBarDelegate

extension AllPhotosViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            viewModel.fetchPhotoList(query: text)
            //viewModel.fetchSearchResults(path: text)
        }
    }
    
}
