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
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
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
