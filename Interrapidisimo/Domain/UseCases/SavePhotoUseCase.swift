//
//  SavePhotoUseCase.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation
import UIKit

struct SavePhotoUseCase {
    private let photoRepository: PhotoRepositoryProtocol

    init(photoRepository: PhotoRepositoryProtocol? = nil) {
        self.photoRepository = photoRepository ?? PhotoRepository()
    }


    func execute(image: UIImage) throws -> Photo {
        
        let nextNumber = try photoRepository.getNextPhotoNumber()

        
        let photoName = String(format: "photo-%03d", nextNumber)

        
        try photoRepository.savePhoto(image, name: photoName)

        
        return Photo(id: nextNumber, name: photoName, image: image)
    }
}
