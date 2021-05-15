//
//  PhotosListCollectionViewCell.swift
//  MediaMonksTask
//
//  Created by 1634391 on 15/05/21.
//

import UIKit

class PhotosListCollectionViewCell: UICollectionViewCell, CellDataProtocol {
    typealias CellData = Photo
    @IBOutlet weak var photoimageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var cellData: Photo? {
        didSet {
            if let cellData = cellData {
                self.assignData(with: cellData)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
    }
    
    func assignData(with value: Photo) {
        self.photoimageView.loadImageWithUrl(value.url)
        self.titleLabel.text = value.title
    }
    
}
