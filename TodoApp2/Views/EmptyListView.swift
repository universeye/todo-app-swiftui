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
    
    let images = ["todo1", "todo2", "todo3"]
    
    let tips = [
        "Use your time wisely.",
        "Slow and steady wins the race.",
        "Keep it short and sweet.",
        "Put hard tasks first",
        "Reward yourself after work",
        "Collect tasks ahead of time.",
        "Each night schedule for tomorrow."
    ]

    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    //MARK: - Body

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                Image("\(images.randomElement() ?? images[0])")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, maxWidth: 360, minHeight: 256, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                Text("\(tips.randomElement() ?? tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            }//: VStack
//            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .scaleEffect(isAnimated ? 1 : 0.5)
            .animation(.easeOut(duration: 0.5), value: isAnimated)
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
