//
//  VersionService.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

extension InterrapidisimoAPI {
    struct VersionService {
		let apiClient: ApiClient

        init(apiClient: ApiClient? = nil) {
            self.apiClient = apiClient ?? InterrapidisimoApiClient()
        }

        func checkVersion() async throws -> VersionControlResponse {
            let endpoint = Endpoint(
                path: Configuration.Endpoints.versionControl,
                method: .get
            )

            return try await apiClient.sendRequest(
                endpoint: endpoint,
                responseModel: VersionControlResponse.self
            )
        }
    }
}
