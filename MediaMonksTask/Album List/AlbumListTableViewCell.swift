//
//  AlbumListTableViewCell.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit

class AlbumListTableViewCell: UITableViewCell, CellDataProtocol {

    typealias CellData = Album
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: ShadowView!

    var cellData: Album? {
        didSet {
            if let cellData = cellData {
                self.assignData(with: cellData)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainBackground.layer.cornerRadius = 8
        mainBackground.layer.masksToBounds = true
    }
    
    func assignData(with value: Album) {
        self.titleLabel.text = value.title
        self.idLabel.text = value.id.description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
