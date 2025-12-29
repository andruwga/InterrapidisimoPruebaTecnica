//
//  LocalityService.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

extension InterrapidisimoAPI {
    struct LocalityService: LocalityServiceProtocol {
        private let apiClient: ApiClient

        init(apiClient: ApiClient = InterrapidisimoApiClient()) {
            self.apiClient = apiClient
        }

        func getLocalities() async throws -> [Locality] {
            let endpoint = Endpoint(
                path: Configuration.Endpoints.localities,
                method: .get
            )

            return try await apiClient.sendRequest(
                endpoint: endpoint,
                responseModel: [Locality].self
            )
        }
    }
}
