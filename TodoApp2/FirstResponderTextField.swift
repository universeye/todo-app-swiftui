//
//  FirstResponderTextField.swift
//  TodoApp2
//
//  Created by Terry Kuo on 2021/8/17.
//

import SwiftUI

struct FirstResponderTextField: UIViewRepresentable {
    
    @Binding var name: String
    let placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if !context.coordinator.becamFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becamFirstResponder = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Self.Coordinator(name: $name)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var name: String
        var becamFirstResponder = false
        
        init(name: Binding<String>) {
            self._name = name
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            name = textField.text ?? ""
        }
    }
}
