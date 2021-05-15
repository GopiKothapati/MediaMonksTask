//
//  ApiManager.swift
//  MediaMonksTask
//
//  Created by Gopi K on 14/05/21.
//

import UIKit

protocol ApiManagerDelegate: class {
    func apiResponseReceived(with result: Result<ResponseObject, ApiError>)
}

final class ApiManager: NSObject {
    private weak var delegate: ApiManagerDelegate?
    private var session: URLSession {
        let urlSessionConfig = URLSessionConfiguration.ephemeral
        urlSessionConfig.timeoutIntervalForRequest = 15
        urlSessionConfig.waitsForConnectivity = true
        return URLSession(configuration: urlSessionConfig, delegate: nil, delegateQueue: nil)
    }
    
    init(delegate: ApiManagerDelegate?) {
        self.delegate = delegate
    }
    
    func requestApi(for url: String, queryItems: [URLQueryItem]? = nil, with httpmethod: HTTPMethod = .GET) throws {
        
        let urlRequest = try createURLRequest(url: url,queryItems,with: httpmethod)
        let dataTask = session.dataTask(with: urlRequest, completionHandler: dataTaskCompletion)
        dataTask.resume()
    }
    
    private func dataTaskCompletion(data:Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            delegate?.apiResponseReceived(with: .failure(.serverError(error.localizedDescription)))
        }
        guard let data = data, !data.isEmpty else {
            delegate?.apiResponseReceived(with: .failure(.noData))
            return
        }
        do{
            _ = try self.validateHttpResponse(urlResponse: response).get()
            let responseObject = ResponseObject(url: response?.url, data: data)
            delegate?.apiResponseReceived(with: .success(responseObject))
            
        } catch {
            delegate?.apiResponseReceived(with: .failure(.customError(error.localizedDescription)))
        }
    }
    
    private func createURLRequest(url: String,_ queryItems: [URLQueryItem]? = nil, with httpmethod: HTTPMethod = .GET) throws -> URLRequest {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = queryItems
        guard let url  = urlComponents?.url else {
            throw ApiError.invalidUrl
        }
        guard let absoluteURL = URL(string: url.absoluteString.replacingOccurrences(of: "?=", with: "?")) else { throw ApiError.invalidUrl }
        var urlRequest = URLRequest(url: absoluteURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        urlRequest.httpMethod = httpmethod.rawValue
        return urlRequest
    }
    
    func validateHttpResponse(urlResponse: URLResponse?) -> Result<Bool, ApiError> {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return .failure(ApiError.invalidResponse)
        }
        guard (200...300) ~= httpResponse.statusCode else {
            return .failure(ApiError.serverError(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)))
        }
        return .success(true)
    }
}
