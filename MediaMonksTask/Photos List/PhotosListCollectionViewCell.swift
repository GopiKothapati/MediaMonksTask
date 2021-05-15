//
//  PhotosListCollectionViewCell.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit

class PhotosListCollectionViewCell: UICollectionViewCell, CellDataProtocol {
    typealias CellData = Photo
    @IBOutlet weak var photoimageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!

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
        mainBackground.layer.cornerRadius = 8
        mainBackground.clipsToBounds = true
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
    }
    
    func assignData(with value: Photo) {
        self.contentView.backgroundColor = .white
        self.photoimageView.loadImageWithUrl(value.url)
        self.titleLabel.text = value.title
    }
    
}
