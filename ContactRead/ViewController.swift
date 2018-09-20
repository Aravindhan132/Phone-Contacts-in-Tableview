//
//  ViewController.swift
//  ContactRead
//
//  Created by aravind-pt2199 on 20/09/18.
//  Copyright © 2018 aravind-pt2199. All rights reserved.
//

import UIKit
import ContactsUI

class ViewController: UIViewController ,CNContactPickerDelegate {
    
    var objects  = [CNContact]()
    var name = [String]()
    var numbers = [String]()
     @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContacts()
    }
    
    func getContacts() {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            self.retrieveContactsWithStore(store: store)
        case .notDetermined:
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }
                self.retrieveContactsWithStore(store: store)
                
            }
        default:
            print("Not handled")
        }
        
    }
    func retrieveContactsWithStore(store: CNContactStore)
    {
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactImageDataKey, CNContactEmailAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var cnContacts = [CNContact]()
        do {
            try store.enumerateContacts(with: request){
                (contact, cursor) -> Void in
                cnContacts.append(contact)
                self.objects = cnContacts
            }
        } catch let error {
            print("Fetch contact error: \(error)")
        }
         for contact in cnContacts {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            for phoneNumber in contact.phoneNumbers {
                if let number = phoneNumber.value as CNPhoneNumber?,
                    let label = phoneNumber.label {
                    let localizedLabel = CNLabeledValue<NSCopying & NSSecureCoding>.localizedString(forLabel: label)
                    if ("\(localizedLabel)" == "home") {
                        numbers.append("\(number.stringValue)")
                     }
                    
                }
            }
            name.append("\(fullName)")
        }
        print(name)
        print(numbers)
        self.tableView.reloadData()
    }
    
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! ContactCell
        
        cell.PersonNameLabel.text = name[indexPath.row]
        cell.PersonMobileNOLabel.text = numbers[indexPath.row]
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(name[indexPath.row]) , \(numbers[indexPath.row])")
    }
}
