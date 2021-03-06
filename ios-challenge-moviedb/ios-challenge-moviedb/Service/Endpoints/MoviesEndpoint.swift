//
//  MoviesEndpoint.swift
//  ios-challenge-moviedb
//
//  Created by Giovanni Severo Barros on 21/02/20.
//  Copyright © 2020 Giovanni Severo Barros. All rights reserved.
//

import Alamofire

/**
 Movies Endpoints used to request movies related information
 
 - Return: The requested information
 */
enum MoviesEndpoint: APIConfiguration {
    /**
     Get popular Movies
     
     - Parameters:
        - page: Requested Page
     */
    case popularMovies(page: Int)
    
    /**
     Get all genres
     */
    case genres
    
    // MARK: - Method
    /**
     Method that will be used depending on endpoint case
     */
    var method: HTTPMethod {
        switch self {
        case .genres, .popularMovies:
            return .get
        }
    }
    
    // MARK: - Path
    /**
     Path that will be used depending on endpoint case
     */
    var path: String {
        switch self {
        case .popularMovies(let page):
            return "/movie/popular?api_key=\(Constants.APIParameterKey.apiKey)&page=\(page)"
        case .genres:
            return "/genre/movie/list?api_key=\(Constants.APIParameterKey.apiKey)"
        }
    }
    
    // MARK: - Parameters
    /**
     Parameters that will be used depending on the request type
     */
    var parameters: Parameters? {
        switch self {
        case .genres, .popularMovies:
            return nil
        }
    }
    
    // MARK: - Create URL Request
    /**
     Function that creates an URL Request
     */
    func asURLRequest() throws -> URLRequest {
        let baseAndPath = Constants.ProductionServer.base + path
        let url = try baseAndPath.asURL()
        var urlRequest = URLRequest(url: url)

        // Setting url request method
        urlRequest.method = method
        
        // Setting headers
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters,
                                                                 options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
