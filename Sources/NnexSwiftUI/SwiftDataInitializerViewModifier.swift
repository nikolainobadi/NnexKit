//
//  SwiftDataInitializerViewModifier.swift
//  NnexKit
//
//  Created by Nikolai Nobadi on 3/22/25.
//

import NnexKit
import SwiftUI
import SwiftData

struct SwiftDataInitializerViewModifier: ViewModifier {
    var sharedModelContext: ModelContext = {
        do {
            return try NnexContext().context
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    func body(content: Content) -> some View {
        content
            .modelContext(sharedModelContext)
    }
}

public extension View {
    /// Adds a SwiftData model container to the view, enabling persistence for the specified SwiftData model.
    func initializeSwiftDataModelContainer() -> some View {
        modifier(SwiftDataInitializerViewModifier())
    }
}

