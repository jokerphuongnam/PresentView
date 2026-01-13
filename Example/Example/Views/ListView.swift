import SwiftUI
import PresentView

struct ListView: View {
    @Binding var presented: [Presented<Screen>]
    
    var body: some View {
        List {
            ScrollView(.horizontal) {
                HStack {
                    ForEach((0..<100).map { $0 }, id: \.self) { index in
                        GeometryReader { proxy in
                            Button {
                                let globalFrame = proxy.frame(in: .global)
                                let newFrame = CGRect(
                                    x: globalFrame.minX,
                                    y: globalFrame.minY,
                                    width: globalFrame.width,
                                    height: globalFrame.height
                                )
                                
                                presented.context(item: .item(index: index), parentFrame: newFrame)
                            } label: {
                                Text("Text \(index)")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .frame(width: 50, height: 50)
                    }
                }
            }
            .listRowInsets(.init())
            
            ForEach((0..<100).map { $0 }, id: \.self) { index in
                GeometryReader { proxy in
                    Button {
                        let globalFrame = proxy.frame(in: .global)
                        let newFrame = CGRect(
                            x: globalFrame.minX,
                            y: globalFrame.minY,
                            width: globalFrame.width,
                            height: globalFrame.height
                        )
                        
                        presented.context(item: .item(index: index), parentFrame: newFrame)
                    } label: {
                        Text("Text \(index)")
                    }
                }
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach((0..<100).map { $0 }, id: \.self) { index in
                        GeometryReader { proxy in
                            Button {
                                let globalFrame = proxy.frame(in: .global)
                                let newFrame = CGRect(
                                    x: globalFrame.minX,
                                    y: globalFrame.minY,
                                    width: globalFrame.width,
                                    height: globalFrame.height
                                )
                                
                                presented.context(item: .item(index: index), parentFrame: newFrame)
                            } label: {
                                Text("Text \(index)")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .frame(width: 50, height: 50)
                    }
                }
            }
            .listRowInsets(.init())
        }
        .listStyle(.plain)
    }
}


struct ItemView: View {
    @Environment(\.dismissPresented) private var dismissPresented
    let item: Int
    
    var body: some View {
        VStack {
            Text("Item \(item)")
            
            Button {
                dismissPresented()
            } label: {
                Text("Cancel")
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
    }
}
