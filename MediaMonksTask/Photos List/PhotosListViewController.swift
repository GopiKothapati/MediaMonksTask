//
//  PhotosListViewController.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit

class PhotosListViewController: UIViewController {
    @IBOutlet weak var photosListCollectionView: UICollectionView!
    private lazy var viewModel: PhotosListViewModel = {
        let viewModel = PhotosListViewModel(delegate: self)
        return viewModel
    }()
    private let screenWidth = UIScreen.main.bounds.size.width

    var passedAlbum: Album?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        self.photosListCollectionView.dataSource = self.viewModel
        self.photosListCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            let queryItem = URLQueryItem(name: "albumId", value: passedAlbum?.id.description)
            try viewModel.callApi(with: ApiURL.BASE_URL.rawValue + ApiURL.photos.rawValue,and: [queryItem])
            startLoading(with: "Fetching Photos")
        } catch {
            print(error)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let photoDetailsViewController = segue.destination as? PhotoDetailsViewController, let dataObject = sender as? PhotoDetail {
            photoDetailsViewController.passedPhotoDetail = dataObject
        }
    }
    
}

extension PhotosListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let album = passedAlbum else {
            return
        }
        let photoDetail = PhotoDetail(photo: self.viewModel.dataModels[indexPath.item], album: album)
        performSegue(withIdentifier: SegueId.photoDetailsViewController.rawValue, sender: photoDetail)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 30) / 2, height: 230)
    }
    
}

extension PhotosListViewController: ApiManagerDelegate {
    func apiResponseReceived(with result: Result<ResponseObject, ApiError>) {
        DispatchQueue.main.async { [weak self] in
            
            do {
                self?.stopLoading()
                try self?.viewModel.parseResponse(with: result)
                self?.photosListCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

