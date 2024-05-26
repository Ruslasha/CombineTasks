//
//  TaskView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 26.05.2024.
//

import SwiftUI
import Combine

#Preview {
    TaskView()
}

enum ViewStateGoods<Model> {
    case connecting(_ data: Model)
    case loading(_ data: Model)
    case loaded(_ data: Model)
    case error(_ error: Error)
}


struct TaskView: View {

    @StateObject private var viewModel = TaskViewModel()
    @State var showFirstLoading = false
    @State var showSecondLoading = false
    @State var showSecondTable = false

    var body: some View {
        VStack {
            switch viewModel.state {
                case .connecting(let time):
                    VStack {
                        Text("Time left \(time)")
                            .font(.title2)
                    }
                    .background(.white)
                    .frame(height: 60)
                case .loading(let time):
                    VStack {
                        Text("Time left \(time)")
                    }
                    .background(.white)
                    .frame(height: 60)
                case .loaded(let time):
                    Text("Time left \(time)")
                        .background(.white)
                        .frame(height: 60)
                case .error(let error):
                    Text(error.localizedDescription)
                        .background(.white)
                        .frame(height: 60)
            }
        }

        if showFirstLoading {
            VStack {
                Text("Подключение к серверу")
                    .font(.largeTitle)
                    .transition(.slide)
            }
        } else if showSecondLoading {
            VStack {
                Text("Загрузка товаров")
                    .transition(.slide)
                    .font(.title)
            }
        } else {
            if showSecondTable {
                VStack(spacing: 20) {
                    Form {
                        List(viewModel.dataToView, id: \.self) { item in
                            HStack {
                                Image(systemName: item.imageName)
                                Text("\(item.name) \(item.price) руб")
                            }
                        }
                    }
                }
            }
        }
        Spacer()
        Button("Старт") {
            viewModel.start()
            withAnimation(.linear(duration: 2)) {
                showFirstLoading.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 2)) {
                    showFirstLoading.toggle()
                    showSecondLoading.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                withAnimation(.easeInOut(duration: 2)) {
                    showSecondLoading.toggle()
                    viewModel.fetch()
                    showSecondTable.toggle()
                }
            }
        }
    }
}
