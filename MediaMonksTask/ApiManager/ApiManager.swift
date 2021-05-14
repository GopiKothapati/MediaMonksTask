//
//  ApiManager.swift
//  MediaMonksTask
//
//  Created by 1634391 on 14/05/21.
//

import UIKit

protocol ApiManagerDelegate: class {
    func apiResponseReceived(with result: Result<Data, ApiError>)
}

final class ApiManager: NSObject {
    private let BASE_URL = "https://jsonplaceholder.typicode.com/"
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
    func requestApi(for url: String, with httpmethod: HTTPMethod = .GET) {
        guard let apiURL = URL.init(string: BASE_URL + url) else {
            return
        }
        var urlRequest = URLRequest(url: apiURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        urlRequest.httpMethod = httpmethod.rawValue
        let dataTask = session.dataTask(with: urlRequest)
        dataTask.resume()
    }
    
    func handleDataTaskResponse(with data: Data, and dataTask: URLSessionDataTask) {
        do{
            _ = try self.validateHttpResponse(urlResponse: dataTask.response).get()
            self.delegate?.apiResponseReceived(with: .success(data))
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
        handleDataTaskResponse(with: data, and: dataTask)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        session.finishTasksAndInvalidate()

        if let error = error {
            //MXHelpers.logsFileCreationandWriting(with: "\( String(describing: error))")
            delegate?.apiResponseReceived(with: .failure(.serverError(error.localizedDescription)))
        }
    }

}
