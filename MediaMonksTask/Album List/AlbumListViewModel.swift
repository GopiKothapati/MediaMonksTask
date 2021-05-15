//
//  AlbumListViewModel.swift
//  MediaMonksTask
//
//  Created by 1634391 on 15/05/21.
//

import UIKit

class AlbumListViewModel: CommonListViewModel<Album>, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let albumCell = tableView.dequeueReusableCell(withIdentifier: ReuseID.albumsCell.rawValue, for: indexPath) as? AlbumListTableViewCell else {
            return UITableViewCell()
        }
        albumCell.cellData = dataModels[indexPath.row]
        return albumCell
    }
}



