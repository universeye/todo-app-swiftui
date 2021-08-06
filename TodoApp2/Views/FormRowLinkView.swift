//
//  FormRowLinkView.swift
//  TodoApp2
//
//  Created by Terry Kuo on 2021/8/6.
//

import SwiftUI

struct FormRowLinkView: View {
    //MARK: - Properties
    var icon: String
    var color: Color
    var text: String
    var link: String
    
    
    //MARK: - Body
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(text).foregroundColor(.gray)
            Spacer()
            
            Button(action: {
                //open a link
                guard let url = URL(string: self.link),
                      UIApplication.shared.canOpenURL(url) else { return }
                
                UIApplication.shared.open(url as URL)
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }).accentColor(Color(.systemGray2))
            
        }
    }
}


//MARK: - Preview
struct FormRowLinkView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowLinkView(icon: "gear", color: Color.green, text: "Weed", link: "https://tw.youtube.com")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
