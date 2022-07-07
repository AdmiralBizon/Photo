//
//  PhotoDetailsViewController.swift
//  Photo
//
//  Created by Ilya on 05.07.2022.
//

import UIKit
import Combine
import SDWebImage

class PhotoDetailsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var detailInfoButton: UIBarButtonItem!
    
    // MARK: - Public Properties
    var photoId = ""
    var isFavorite: Bool!
    var viewModel: PhotoViewModel!
    
    // MARK: - Private Properties
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()
        setupBinders()
        viewModel.fetchPhotoDetails(photoId: photoId)
    }
    
    // MARK: - IB Actions
    @IBAction func showHideDetails(_ sender: Any) {
        tableView.isHidden = tableView.isHidden ? false : true
        setupToolbar()
    }
    
    @IBAction func favoritesButtonPressed(_ sender: UIBarButtonItem) {
        if isFavorite {
            viewModel.removeFromFavorites(photo: viewModel.currentPhoto!)
            isFavorite = false
        } else {
            viewModel.addToFavorites(photo: viewModel.currentPhoto!)
            isFavorite = true
        }
        setupToolbar()
    }
    
    // MARK: - Private Methods
    private func setupToolbar() {
        let favoritesButtonImage = isFavorite ? "heart.fill" : "heart"
        favoritesButton.image = UIImage(systemName: favoritesButtonImage)
        let detailsButtonImage = tableView.isHidden ? "info.circle" : "info.circle.fill"
        detailInfoButton.image = UIImage(systemName: detailsButtonImage)
    }
    
    private func setupBinders() {
        viewModel.$currentPhoto.sink { [weak self] currentPhoto in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                guard let imageUrl = currentPhoto?.urls["regular"],
                      let url = URL(string: imageUrl) else { return }
                self?.photoImageView.sd_setImage(with: url, completed: nil)
            }
        }.store(in: &cancellables)
    }

    private func changeDateFormat(string: String) -> String {
        
        guard !string.isEmpty else { return "" }
        
        var formattedDate = ""
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: string) {
            formatter.dateFormat = "MMM d, yyyy"
            formattedDate = formatter.string(from: date)
        }
        
        return formattedDate
        
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PhotoDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.detailCellIdentifier, for: indexPath)
        
        var cellText = ""
        
        switch indexPath.section {
        case 1: cellText = "\(viewModel.currentPhoto?.user.name ?? "") (@\(viewModel.currentPhoto?.user.username ?? ""))"
            let name = viewModel.currentPhoto?.user.name ?? ""
            let username = viewModel.currentPhoto?.user.username ?? ""
            if !name.isEmpty {
                cellText = "\(name) "
            }
            if !username.isEmpty {
                cellText = cellText + "(@\(username))"
            }
        case 2:
            let city = viewModel.currentPhoto?.location?.city ?? ""
            let country = viewModel.currentPhoto?.location?.country ?? ""
            if !city.isEmpty {
                cellText = "\(city), "
            }
            if !country.isEmpty {
                cellText = cellText + country
            }
        case 3:
            cellText = changeDateFormat(string: viewModel.currentPhoto?.createdDate ?? "")
        case 4: cellText = "\(viewModel.currentPhoto?.downloads ?? 0)"
            
        default: cellText = ""
        }
        
        if #available(iOS 14.0, *) {
            var cellConfiguration = cell.defaultContentConfiguration()
            cellConfiguration.text = cellText
            cell.contentConfiguration = cellConfiguration
        } else {
            cell.textLabel?.text = cellText
        }
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Author"
        case 2: return "Location"
        case 3: return "Published on"
        case 4: return "Downloads"
        default: return nil
        }
    }

}
