//
//  PhotoDetailsViewController.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var photoimageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    var passedPhotoDetail: PhotoDetail?
    private lazy var viewModel: PhotoDetailsViewModel? = {
        let viewModel = PhotoDetailsViewModel(photoDetail: passedPhotoDetail)
        return viewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        if let viewModel = self.viewModel {
            self.photoimageView.loadImageWithUrl(viewModel.imageURL)
            self.titleLabel.text = viewModel.title
            self.albumTitleLabel.text = viewModel.albumTitle
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
