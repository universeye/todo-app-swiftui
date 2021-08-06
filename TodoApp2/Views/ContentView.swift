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
    @State private var isShowingSettingsView: Bool = false
    
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @State private var isBreathing: Bool = false
    
    private var spinAnimation: Animation {
        Animation
            .easeInOut(duration: 2)
//            .speed(0.15)
            .repeatCount(isBreathing ? .max : 0, autoreverses: true)
    }
    @State private var selectedTodos = Set<UUID>()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                List(selection: $selectedTodos) {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Text(todo.name ?? "Unknown")
                            Spacer()
                            Text(todo.priority ?? "No Priority")
                        }
                    }
                    
                    .onDelete(perform: deleteTodo)
                }//: List
                
                .listStyle(PlainListStyle())
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                })
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            //Show add todo View
                            self.isShowingSettingsView.toggle()
                        }, label: {
                            Image(systemName: "paintbrush")
                        })//: Add Button
                        .sheet(isPresented: $isShowingSettingsView, content: {
                            SettingsView()
                        })
                )
                
                //MARK: - No Todo Items
                
                if todos.count == 0 {
                    EmptyListView()
                }
                
            }//: ZStack
            .sheet(isPresented: $showingAddTodoView, content: {
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            })
            
            .overlay(
                ZStack {
                    Group{
                        Circle()
                            .fill(Color.blue)
                            .opacity(isBreathing ? 0.2 : 0)
                            .scaleEffect(isBreathing ? 1 : 0)
                            .frame(width: 60, height: 60, alignment: .center)
                            .animation(spinAnimation, value: isBreathing)
                        Circle()
                            .fill(Color.blue)
                            .opacity(isBreathing ? 0.15 : 0)
                            .scaleEffect(isBreathing ? 1 : 0)
                            .frame(width: 80, height: 80, alignment: .center)
                            .animation(spinAnimation, value: isBreathing)
                    }
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    })
                    .onAppear{
                        self.isBreathing.toggle()
                    }
                } //: ZStack
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                
                , alignment: .bottomTrailing
                
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
