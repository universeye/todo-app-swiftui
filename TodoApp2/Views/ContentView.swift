//
//  ContentView.swift
//  ToDoApp
//
//  Created by Terry Kuo on 2021/8/2.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showingAddTodoView: Bool = false
    @State private var isShowingSettingsView: Bool = false
    @EnvironmentObject var iconSettings: IconName
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @State private var isBreathing: Bool = false
    
    private var spinAnimation: Animation {
        Animation
            .easeInOut(duration: 2)
//            .speed(0.15)
            .repeatCount(isBreathing ? .max : 0, autoreverses: true)
    }
    @State private var selectedTodos = Set<UUID>()
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                List(selection: $selectedTodos) {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "No Priority")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }//: HStack
                        .padding(.vertical, 10)
                    }
                    
                    .onDelete(perform: deleteTodo)
                }//: List
                
                .listStyle(PlainListStyle())
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton().accentColor(themes[self.theme.themeSettings].themeColor)
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
                            SettingsView().environmentObject(self.iconSettings)
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
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(isBreathing ? 0.2 : 0)
                            .scaleEffect(isBreathing ? 1 : 0)
                            .frame(width: 60, height: 60, alignment: .center)
                            .animation(spinAnimation, value: isBreathing)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
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
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear{
                        self.isBreathing.toggle()
                    }
                } //: ZStack
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                
                , alignment: .bottomTrailing
                
            )
        } //: NavigationView
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())//for ipad
    }
    
    //MARK: - Functions
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
    
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return Color.pink
        case "Normal":
            return Color.green
        case "Low":
            return Color.blue
        default:
            return Color.gray
        }
    }
}


//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
