//
//  MockLocalityService.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation


struct MockLocalityService: LocalityServiceProtocol {

	init() {}

	func getLocalities() async throws -> [Locality] {

		try? await Task.sleep(nanoseconds: 700_000_000)

		return createMockLocalities()
	}

	private func createMockLocalities() -> [Locality] {
		return [
			Locality(abreviacionCiudad: "BOG", nombreCompleto: "Bogotá D.C. - Cundinamarca"),
			Locality(abreviacionCiudad: "MED", nombreCompleto: "Medellín - Antioquia"),
			Locality(abreviacionCiudad: "CLO", nombreCompleto: "Cali - Valle del Cauca"),
			Locality(abreviacionCiudad: "BAQ", nombreCompleto: "Barranquilla - Atlántico"),
			Locality(abreviacionCiudad: "CTG", nombreCompleto: "Cartagena - Bolívar"),
			Locality(abreviacionCiudad: "BUC", nombreCompleto: "Bucaramanga - Santander"),
			Locality(abreviacionCiudad: "CUC", nombreCompleto: "Cúcuta - Norte de Santander"),
			Locality(abreviacionCiudad: "PEI", nombreCompleto: "Pereira - Risaralda"),
			Locality(abreviacionCiudad: "SMR", nombreCompleto: "Santa Marta - Magdalena"),
			Locality(abreviacionCiudad: "IBE", nombreCompleto: "Ibagué - Tolima"),
			Locality(abreviacionCiudad: "MAN", nombreCompleto: "Manizales - Caldas"),
			Locality(abreviacionCiudad: "VIL", nombreCompleto: "Villavicencio - Meta"),
			Locality(abreviacionCiudad: "ARM", nombreCompleto: "Armenia - Quindío"),
			Locality(abreviacionCiudad: "NEI", nombreCompleto: "Neiva - Huila"),
			Locality(abreviacionCiudad: "MON", nombreCompleto: "Montería - Córdoba"),
			Locality(abreviacionCiudad: "PAL", nombreCompleto: "Palmira - Valle del Cauca"),
			Locality(abreviacionCiudad: "BGA", nombreCompleto: "Buenaventura - Valle del Cauca"),
			Locality(abreviacionCiudad: "TUL", nombreCompleto: "Tuluá - Valle del Cauca"),
			Locality(abreviacionCiudad: "SIN", nombreCompleto: "Sincelejo - Sucre"),
			Locality(abreviacionCiudad: "POP", nombreCompleto: "Popayán - Cauca"),
			Locality(abreviacionCiudad: "VAL", nombreCompleto: "Valledupar - Cesar"),
			Locality(abreviacionCiudad: "RIO", nombreCompleto: "Riohacha - La Guajira"),
			Locality(abreviacionCiudad: "TUN", nombreCompleto: "Tunja - Boyacá"),
			Locality(abreviacionCiudad: "SBA", nombreCompleto: "Sabanalarga - Atlántico"),
			Locality(abreviacionCiudad: "SOA", nombreCompleto: "Soacha - Cundinamarca"),
			Locality(abreviacionCiudad: "ENV", nombreCompleto: "Envigado - Antioquia"),
			Locality(abreviacionCiudad: "ITA", nombreCompleto: "Itagüí - Antioquia"),
			Locality(abreviacionCiudad: "BEL", nombreCompleto: "Bello - Antioquia"),
			Locality(abreviacionCiudad: "SOL", nombreCompleto: "Soledad - Atlántico"),
			Locality(abreviacionCiudad: "DOS", nombreCompleto: "Dosquebradas - Risaralda")
		]
	}
}
