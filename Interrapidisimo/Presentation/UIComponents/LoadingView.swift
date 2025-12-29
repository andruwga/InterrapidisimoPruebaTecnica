//
//  LoadingView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


  import SwiftUI                                                                                                               
                                                                                                                               
  struct LoadingView: View {                                                                                                   
      var body: some View {                                                                                                    
          VStack(spacing: 16) {                                                                                                
              ProgressView()                                                                                                   
                  .scaleEffect(1.5)                                                                                            
              Text("Cargando...")                                                                                              
                  .font(.subheadline)                                                                                          
                  .foregroundColor(.secondary)                                                                                 
          }                                                                                                                    
          .frame(maxWidth: .infinity, maxHeight: .infinity)                                                                    
      }                                                                                                                        
  }  