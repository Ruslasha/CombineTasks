//
//  ContentView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 20.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TaskViewModel()
       var body: some View {
           VStack {
               Form {
                   Section() {
                       List(viewModel.dataToView, id: \.self) { item in
                           Text(item)
                       }
                   }
               }
               HStack {
                   Button("Добавить фрукт") {
                       viewModel.addFruit()
                   }
                   Button("Удалить фрукт") {
                       viewModel.deleteLastFruct()
                   }
               }
           }
           .onAppear(){
               viewModel.fetch()
           }
       }
}

#Preview {
    ContentView()
}
