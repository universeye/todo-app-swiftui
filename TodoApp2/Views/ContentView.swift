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
            List {
                ForEach(self.todos, id: \.self) { todo in
                    HStack {
                        Text(todo.name ?? "Unknown")
                        Spacer()
                        Text(todo.priority ?? "No Priority")
                    }
                }
                .onDelete(perform: deleteTodo)
            }//: List
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(leading: EditButton() ,
                trailing:
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
    
    
    private func deleteTodo(at index: IndexSet) {
        for index in index {
            self.managedObjectContext.delete(todos[index])
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
