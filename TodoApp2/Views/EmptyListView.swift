//
//  EmptyListView.swift
//  TodoApp2
//
//  Created by Terry Kuo on 2021/8/5.
//

import SwiftUI

struct EmptyListView: View {
    //MARK: - Properties
    
    @State private var isAnimated: Bool = false
    
    let images = ["todoman1", "todoman2", "todoman3"]
    
    let tips = [
        "Use your time wisely.",
        "Slow and steady wins the race",
        "Keep it short and sweet",
        "Put hard tasks first",
        "Reward yourself after work",
        "Collect tasks ahead of time.",
        "Each night schedule for tomorrow"
    ]

    //MARK: - Body

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image("\(images.randomElement() ?? images[0])")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, maxWidth: 360, minHeight: 256, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                
                Text("\(tips.randomElement() ?? tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                
            }//: VStack
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(x: isAnimated ? 0 : 0, y: isAnimated ? 0 : -50)
            .animation(.easeOut(duration: 1.5))
            .onAppear {
                self.isAnimated.toggle()
            }
        }//: ZStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
}


//MARK: - Preview

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyListView()
                .environment(\.colorScheme, .light)
            EmptyListView()
                .environment(\.colorScheme, .dark)
        }
    }
}
