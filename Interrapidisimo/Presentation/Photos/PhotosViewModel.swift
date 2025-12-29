//
//  PhotosViewModel.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation
import UIKit
import AVFoundation
import Combine

@MainActor
final class PhotosViewModel: ObservableObject {
	@Published var photos: [Photo] = []
	@Published var isLoading = true
	@Published var errorMessage: String?
	@Published var showCamera = false
	@Published var showImagePicker = false
	@Published var selectedPhotoIndex: Int?
	@Published var cameraPermissionDenied = false

	private let savePhotoUseCase: SavePhotoUseCase
	private let getPhotosUseCase: GetPhotosUseCase

	init(
		savePhotoUseCase: SavePhotoUseCase? = nil,
		getPhotosUseCase: GetPhotosUseCase? = nil
	) {
		self.savePhotoUseCase = savePhotoUseCase ?? .init()
		self.getPhotosUseCase = getPhotosUseCase ?? .init()
	}

	func loadPhotos() {
		isLoading = true
		errorMessage = nil

		do {
			photos = try getPhotosUseCase.execute()
			isLoading = false
		} catch {
			errorMessage = error.localizedDescription
			isLoading = false
		}
	}

	func checkCameraPermission() async -> Bool {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			return true

		case .notDetermined:
			return await AVCaptureDevice.requestAccess(for: .video)

		case .denied, .restricted:
			cameraPermissionDenied = true
			return false

		@unknown default:
			return false
		}
	}

	func openCamera() async {
		let hasPermission = await checkCameraPermission()
		if hasPermission {
			showCamera = true
		}
	}

	func savePhoto(_ image: UIImage) {
		do {
			let _ = try savePhotoUseCase.execute(image: image)
			loadPhotos()
		} catch {
			errorMessage = error.localizedDescription
		}
	}

	func selectPhoto(_ photo: Photo) {
		if let index = photos.firstIndex(where: { $0.id == photo.id }) {
			selectedPhotoIndex = index
		}
	}
}
