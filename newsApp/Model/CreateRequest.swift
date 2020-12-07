//
//  CreateRequest.swift
//  newsApp
//
//  Created by оля on 07.12.2020.
//

import Foundation

class CreateRequest{
    
    let topsUrlStr = "http://newsapi.org/v2/top-headlines"
    let sourcesUrlStr = "http://newsapi.org/v2/sources"
    
    let apiKey = "47690b3eaf164e429114bc47f96d8b17"
    
    let sortBy = "publishedAt"
    
    func getTopsforCountry(conuntry: String) -> URLRequest?{
        var urlComponents = URLComponents(string: topsUrlStr)
            urlComponents?.queryItems = [
                        URLQueryItem(name: "country", value: conuntry),
                        URLQueryItem(name: "sortBy", value: sortBy),
                        URLQueryItem(name: "apiKey", value: apiKey)
                    ]
        
        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getTopsforSources(sources: String) -> URLRequest? {
        var urlComponents = URLComponents(string: topsUrlStr)
            urlComponents?.queryItems = [
                        URLQueryItem(name: "sources", value: sources),
                        URLQueryItem(name: "sortBy", value: sortBy),
                        URLQueryItem(name: "apiKey", value: apiKey)
                    ]
            
        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getTopsforCategory(category: String) -> URLRequest?{
        var urlComponents = URLComponents(string: topsUrlStr)
            urlComponents?.queryItems = [
                        URLQueryItem(name: "category", value: category),
                        URLQueryItem(name: "sortBy", value: sortBy),
                        URLQueryItem(name: "apiKey", value: apiKey)
                    ]
            
        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getAllSources() -> URLRequest?{
        let urlStr = "https://newsapi.org/v2/sources?apiKey=" + apiKey
        guard let url = URL(string: urlStr) else { return nil }
        return URLRequest(url: url)
    }
    
}
