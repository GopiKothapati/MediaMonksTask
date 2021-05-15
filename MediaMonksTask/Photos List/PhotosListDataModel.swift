//
//  PhotosListDataModel.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import Foundation

struct Photo: Codable {
    let albumId, id: Int
    let title: String
    let url, thumbnailUrl: String
}
