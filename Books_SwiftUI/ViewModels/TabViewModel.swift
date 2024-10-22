//
//  TabViewModel.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
import Combine

class TabViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
}
