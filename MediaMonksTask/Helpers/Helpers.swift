//
//  Helpers.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import Foundation

protocol CellDataProtocol: class {
    associatedtype CellData
    func assignData(with value:CellData)
    var cellData: CellData? { get set }
}

