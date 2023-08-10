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
    @State private var isBreathing: Bool = false
    @State private var selectedTodos = Set<UUID>()
    
    @EnvironmentObject var iconSettings: IconName
    @EnvironmentObject var theme: ThemeSettings
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.isDone, ascending: true)], animation: .spring()) var todos: FetchedResults<Todo>
    
    private var spinAnimation: Animation {
        Animation
            .easeInOut(duration: 2)
//            .speed(0.15)
            .repeatCount(isBreathing ? .max : 0, autoreverses: true)
    }
    
    
    let themes: [Theme] = themeData
    
    init() {
            UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "JosefinSansRoman-Regular", size: 20)!]
        }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                List(selection: $selectedTodos) {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(todo.isDone ? .gray : self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .foregroundColor(todo.isDone ? .gray : Color.primary)
                                .fontWeight(.semibold)
                                .strikethrough(todo.isDone)
                            Spacer()
                            Text(todo.isDone ? "Done" : todo.priority ?? "No Priority")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }//: HStack
                        .padding(.vertical, 10)
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                setDoneState(todo: todo, isDone: true)
                            }, label: {
                                Image(systemName: "checkmark.circle.fill")
                            })
                            .tint(.green)
                            
                            Button(action: {
                                setDoneState(todo: todo, isDone: false)
                            }, label: {
                                Text("Undone")
                            })
                            .tint(.yellow)
                        }
                    }
                    
                    .onDelete(perform: deleteTodo)
                }//: List
                
                .listStyle(PlainListStyle())
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if todos.count > 0 {
                            EditButton().accentColor(themes[self.theme.themeSettings].themeColor)
                        }
                        
                    }
                })
                .navigationBarTitle(Text("Todooey"), displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            self.isShowingSettingsView.toggle()
                        }, label: {
                            Image("paint_brushSVG")
                                .renderingMode(.template)
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
                    .presentationDetents([.medium])
            })
            
            .overlay(
                ZStack {
                    Group{
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(isBreathing ? 0.2 : 0.01)
                            .scaleEffect(isBreathing ? 1 :  0.001 )
                            .frame(width: 60, height: 60, alignment: .center)
                            .animation(spinAnimation, value: isBreathing)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(isBreathing ? 0.15 : 0.01)
                            .scaleEffect(isBreathing ? 1 :  0.001 )
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
    
    private func setDoneState(todo: FetchedResults<Todo>.Element, isDone: Bool) {
        withAnimation {
            todo.isDone = isDone
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
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


////MARK: - Preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return ContentView().environment(\.managedObjectContext, context)
//    }
//}
