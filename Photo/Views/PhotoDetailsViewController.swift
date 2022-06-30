//
//  PhotoDetailsViewController.swift
//  Photo
//
//  Created by Ilya on 30.06.2022.
//

import UIKit
import Combine
import SDWebImage

class PhotoDetailsViewController: UIViewController {

    var photoId = ""
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = PhotoViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBinders()
        viewModel.fetchPhotoDetails(photoId: photoId)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(changeFavoritesList))
    }
    
    @objc func changeFavoritesList(_ sender: UIButton) {
        
    }
    
    private func setupBinders() {
        viewModel.$data.sink { [weak self] photoDetails in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                guard let imageUrl = self?.viewModel.data?.urls["thumb"],
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
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.detailCellIdentifier, for: indexPath)
        
        var cellText = ""
        
        switch indexPath.section {
        case 0: cellText = "\(viewModel.data?.user.name ?? "") (@\(viewModel.data?.user.username ?? ""))"
            let name = viewModel.data?.user.name ?? ""
            let username = viewModel.data?.user.username ?? ""
            if !name.isEmpty {
                cellText = "\(name) "
            }
            if !username.isEmpty {
                cellText = cellText + "(@\(username))"
            }
        case 1:
            let city = viewModel.data?.location?.city ?? ""
            let country = viewModel.data?.location?.country ?? ""
            if !city.isEmpty {
                cellText = "\(city), "
            }
            if !country.isEmpty {
                cellText = cellText + country
            }
        case 2:
            cellText = changeDateFormat(string: viewModel.data?.created_at ?? "")
        case 3: cellText = "\(viewModel.data?.downloads ?? 0)"
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
        case 0: return "Author"
        case 1: return "Location"
        case 2: return "Published on"
        case 3: return "Downloads"
        default: return nil
        }
        
    }
    
}
