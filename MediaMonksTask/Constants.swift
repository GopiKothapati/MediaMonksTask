//
//  Constants.swift
//  MediaMonksTask
//
//  Created by 1634391 on 15/05/21.
//

import Foundation


enum ApiURL: String {
    case BASE_URL = "https://jsonplaceholder.typicode.com/"
    case albums, photos
}

enum ReuseID: String {
    case albumsCell = "AlbumCell"
    case photosListCell = "PhotosListCell"
}

enum SegueId: String {
    case albumListViewController = "AlbumListViewController"
    case photosListViewController = "PhotosListViewController"
    case photoDetailsViewController = "PhotoDetailsViewController"

}

