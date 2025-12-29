//
//  LocalityServiceProtocol.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation


protocol LocalityServiceProtocol {
	func getLocalities() async throws -> [Locality]
}
