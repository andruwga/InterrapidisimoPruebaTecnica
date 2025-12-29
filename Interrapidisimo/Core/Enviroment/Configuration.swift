//
//  Configuration.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

struct Configuration {
	static let baseURL = "https://apitesting.interrapidisimo.co"

	enum Endpoints {
		static let versionControl = "/apicontrollerpruebas/api/ParametrosFramework/ConsultarParametrosFramework/VPStoreAppControl"
		static let login = "/FtEntregaElectronica/MultiCanales/ApiSeguridadPruebas/api/Seguridad/AuthenticaUsuarioApp"
		static let schema = "/apicontrollerpruebas/api/SincronizadorDatos/ObtenerEsquema/true"
		static let localities = "/apicontrollerpruebas/api/ParametrosFramework/ObtenerLocalidadesRecogidas"
	}


	enum Flags {
		static let useMockSchema = true
		static let useMockLocalities = true
	}
}
