//
//  BasketView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 22.05.2024.
//

import SwiftUI

struct BasketView: View {

    @StateObject private var viewModel = BasketViewModel()
    
    var body: some View {
        ZStack {
                    Color(.white)
                        .ignoresSafeArea(.all)
                    VStack {
                        Spacer().frame(height: 30)
                        VStack {
                            ForEach(0..<viewModel.goods.count) { good in
                                makeGood(index: good)
                            }
                        }.background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 350, height: 400)
                            )
                        Spacer()
                            .frame(height: 50)

                        List {
                            Text("Ваша корзина")
                                .foregroundColor(.black)
                                .font(.system(size: 25, weight: .bold))
                            ForEach(viewModel.Products, id: \.id) { good in
                                makeCell(item: good)
                            }
                            Text("Итого: \(viewModel.sum)")
                                .font(.system(size: 20, weight: .bold))
                        }
                        removeButton
                        Spacer()
                    }

                }
      }

    private var removeButton: some View {
            Button {
                viewModel.removeAll()
            } label: {
                Text("Очистить")
            }

        }

    private func makeCell(item: Good) -> some View {
            HStack {
                Text(item.name)
                    .frame(width: 180, height: 50, alignment: .leading)
                Text("\(item.price) руб.")
            }
        }

      private var headerView: some View {
          Text("Список товаров")
              .font(.largeTitle)
              .bold()
      }

    func makeGood(index: Int) -> some View {
            HStack(spacing: 40) {

                Text("\(viewModel.goods[index].name) - \(viewModel.goods[index].price) руб.")
                    .frame(width: 160, height: 20,alignment: .leading)
                    .foregroundColor(.black)
                    .font(.system(size: 15, weight: .bold))

                Button {
                    viewModel.addGood(index: index)
                } label: {
                    Text("+")
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .bold))
                }

                Button {
                    viewModel.removeGood(index: index)
                } label: {
                    Text("-")
                        .foregroundColor(.red)
                        .font(.system(size: 30, weight: .bold))
                }
            }.padding(.horizontal, 10)
        }

}

#Preview {
    BasketView()
}
