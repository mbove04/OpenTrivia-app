//
//  JsonDecodable.swift
//  OpenTrivia
//
//  Created by Sailor on 18/08/2019.
//  Copyright © 2019 sailor.OpenTrivia. All rights reserved.
//

import Foundation

protocol JsonDecodable: Decodable {
    init?(jsonString: String)
}

extension JsonDecodable {
    init?(jsonString: String)  {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        let decoder = JSONDecoder()
        if let decodable  = try? decoder.decode(Self.self, from: data){
            self = decodable
            print("Decode successful! \n------------------")
        } else {
            return nil
        }
    }
}
