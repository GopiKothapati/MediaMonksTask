//
//  ApiManagerHelpers.swift
//  MediaMonksTask
//
//  Created by 1634391 on 14/05/21.
//

import Foundation

struct ResponseObject {
    let url: URL?
    let data: Data
}
enum HTTPMethod: String {
    case GET, POST, PUT, UPDATE
}

enum ApiError: Error {
    case noData, jsonSerialisationError(Error), requestError(String), invalidUrl, invalidResponse, serverError(String), noNetworkConnection, customError(String), responseError(String)
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData:
            return NSLocalizedString("Data doesn't exists", comment: "noData")
        case .jsonSerialisationError(let error):
            return NSLocalizedString(error.localizedDescription, comment: "jsonSerialisationError")
        case .requestError(let error):
            return NSLocalizedString(error, comment: "requestError")
        case .invalidUrl:
            return NSLocalizedString("invalidUrl", comment: "Invalid Url")
        case .invalidResponse:
            return NSLocalizedString("invalidResponse", comment: "Invalid Response")
        case .serverError(let value):
 
            return NSLocalizedString(value, comment: "serverError")
        case .responseError(let value):
            return NSLocalizedString(value, comment: "responseError")

        case .noNetworkConnection:
            return NSLocalizedString("The Internet connection appears to be offline.", comment: "noNetworkConnection")
        case .customError(let value):
            return NSLocalizedString(value, comment: "customError")
        }
    }
}

final class MXParser {
    class func parse<D: Decodable>(data: Data?) -> Result<D,ApiError> {
        guard let data = data, data.isEmpty else {
            return .failure(ApiError.noData)
        }
        do {
            let values = try JSONDecoder().decode(D.self, from: data)
            return .success(values)
        } catch {
            print("parsing error:\(error)")
            return .failure(ApiError.jsonSerialisationError(error))
        }
    }
}
