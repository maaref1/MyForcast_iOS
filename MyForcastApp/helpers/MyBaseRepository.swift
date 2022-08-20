//
//  MyBaseRepository.swift
//  MyForcastApp
//
//  Created by MacBook Air on 18/08/2022.
//

import Foundation

class MyBaseRepository {
    
    typealias CompletionApiRequest<T> = (T?, String?) -> Void
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    /*
     This function will be used to call Api
     */
    func apiRequest<T: Decodable>(path: String,
                                  method: MethodRequestType,
                                  params: [String: Any],
                                  headers: [String: String],
                                  responseType: T.Type,
                                  completion: @escaping(CompletionApiRequest<T>)) {
        var request: URLRequest?
        switch method {
        case .get:
            request = self.buildGetRequest(path: path, params: params)
        case .post:
            request = self.buildPostRequest(path: path, params: params)
        }
        
        guard request != nil else {
            completion(nil, "Bad Url")
            return
        }
        request?.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request!) { data, _, error in
            guard error == nil,
                  let model: T = self.parseDataToObject(data: data) else {
                let errorStr: String = error?.localizedDescription ?? "Failed to respond"
                completion(nil, errorStr)
                return
            }
            completion(model, nil)
        }
        task.resume()
    }
    
    /*
     This function will build UrlRequest with Get Method and Query Params
     */
    private func buildGetRequest(path: String,
                                 params: [String: Any]) -> URLRequest? {
        let component = self.getComponentsParams(url: path, params: params)
        guard let url = component?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    /*
     This function will build UrlRequest with Post Method and Body Params
     */
    private func buildPostRequest(path: String,
                                  params: [String: Any]) -> URLRequest? {
        guard let url = URL(string: path) else {
            return nil
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpBody = getBodyDataFromParams(dict: params as NSDictionary)
        return urlRequest
    }
    
    /*
     This function will transform a params Dictionary to String Url format
     */
    func getComponentsParams(url: String,
                             params: [String: Any]) -> URLComponents? {
        guard var component = URLComponents(string: url) else {
            return nil
        }
        component.queryItems = params.map({ key, value in
            return URLQueryItem(name: key, value: value as? String ?? "")
        })
        component.percentEncodedQuery = component.percentEncodedQuery?.replacingOccurrences(of: "+",
                                                                                            with: "%2B")
        return component
    }
    
    /*
     This function will parse a Data to Codable Object
     */
    func parseDataToObject<T: Decodable>(data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard data != nil,
              let model = try? decoder.decode(T.self, from: data!) else {
            return nil
        }
        return model
    }
    
    /*
     This function will transform Dictionary to Data
     */
    func getBodyDataFromParams(dict: NSDictionary) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict)
        return jsonData
    }
}

enum MethodRequestType: String {
    case get = "GET"
    case post = "POST"
}
