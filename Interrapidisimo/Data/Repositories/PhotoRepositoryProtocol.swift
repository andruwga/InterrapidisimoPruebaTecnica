//
//  PhotoRepositoryProtocol.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation
import UIKit

protocol PhotoRepositoryProtocol {
    func savePhoto(_ image: UIImage, name: String) throws
    func getAllPhotos() throws -> [Photo]
    func getPhoto(byName name: String) throws -> Photo?
    func getNextPhotoNumber() throws -> Int
}

final class PhotoRepository: PhotoRepositoryProtocol {
    private let database: SQLiteClient

    init(database: SQLiteClient = .shared) {
        self.database = database
    }

    func savePhoto(_ image: UIImage, name: String) throws {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw DatabaseError.invalidData
        }

        
        let hex = imageData.map { String(format: "%02x", $0) }.joined()

        let query = """
        INSERT INTO photos (name, image_data)
        VALUES ('\(name)', X'\(hex)');
        """

        try database.execute(query)
    }

    func getAllPhotos() throws -> [Photo] {
        let query = "SELECT id, name, image_data, created_at FROM photos ORDER BY id ASC;"
        let results = try database.query(query)

        return results.compactMap { row in
            guard let id = row["id"] as? Int,
                  let name = row["name"] as? String,
                  let imageData = row["image_data"] as? Data,
                  let image = UIImage(data: imageData) else {
                return nil
            }

            return Photo(id: id, name: name, image: image)
        }
    }

    func getPhoto(byName name: String) throws -> Photo? {
        let query = "SELECT * FROM photos WHERE name = '\(name)' LIMIT 1;"
        let results = try database.query(query)

        guard let row = results.first,
              let id = row["id"] as? Int,
              let name = row["name"] as? String,
              let imageData = row["image_data"] as? Data,
              let image = UIImage(data: imageData) else {
            return nil
        }

        return Photo(id: id, name: name, image: image)
    }

    func getNextPhotoNumber() throws -> Int {
        let query = "SELECT MAX(id) as max_id FROM photos;"
        let results = try database.query(query)

        if let row = results.first,
           let maxId = row["max_id"] as? Int {
            return maxId + 1
        }

        return 1
    }
}
