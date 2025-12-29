//
//  VersionControlResponse.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation

struct VersionControlResponse: Codable {
    let versionApp: String
    let requireUpdate: Bool?

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let version = try? container.decode(String.self) {
            self.versionApp = version
            self.requireUpdate = nil
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.versionApp = try container.decode(String.self, forKey: .versionApp)
            self.requireUpdate = try? container.decode(Bool.self, forKey: .requireUpdate)
        }
    }

    enum CodingKeys: String, CodingKey {
        case versionApp = "VersionApp"
        case requireUpdate = "RequireUpdate"
    }
} 
