//
//  Locality.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation

struct Locality: Codable, Identifiable {
	let id: UUID
	let abreviacionCiudad: String
	let nombreCompleto: String

	enum CodingKeys: String, CodingKey {
		case abreviacionCiudad = "AbreviacionCiudad"
		case nombreCompleto = "NombreCompleto"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = UUID()
		self.abreviacionCiudad = try container.decode(String.self, forKey: .abreviacionCiudad)
		self.nombreCompleto = try container.decode(String.self, forKey: .nombreCompleto)
	}

	
	init(abreviacionCiudad: String, nombreCompleto: String) {
		self.id = UUID()
		self.abreviacionCiudad = abreviacionCiudad
		self.nombreCompleto = nombreCompleto
	}
}
