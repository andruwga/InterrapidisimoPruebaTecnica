//
//  LoginView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import SwiftUI                                                                                                               
                                                                                                                               
  struct LoginView: View {                                                                                                     
      @StateObject private var viewModel = LoginViewModel()                                                                    
      @Binding var navigationPath: [AppRoute]                                                                                  
                                                                                                                               
      var body: some View {                                                                                                    
          ZStack {                                                                                                             
              VStack(spacing: 30) {
                  Image(systemName: "person.circle.fill")                                                                      
                      .font(.system(size: 100))                                                                                
                      .foregroundColor(.blue)                                                                                  
                                                                                                                               
                  Text("Iniciar Sesión")                                                                                       
                      .font(.largeTitle)                                                                                       
                      .fontWeight(.bold)                                                                                       
                                                                                                                               
                  Text("Usuario: pam.meredy21")                                                                                
                      .font(.subheadline)                                                                                      
                      .foregroundColor(.secondary)                                                                             
                                                                                                                               
                                                                                                         
                  PrimaryButton(title: "Ingresar", icon: "arrow.right") {                                                      
                      Task {                                                                                                   
                          await viewModel.login {                                                                              
                              navigationPath.append(.home)                                                                     
                          }                                                                                                    
                      }                                                                                                        
                  }                                                                                                            
                  .padding(.horizontal, 40)                                                                                    
                  .disabled(viewModel.isLoading)                                                                               
              }                                                                                                                
              .padding()                                                                                                       
                                                                                                                               
              if viewModel.isLoading {                                                                                         
                  LoadingView()                                                                                                
                      .background(Color.black.opacity(0.3))                                                                    
              }                                                                                                                
          }                                                                                                                    
          .alert("Error", isPresented: $viewModel.showError) {                                                                 
              Button("Aceptar", role: .cancel) { }                                                                             
          } message: {                                                                                                         
              Text(viewModel.errorMessage)                                                                                     
          }                                                                                                                    
          .navigationBarBackButtonHidden(true)                                                                                 
      }                                                                                                                        
  }                     
