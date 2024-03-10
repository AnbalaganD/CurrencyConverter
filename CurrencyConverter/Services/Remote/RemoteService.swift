//
//  RemoteService.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

///This is act as a namespace
enum Remote { }

protocol RemoteService: Sendable {
    func execute<T: Decodable>(request: Remote.Request) async throws -> T
}

final class RemoteServiceImp: RemoteService, @unchecked Sendable {
    private let urlSession: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private var preInterceptors = [PreInterceptor]()
    
    init(
        urlSession: URLSession = .shared,
        jsonEncoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init()
    ) {
        self.urlSession = urlSession
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
    
    func execute<T>(request: Remote.Request) async throws -> T where T : Decodable {
        let url = try getRequestURL(request)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.header
        
        if let body = request.body {
            guard let bodyData = try? body.asBody(from: jsonEncoder) else {
                throw RemoteError.invalidBody
            }
            urlRequest.httpBody = bodyData
        }
        
        urlRequest = try await preInterceptors.reduce(urlRequest) { result, interceptor in
            try await interceptor.modify(request: result)
        }
        
        let (data, urlResponse) = try await urlSession.data(for: urlRequest)
        
        if let httpURLResponse = urlResponse as? HTTPURLResponse, !httpURLResponse.isSuccess  {
            throw RemoteError.general(
                status: httpURLResponse.description,
                statusCode: httpURLResponse.statusCode
            )
        }
        
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw RemoteError.parsingError(reason: error.localizedDescription)
        }
    }
    
    func setPreInterceptor(_ interceptor: PreInterceptor) {
        preInterceptors.append(interceptor)
    }
    
    private func getRequestURL(_ request: Remote.Request) throws -> URL {
        guard let url = request.url.asURL() else {
            throw RemoteError.invalidURL
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw RemoteError.invalidURL
        }
        
        urlComponents.queryItems = request.parameter?.map {
            URLQueryItem(
                name: $0.key,
                value: $0.value
            )
        }
        
        guard let constructedURL = urlComponents.url else {
            throw RemoteError.invalidURL
        }
        
        return constructedURL
    }
}

extension Remote {
    static let sharedRemoteService: RemoteService = {
        let remoteService = RemoteServiceImp()
        remoteService.setPreInterceptor(AuthenticationInterceptor())
        return remoteService
    }()
}
