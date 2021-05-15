//
//  AlbumlListViewController.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit

class AlbumListViewController: UIViewController {
    
    @IBOutlet weak var albumlistTableView: UITableView!
    
    private lazy var viewModel: AlbumListViewModel = {
        let viewModel = AlbumListViewModel(delegate: self)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        self.albumlistTableView.tableFooterView = UIView()
        self.albumlistTableView.estimatedRowHeight = 100
        self.albumlistTableView.rowHeight = UITableView.automaticDimension
        self.albumlistTableView.dataSource = self.viewModel
        self.albumlistTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            try viewModel.callApi(with: ApiURL.BASE_URL.rawValue + ApiURL.albums.rawValue)
            startLoading(with: "Fetching Albums")
        } catch {
            print(error)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let photosListViewController = segue.destination as? PhotosListViewController, let dataObject = sender as? Album {
            photosListViewController.passedAlbum = dataObject
        }
    }
    
}

extension AlbumListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueId.photosListViewController.rawValue, sender: self.viewModel.dataModels[indexPath.row])
    }
}

extension AlbumListViewController: ApiManagerDelegate {
    func apiResponseReceived(with result: Result<ResponseObject, ApiError>) {
        do {
            stopLoading()
            try viewModel.parseResponse(with: result)
            albumlistTableView.reloadData()
        } catch {
            print(error)
        }
    }
}
