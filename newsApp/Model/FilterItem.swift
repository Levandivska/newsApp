//
//  FilterItem.swift
//  newsApp
//
//  Created by оля on 06.12.2020.
//

import Foundation

class FilterItem {
    let fullName: String
    let nameForQuery: String
    var filterType: String? = nil
    
    init(fullName: String, nameForQuery: String, filterType: String? = nil){
        self.fullName = fullName
        self.nameForQuery = nameForQuery
        self.filterType = filterType
    }

    convenience init?(sourceJson: [String: Any]){
        guard let fullName = sourceJson["name"] as? String,
              let nameForQuery = sourceJson["id"] as? String
        else { return nil }
        
        self.init(fullName: fullName, nameForQuery: nameForQuery)
    }
}
