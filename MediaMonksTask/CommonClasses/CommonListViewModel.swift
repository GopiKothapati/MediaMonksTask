//
//  CommonListViewModel.swift
//  MediaMonksTask
//
//  Created by 1634391 on 15/05/21.
//

import Foundation
class CommonListViewModel<T: Decodable>: NSObject {
    public private(set) var dataModels: [T] = []
    private lazy var apiManager: ApiManager = {
        let apiManager = ApiManager(delegate: self.delegate)
        return apiManager
    }()
    private weak var delegate: ApiManagerDelegate?
    init(delegate: ApiManagerDelegate) {
        self.delegate = delegate
    }
    
    func callApi(with url: String, and queryItems: [URLQueryItem]? = nil) throws {
        try apiManager.requestApi(for: url,queryItems: queryItems)
    }
    
    func parseResponse(with object: Result<ResponseObject, ApiError>) throws {
        let responseObject = try object.get()
        let albumsData: [T] = try MXParser.parse(data: responseObject.data).get()
        self.dataModels = albumsData
    }
}
