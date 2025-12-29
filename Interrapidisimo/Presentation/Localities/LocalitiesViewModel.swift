//
//  LocalitiesViewModel.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation
import Combine

@MainActor
final class LocalitiesViewModel: ObservableObject {
	@Published var localities: [Locality] = []
	@Published var isLoading = false
	@Published var errorMessage: String?

	private let getLocalitiesUseCase: GetLocalitiesUseCase

	init(getLocalitiesUseCase: GetLocalitiesUseCase? = nil) {
		self.getLocalitiesUseCase = getLocalitiesUseCase ?? .init()
	}

	func loadLocalities() async {
		isLoading = true
		errorMessage = nil

		do {
			localities = try await getLocalitiesUseCase.execute()
			isLoading = false
		} catch {
			errorMessage = error.localizedDescription
			isLoading = false
		}
	}

	func retry() {
		Task {
			await loadLocalities()
		}
	}
}
