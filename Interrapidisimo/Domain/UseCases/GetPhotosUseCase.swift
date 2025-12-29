//
//  GetPhotosUseCase.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

struct GetPhotosUseCase {
    private let photoRepository: PhotoRepositoryProtocol

    init(photoRepository: PhotoRepositoryProtocol? = nil) {
        self.photoRepository = photoRepository ?? PhotoRepository()
    }

    func execute() throws -> [Photo] {
        return try photoRepository.getAllPhotos()
    }

    func getPhoto(byName name: String) throws -> Photo? {
        return try photoRepository.getPhoto(byName: name)
    }

    func getPhotosCount() throws -> Int {
        return try photoRepository.getAllPhotos().count
    }
}
