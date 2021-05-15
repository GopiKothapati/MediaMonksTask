//
//  PhotoDetailsViewModel.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit
struct PhotoDetail {
    let photo: Photo
    let album: Album
}
class PhotoDetailsViewModel {
    let id, imageURL, title, albumTitle: String
    init?(photoDetail: PhotoDetail?) {
        guard let photoDetail = photoDetail else {
            return nil
        }
        self.id = photoDetail.photo.id.description
        self.imageURL = photoDetail.photo.url
        self.title = photoDetail.photo.title
        self.albumTitle = photoDetail.album.title
    }
}
