//
//  AddTodoView.swift
//  ToDoApp
//
//  Created by Terry Kuo on 2021/8/1.
//

import SwiftUI

struct AddTodoView: View {
    
    //MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    let priorities = ["High", "Normal", "Low"]
    
    //MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20 ){
                    //MARK: - Todo Name
                    
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    //MARK: - Todo Priority
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text( $0 )
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    //MARK: - Saved Button
                    Button(action: {
                        
                        if self.name != "" {
                            let todo = Todo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            
                            do {
                                try self.managedObjectContext.save()
                                print("New todo: \(todo.name ?? "no todo"), Priority: \(todo.priority ?? "no priority")")
                            } catch {
                                print(error)
                            }
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Make sure to enter something for\nthe new todo item"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(9)
                    })
                    
                    
                }//: VStack
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
            } //: VStack
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                Image(systemName: "xmark")
            }))
            .alert(isPresented: $errorShowing, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
        } //: Navigation
        
    }
}



//MARK: - Preview

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddTodoView()
            AddTodoView()
                .environment(\.colorScheme, .dark)
        }
    }
}
