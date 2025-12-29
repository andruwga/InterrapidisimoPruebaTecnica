//
//  TablesView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


 import SwiftUI                                                                                                               
                                                                                                                               
  struct TablesView: View {                                                                                                    
      @StateObject private var viewModel = TablesViewModel()                                                                   
                                                                                                                               
      var body: some View {                                                                                                    
          ZStack {                                                                                                             
              if viewModel.isLoading {                                                                                         
                  LoadingView()                                                                                                
              } else if let error = viewModel.errorMessage {                                                                   
                  ErrorView(message: error) {                                                                                  
                      viewModel.loadTables()                                                                                   
                  }                                                                                                            
              } else if viewModel.tables.isEmpty {                                                                             
                  EmptyStateView(                                                                                              
                      message: "No hay tablas sincronizadas",                                                                  
                      icon: "tray"                                                                                             
                  )                                                                                                            
              } else {                                                                                                         
                  List(viewModel.tables) { table in                                                                            
                      HStack {                                                                                                 
                          Image(systemName: "tablecells")                                                                      
                              .foregroundColor(.blue)                                                                          
                          Text(table.tableName)                                                                                
                              .font(.body)                                                                                     
                      }                                                                                                        
                      .padding(.vertical, 4)                                                                                   
                  }                                                                                                            
              }                                                                                                                
          }                                                                                                                    
          .navigationTitle("Tablas")                                                                                           
          .navigationBarTitleDisplayMode(.inline)                                                                              
          .onAppear {                                                                                                          
              viewModel.loadTables()                                                                                           
          }                                                                                                                    
      }                                                                                                                        
  }  