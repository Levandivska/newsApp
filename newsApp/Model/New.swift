//
//  New.swift
//  newsApp
//
//  Created by оля on 04.12.2020.
//

import Foundation

class New {
    
    var queryService = QueryService()
    
    let title: String
    let source: String
    let author: String
    let description: String
    let urlToImage: URL
    var imageData: Data?
    let url: URL
    
    init(title: String, source: String, author: String, description: String, urlToImage: URL, url: URL) {
        self.title = title
        self.author = author
        self.source = source
        self.description = description
        self.urlToImage = urlToImage
        self.url = url
        setImageData(imageUrl: urlToImage)
    }
    
    func setImageData(imageUrl: URL){
        let request = URLRequest(url: url)
        self.queryService.getData(request: request) { [weak self] (result, errorMessage) in
            if let result = result{
                self?.imageData = result
            }
        }
    }
}

extension New{
    convenience init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
              let author = json["author"] as? String,
            let description = json["description"] as? String,
            let sourceDict = json["source"] as? [String: Any],
            let source = sourceDict["name"] as? String,
            let urlToImageStr = json["urlToImage"] as? String,
            let urlToImage = URL(string: urlToImageStr),
            let urlStr = json["url"] as? String,
            let url = URL(string: urlStr)
        else {
            return nil
        }
        
        self.init(title: title, source: source, author: author, description: description, urlToImage: urlToImage, url: url)
    }
}
