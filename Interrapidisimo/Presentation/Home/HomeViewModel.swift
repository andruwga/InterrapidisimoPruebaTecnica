//
//  HomeViewModel.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation
import Combine

@MainActor                                                                                                                   
  final class HomeViewModel: ObservableObject {                                                                                
      @Published var user: User?                                                                                               
      @Published var isLoading = true                                                                                          
      @Published var errorMessage: String?                                                                                     
                                                                                                                               
	  private let loginUseCase: LoginUseCase

      init(loginUseCase: LoginUseCase? = nil) {
          self.loginUseCase = loginUseCase ?? .init()
      }                                                                                                                        
                                                                                                                               
      func loadUser() {
          do {
              user = try loginUseCase.getStoredUser()
              isLoading = false
          } catch {
              errorMessage = error.localizedDescription
              isLoading = false
          }
      }

      func logout() {
          do {
              try loginUseCase.logout()
              user = nil
          } catch {
              errorMessage = error.localizedDescription
          }
      }
  }     
