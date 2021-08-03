//
//  ContentView.swift
//  ToDoApp
//
//  Created by Terry Kuo on 2021/8/2.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showingAddTodoView: Bool = false
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    var body: some View {
        NavigationView {
            List(0 ..< 5) { item in
                Text("Hello, World!")
            }//: List
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        //Show add todo View
                                        self.showingAddTodoView.toggle()
                                    }, label: {
                                        Image(systemName: "plus")
                                    })//: Add Button
                                    .sheet(isPresented: $showingAddTodoView, content: {
                                        AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
                                    })
            )
        } //: NavigationView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
