//
//  PhotosListDataModel.swift
//  MediaMonksTask
//
//  Created by 1634391 on 15/05/21.
//

import Foundation

struct Photo: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String
}
