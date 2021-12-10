//
//  WebService.swift
//  HotCoffe
//
//  Created by Jose Manuel Malagón Alba on 9/12/21.
//

import Foundation

enum NetworkError: Error{
    case decodingError
    case domainError
    case urlError
}

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>)-> () ) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
            else {
                completion(.failure(.decodingError))
            }
            
        }.resume()
        
        
        
    }
    
    
}
