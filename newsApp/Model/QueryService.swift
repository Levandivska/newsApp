////
////  QueryService.swift
////  newsApp
////
////  Created by оля on 04.12.2020.
////
//

import Foundation


class QueryService {
    var lastResponse : HTTPURLResponse? = nil
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var errorMessage = ""
    
    var news: [New] = []
    
    var sources: [FilterItem] = []
    var countries: [FilterItem] = []
    var categories: [FilterItem] = []

    func getData(request: URLRequest, completion: @escaping (Data?, String) -> Void){
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in

            defer {
                self?.dataTask = nil
            }
            
            guard error == nil else {
                self?.errorMessage = "Error: error calling GET"
                return
            }

            guard let data = data else {
                self?.errorMessage = "Error: Did not receive data"
                return
            }
            
            DispatchQueue.main.async {
                completion(data, self?.errorMessage ?? "")
            }
        }
        dataTask?.resume()
    }

    func getSources(request: URLRequest, completion: @escaping ([FilterItem]?, String) -> Void) {
        
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " +
                                        error.localizedDescription + "\n"
    
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200{
    
                self?.updateSources(data: data)
                
                DispatchQueue.main.async {
                    completion(self?.sources, self?.errorMessage ?? "")
                }

            }
        }
        dataTask?.resume()

    }
    
    func getNews(request: URLRequest, completion: @escaping ([New]?, String) -> Void) {

        dataTask?.cancel()

        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " +
                                        error.localizedDescription + "\n"
    
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200{
                
                self?.updateNews(data: data)
                DispatchQueue.main.async {
                    completion(self?.news, self?.errorMessage ?? "")
                }
            }
        }

        dataTask?.resume()

    }
    
    func updateNews(data: Data){
        self.news = []
        var response: [String: Any]?
        
        response = makeJson(data: data)

        guard let array = response!["articles"] as? [Any] else {
            self.errorMessage += "Dictionary does not contain results key\n"
          return
        }
        
        for newJson in array {
            if let newJson = newJson as? [String: Any],
               let new = New(json: newJson){
                    self.news.append(new)
                }

                else {
                    self.errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
    
    
    func updateSources(data: Data){
        self.sources = []
        var response: [String: Any]?

        response = makeJson(data: data)

        guard let array = response!["sources"] as? [Any] else {
            self.errorMessage += "Dictionary does not contain results key\n"
          return
        }
                    
        for item in array {
            if let json = item as? [String: Any],
               let source = FilterItem(sourceJson: json){
                    self.sources.append(source)
                }

                else {
                    self.errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
    
    func makeJson(data: Data) -> [String: Any]?{
        var json: [String: Any]?
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseError as NSError {
            self.errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
          return nil
        }
        
        return json
    }
        
}

