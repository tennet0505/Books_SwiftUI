//
//  Extentions.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func onTapGestureToDismissKeyboard() -> some View {
        self.onTapGesture {
            self.hideKeyboard()
        }
    }
}
