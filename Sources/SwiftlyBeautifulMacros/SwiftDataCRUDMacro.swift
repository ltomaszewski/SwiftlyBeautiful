//
//  File.swift
//
//
//  Created by Lukasz Tomaszewski on 06/09/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// Define a custom diagnostic message type
public struct SwiftDataCRUDMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        // Get the class name from the declaration (attached class or struct)
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            // Report diagnostic if this macro is applied to a non-class type
            return []
        }
        
        let className = classDecl.name.text

        // Define the save function using SwiftData's ModelContext
        let saveFunction = """
            static func save(_ instance: \(className), context: ModelContext) throws {
                context.insert(instance)
                try context.save()
            }
        """

        // Define the delete function
        let deleteFunction = """
            static func delete(_ instance: \(className), context: ModelContext) throws {
                context.delete(instance)
                try context.save()
            }
        """

        // Define the update function
        let updateFunction = """
            @available(iOS 17, macOS 14, *)
            static func update(id: String, updateClosure: (inout \(className)) -> Void, context: ModelContext) throws {
                let predicate: Predicate<\(className)> = #Predicate<\(className)> { $0.id == id }
                let fetchDescriptor = FetchDescriptor<\(className)>(predicate: predicate)

                guard let instance = try context.fetch(fetchDescriptor).first else {
                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(className) not found"])
                }

                var instanceCopy = instance
                updateClosure(&instanceCopy)

                try context.save()
            }
        """
        
        // Define the query function that takes a predicate to filter at the database level
        let queryFunction = """
            @available(iOS 17, macOS 14, *)
            static func query(predicate: Predicate<\(className)>? = nil, sortBy: [SortDescriptor<\(className)>], context: ModelContext) throws -> [\(className)] {
                let fetchDescriptor = FetchDescriptor<\(className)>(predicate: predicate, sortBy: sortBy)
                return try context.fetch(fetchDescriptor)
            }
        """

        // Combine all function definitions into one extension declaration
        let extensionDecl = try ExtensionDeclSyntax("""
            extension \(raw: className) {
                \(raw: saveFunction)
            
                \(raw: deleteFunction)
            
                \(raw: updateFunction)
            
                \(raw: queryFunction)
            }
            """
        )

        // Return the extension declaration
        return [extensionDecl]
    }
}
