//
//  CheckVersionUseCase.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation                                                                                                            
                                                                                                                               
                                                          
struct CheckVersionUseCase {
  private let versionService: InterrapidisimoAPI.VersionService

	init(versionService: InterrapidisimoAPI.VersionService? = nil) {
	  self.versionService = versionService ?? .init()
  }
																														                                                                       
  func execute() async throws -> VersionControlResponse {                                                                  
	  return try await versionService.checkVersion()                                                                       
  }                                                                                                                        
																														   

  func compareVersions(remoteVersion: String, localVersion: String) -> VersionStatus {
      #if DEBUG
      print("🔍 Comparando versiones:")
      #endif

      
      let normalizedRemote = normalizeVersion(remoteVersion)
      let normalizedLocal = normalizeVersion(localVersion)

      #if DEBUG
      print("   - Remota: \(normalizedRemote)")
      print("   - Local: \(normalizedLocal)")
      #endif

      let remote = normalizedRemote.split(separator: ".").compactMap { Int($0) }
      let local = normalizedLocal.split(separator: ".").compactMap { Int($0) }

      for i in 0..<max(remote.count, local.count) {
          let r = i < remote.count ? remote[i] : 0
          let l = i < local.count ? local[i] : 0

          if r > l {
              #if DEBUG
              print("   ➡️ Resultado: Actualización requerida")
              #endif
              return .updateRequired
          } else if l > r {
              #if DEBUG
              print("   ➡️ Resultado: Versión superior")
              #endif
              return .versionAhead
          }
      }

      #if DEBUG
      print("   ➡️ Resultado: Actualizada")
      #endif
      return .upToDate
  }

  private func normalizeVersion(_ version: String) -> String {
      let components = version.split(separator: ".").map { String($0) }

      switch components.count {
      case 1:
          return "\(components[0]).0.0"
      case 2:
          return "\(components[0]).\(components[1]).0"
      default:
          return version
      }
  }                                                                                                                        
}     

enum VersionStatus {
	case upToDate
	case updateRequired
	case versionAhead
	
	var message: String {
		switch self {
			case .upToDate:
				return "La aplicación está actualizada"
			case .updateRequired:
				return "Actualización requerida. Por favor actualice la aplicación."
			case .versionAhead:
				return "Versión superior detectada. Ambiente inconsistente."
		}
	}
	
	var shouldBlock: Bool {
		switch self {
			case .updateRequired, .versionAhead:
				return true
			case .upToDate:
				return false
		}
	}
}  
