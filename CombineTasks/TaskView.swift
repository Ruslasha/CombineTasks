//
//  ContentView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 20.05.2024.
//

import SwiftUI

struct TaskView: View {

    @StateObject private var viewModel = TaskViewModel()
    @State private var rotating = false

    var errorAlertView: some View {
        VStack {
            Text(viewModel.alertText.value)
                .foregroundStyle(.black)
            Button(role: .cancel) {
                viewModel.showErrorAlert.value.toggle()
            } label: {
                Text("Cancel")
                    .foregroundStyle(.red)
            }
            .foregroundStyle(.blue)
        }
        .frame(width: 300, height: 200)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.white)))
        .padding(.top, 100)
        .shadow(radius: 15)
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Image("loading")
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: rotating ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: rotating)
                    .transition(.opacity)
                    .onAppear {
                        self.rotating = true
                    }
                    .animation(.default, value: viewModel.showPortal.value)
            case .data:
                VStack(spacing: 20) {
                    Image("logoRick")
                        .frame(width: 350, height: 100)
                    List(viewModel.dataToView.indices, id: \.self) { itemIndex in
                        RoundedRectangle(cornerRadius: 10)
                            .shadow(color: .gray, radius: 5, x: 1, y: 1)
                            .frame(width: 350, height: 320)
                            .overlay(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Image(uiImage: (UIImage(data: viewModel.dataToView[itemIndex].imageData ?? Data()) ?? UIImage(named: "character")!))
                                        .resizable()
                                        .frame(width: 340, height: 230)
                                    RoundedRectangle(cornerRadius: 10)
                                        .background(.white)
                                        .overlay(alignment: .leading) {
                                            Text("\(viewModel.dataToView[itemIndex].charName ?? "")")
                                                .font(.title2)
                                                .bold()
                                                .foregroundStyle(.black)
                                                .frame(width: 350, height: 40)
                                                .padding(.zero)
                                        }
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.gray.opacity(0.3))
                                        .overlay(alignment: .center) {
                                            HStack {
                                                Image("Play")
                                                    .frame(width: 50, height: 50)
                                                    .padding(.leading)
                                                Text("\(viewModel.dataToView[itemIndex].name) | \(viewModel.dataToView[itemIndex].episode)")
                                                    .bold()
                                                    .foregroundStyle(.black)
                                                Spacer()
                                                Image("heartIcon")
                                                    .frame(width: 50, height: 50)
                                                    .padding(.trailing)
                                            }
                                        }
                                        .frame(width: 350, height: 63)
                                }
                            }
                    }
                    .listStyle(PlainListStyle())
                    .foregroundStyle(.white)
                    .background(.white)
                }

            case .error:
                if viewModel.showErrorAlert.value {
                    errorAlertView
                        .transition(AnyTransition.opacity)
                        .zIndex(1)
                }
            }
        }
        .onAppear {
            viewModel.fetch()

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                viewModel.fetchCharacters()
            }
        }
    }
}

#Preview {
    TaskView()
}
