//
//  ViewModel.swift
//  MoveNLoose
//
//  Created by Vincent Palma on 2021-12-18.
//

import Foundation
import Firebase

class FireBaseViewModel: ObservableObject {
    
    @Published var list = [Todo]()
    
    func updateData(todoToUpdate: Todo){
        
        //Get a reference to the db
        let db = Firestore.firestore()
        
        // Set the data to update
        //
        db.collection("todos").document(todoToUpdate.id).setData(["name": "Updated:\(todoToUpdate.name) "], merge: true){error in
            
            if error == nil {
                self.getData()
            }
        }
    }
    
    func deleteData(todoToDelete: Todo) {
        
        // Get a reference to the db
        let db = Firestore.firestore()
        // Specify doc to delete
        db.collection("todos").document(todoToDelete.id).delete{ error in
            // Check for error
            if error == nil {
                // no errors
                
                // update ui from main thread
                DispatchQueue.main.async {
                    
                    // remove the todo that was deleted
                    self.list.removeAll{ todo in
                        //check for the todo to remove
                        return todo.id == todoToDelete.id
                    }
                }
            }
        }
    }
    
    func addData(name: String){
        
        //Get reference to the db
        let db = Firestore.firestore()
        // Add a doc to a collection
        db.collection("todos").addDocument(data: ["name" : name]){ error in
            
            // check error
            if error == nil {
                // NO errors
                
                // Call get data
                self.getData()
            } else{
                // Handle the error
            }
        }
    }
    
    
    func getData() {
        // Get ref to DB
        
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("todos").getDocuments { snapshot, error in
            // Check errors
            if error == nil{
                
                //No error
                if let snapshot = snapshot{
                    
                    //Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        //Get all docs and create todos
                        self.list = snapshot.documents.map{ d in // for each
                            // Create Todo
                            return Todo(id: d.documentID, name: d["name"] as? String ?? "",steps: d["steps"] as? Int ?? 0, calories: d["calories"] as? Int ?? 0) // Return a Todo item/array/object
                        }
                    }
                }
            } else{
                //Handle errors
            }
        }
    }
}



