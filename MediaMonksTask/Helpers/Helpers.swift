//
//  Helpers.swift
//  MediaMonksTask
//
//  Created by 1634391 on 15/05/21.
//

import Foundation

protocol CellDataProtocol: class {
    associatedtype CellData
    func assignData(with value:CellData)
    var cellData: CellData? { get set }
}

