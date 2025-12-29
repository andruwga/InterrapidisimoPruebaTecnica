//
//  SchemaService.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

extension InterrapidisimoAPI {
	struct SchemaService: SchemaServiceProtocol {
		private let apiClient: ApiClient

		init(apiClient: ApiClient = InterrapidisimoApiClient()) {
			self.apiClient = apiClient
		}

		func getSchema() async throws -> SchemaResponse {
			let endpoint = Endpoint(
				path: Configuration.Endpoints.schema,
				method: .get
			)

			return try await apiClient.sendRequest(
				endpoint: endpoint,
				responseModel: SchemaResponse.self
			)
		}
	}
}
