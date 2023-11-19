//
//  Bundle+.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/14/23.
//

import Foundation

extension Bundle {
    
    var PUBLIC_API_KEY: String {
        guard let file = self.path(forResource: "FavoriteCharacter", ofType: "plist") else { return "" }
        guard let resource = NSDictionary (contentsOfFile: file) else { return "" }
        guard let key = resource["PUBLIC_API_KEY"] as? String else { fatalError("Bundle Error")}
        return key
    }    
    
    var PRIVATE_API_KEY: String {
        guard let file = self.path(forResource: "FavoriteCharacter", ofType: "plist") else { return "" }
        guard let resource = NSDictionary (contentsOfFile: file) else { return "" }
        guard let key = resource["PRIVATE_API_KEY"] as? String else { fatalError("Bundle Error")}
        return key
    }

}
