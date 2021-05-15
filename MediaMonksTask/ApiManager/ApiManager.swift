//
//  ApiManager.swift
//  MediaMonksTask
//
//  Created by 1634391 on 14/05/21.
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
        return URLSession(configuration: urlSessionConfig, delegate: self, delegateQueue: .main)
    }
    
    init(delegate: ApiManagerDelegate?) {
        self.delegate = delegate
    }
    
    func requestApi(for url: String, queryItems: [URLQueryItem]? = nil, with httpmethod: HTTPMethod = .GET) throws {
        
        let urlRequest = try createURLRequest(url: url,queryItems,with: httpmethod)
        let dataTask = session.dataTask(with: urlRequest)
        dataTask.resume()
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
    
    
    func handleDataTaskResponse(with data: Data, and dataTask: URLSessionDataTask) {
        do{
            _ = try self.validateHttpResponse(urlResponse: dataTask.response).get()
            let responseObject = ResponseObject(url: dataTask.response?.url, data: data)
            self.delegate?.apiResponseReceived(with: .success(responseObject))
        } catch {
            self.delegate?.apiResponseReceived(with: .failure(.customError(error.localizedDescription)))
        }
    }
    
    func validateHttpResponse(urlResponse: URLResponse?) -> Result<Bool, ApiError> {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return .failure(ApiError.invalidResponse)
        }
        print("httpResponse: \( String(describing: httpResponse))")
        guard (200...300) ~= httpResponse.statusCode else {
            return .failure(ApiError.serverError(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)))
        }
        return .success(true)
    }
}

extension ApiManager: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("dataTask:\(dataTask.taskDescription ?? "N/A")")
        session.finishTasksAndInvalidate()
        DispatchQueue.main.async { [weak self] in
            self?.handleDataTaskResponse(with: data, and: dataTask)
        }
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        session.finishTasksAndInvalidate()
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.apiResponseReceived(with: .failure(.serverError(error.localizedDescription)))
            }
        }
    }

}
