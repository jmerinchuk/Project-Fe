//
//  DatabaseAccessObject.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-21.
//

// Imports
import Foundation
import Firebase
import FirebaseAuth

/*------------------------------------------------------------------------
 - Class: FirebaseAccessObject
 - Description: Holds methods for accessing Firebase Data
 -----------------------------------------------------------------------*/
class FirebaseAccessObject {
    
    // Class Variables
    let db = Firestore.firestore() // Access to Firestore Database
    
    /*--------------------------------------------------------------------
     - Function: signOut()
     - Description: Signs out current User.
     -------------------------------------------------------------------*/
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print("Failed to sign out with error: \(err)")
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: checkIfNewUser()
     - Description: Checks if the user already exists in the Database.
     If the user doesn't exist, create a blank profile for them.
     -------------------------------------------------------------------*/
    func checkIfNewUser() {
        let user = Auth.auth().currentUser
        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("Adding new user.")
                        self.addNewUser()
                    } else {
                        print("This user already exists.")
                    }
                }
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: addNewUser()
     - Description: Logic to add user to Firebase Firestore
     -------------------------------------------------------------------*/
    func addNewUser() {
        let user = Auth.auth().currentUser
        // TODO: - Change this to use the struct model User
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "uid": user!.uid,
            "fName": "",
            "lName": "",
            "age": "",
            "email": user!.email!,
            "password": "",
            "street1": "",
            "street2": "",
            "city": "",
            "postal": "",
            "province": "",
            "country": "",
            "existingSymptoms": ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: uploadFile()
     - Description: Logic to upload image to Firebase.
     -------------------------------------------------------------------*/
    func uploadFile(testName:String, imagePicked:UIImageView, date:String, doctor:String, results:String, notes:String) -> Bool {
        
        // Get the user email and check if they are already in the storage system
        let user = Auth.auth().currentUser
        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: user!.email!)
        
        let date = date // Get DatePicker date
        
        // Get test Name for file path
        var fileName = ""
        if testName == "" {
                fileName = "NOFILENAME"
        } else {
            fileName = (testName)
        }
        
        let uploadRef = Storage.storage().reference(withPath: "\(String(describing: user!.email!))/\(date)/\(fileName).jpg")
        let imageData = (imagePicked.image?.jpegData(compressionQuality: 0.75))!
        
        let metadata = [
            "date" : "\(date)",
            "doctor" : "\(doctor)",
            "testResults" : "\(results)",
            "notes" : "\(notes)"
        ]
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        uploadMetadata.customMetadata = metadata
        
        var err = 0
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Error uploading picture: \(error.localizedDescription)")
                err += 1
            }
            // print("Put is complete and i got this back: \(String(describing: downloadMetadata))")
        }
        if err == 0 {
            return true
        } else {
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: iterateDocuments()
     - Description: returns number of pictures uploaded.
     -------------------------------------------------------------------*/
    func iterateDocuments(completion: @escaping (_ docArray: [Document]) -> Void) {
        var docArray = [Document]()
        
        let user = Auth.auth().currentUser
        let storage = Storage.storage()
        let storageReference = storage.reference().child((user?.email!)!)
        
        storageReference.listAll { (result, error) in
            if let error = error {
                print("There was an error retrieving list of emails: ", error)
            }
            for prefix in result.prefixes {
                // print(prefix.name)
                let storageRef = storage.reference().child("\((user?.email!)!)/\(prefix.name)")
                
                storageRef.listAll { (result, error) in
                    if let error = error {
                        print("There was an error retrieving files in date folder: ", error)
                    }
                    for item in result.items {
//                        print(item.name)
                        
                        item.getMetadata { metadata, error in
                            if let error = error {
                                print("There was an error in metadata: \(error)")
                            } else {
                                // Metadata now contains the metadata for 'images/forest.jpg'
                                let doc = Document(
                                    name: item.name,
                                    size: String(metadata?.size ?? 0),
                                    type: String(metadata?.contentType ?? "NA"),
                                    testResults: String(metadata?.customMetadata?["testRestults"] ?? "NA"),
                                    doctor: String(metadata?.customMetadata?["doctor"] ?? "NA"),
                                    date: String(metadata?.customMetadata?["date"] ?? "NA"),
                                    notes: String(metadata?.customMetadata?["notes"] ?? "NA"),
                                    location: String(item.fullPath)
                                )
                                docArray.append(doc)
                                completion(docArray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: deleteAccount()
     - Description: Logic to delete account from Firestore.
     -------------------------------------------------------------------*/
    func deleteAccount() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("There was an error getting the user: \(error)")
            } else {
                self.signOut()
            }
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: deleteData()
     - Description: Logic to delete data from Firestore.
     -------------------------------------------------------------------*/
    func deleteData() {
        let user = Auth.auth().currentUser
        let usersRef = self.db.collection("users")
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("The user cannot be found")
                    } else {
                        print("We found the user.")
                        for document in querySnapshot!.documents {
                            print(document)
                            // DELETE THE USER DOCUMENT
                            self.db.collection("users").document(document.documentID).delete() { err in
                                if let err = err {
                                    print("Error removing the document: \(err)")
                                } else {
                                    print("Document successfully deleted.")
                                }
                            }
                        }
                    }
                }
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: deleteSensorData()
     - Description: Logic to delete sensor data from Firestore.
     -------------------------------------------------------------------*/
    func deleteSensorData() {
        let user = Auth.auth().currentUser
        let usersRef = self.db.collection("users")
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("The user cannot be found")
                    } else {
                        print("We found the user.")
                        for document in querySnapshot!.documents {
                            print(document)
                            //TODO: Delete the Sensor Data once established in firestore
                        }
                    }
                }
            }
    }
    
    /*--------------------------------------------------------------------
     - Function: getUserData()
     - Description: Obtains current user data from Firebase and displays in
     - each of the appropriate TextViews.
     -------------------------------------------------------------------*/
    func getUserData(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        var dataDict = [String:String]()
        let usersRef = db.collection("users")
        let user = Auth.auth().currentUser
        
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("There was a database error.  the user wasn't created in the Firebase DB in HomeViewController.")
                    } else {
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            dataDict["fName"] = document.data()["fName"] as? String
                            dataDict["lName"] = document.data()["lName"] as? String
                            dataDict["age"] = document.data()["age"] as? String
                            dataDict["email"] = document.data()["email"] as? String
                            dataDict["password"] = document.data()["password"] as? String
                            dataDict["phone"] = document.data()["phone"] as? String
                            dataDict["street1"] = document.data()["street1"] as? String
                            dataDict["street2"] = document.data()["street2"] as? String
                            dataDict["city"] = document.data()["city"] as? String
                            dataDict["province"] = document.data()["province"] as? String
                            dataDict["postal"] = document.data()["postal"] as? String
                            dataDict["country"] = document.data()["country"] as? String
                            dataDict["existingSymptoms"] = document.data()["existingSymptoms"] as? String
                        }
                    }
                }
                completion(dataDict)
        }
    }
    
    /*--------------------------------------------------------------------
     - Function:updateUserData()
     - Description: Gets user from Firestore using email and updates data.
     -------------------------------------------------------------------*/
    func updateUserData(fname: String, lname: String, age: String, email: String, password: String, phone: String, st_address1: String, st_address2: String, postal: String, province: String, city: String, country: String, symptoms: String) {
        print("Updating existing user...")
        let usersRef = db.collection("users")
        let user = Auth.auth().currentUser
        
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("There was a database error.  the user wasn't created in the Firebase DB in HomeViewController.")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let ref = document.reference
                            
                            ref.updateData([
                                "fName": fname,
                                "lName": lname,
                                "age": age,
                                "email": email,
                                "password": password,
                                "phone": phone,
                                "street1": st_address1,
                                "street2": st_address2,
                                "city": city,
                                "postal": postal,
                                "province": province,
                                "country": country,
                                "existingSymptoms": symptoms
                            ]);
                        }
                    }
                }
        }
    }
    
}
