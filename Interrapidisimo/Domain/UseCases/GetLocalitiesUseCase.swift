//
//  GetLocalitiesUseCase.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation


struct GetLocalitiesUseCase {
    private let localityService: LocalityServiceProtocol

    init(localityService: LocalityServiceProtocol? = nil) {
		if Configuration.Flags.useMockLocalities {
			self.localityService = localityService ?? MockLocalityService()
		} else {
			self.localityService = localityService ?? InterrapidisimoAPI.LocalityService()
		}
    }

    func execute() async throws -> [Locality] {
        return try await localityService.getLocalities()
    }
}
