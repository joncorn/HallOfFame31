//
//  PeopleTableViewController.swift
//  HallOfFame31
//
//  Created by Jon Corn on 1/23/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    // MARK: - Properties
    var people = [Person]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPeople()
        
    }
    
    // MARK: - Private Methods
    private func fetchPeople() {
        PersonController.getPeople { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let people):
                    self.people = people
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    private func addNewPersonAlert() {
        let alert = UIAlertController(title: "Add yourself!", message: "Join the hall of fame forever!", preferredStyle: .alert)
        
        // add two textfields
        alert.addTextField { (textField) in
            textField.placeholder = "First Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Last Name"
        }
        
        // add cancel button
        let cancelAction = UIAlertAction(title: "Nvm", style: .cancel)
        alert.addAction(cancelAction)
        
        // add save button
        let saveAction = UIAlertAction(title: "Add", style: .default) { (_) in
            // get text fields
            guard let firstNameTextField = alert.textFields?[0],
            let lastNameTextField = alert.textFields?[1],
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !firstName.isEmpty,
            !lastName.isEmpty else { return }
            
            // send data to personcontroller
            PersonController.postPerson(firstName: firstName, lastName: lastName) { (result) in
                // Return to main thread
                DispatchQueue.main.async {
                    switch result {
                    case .success(let person):
                        self.people.append(person)
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                    }
                }
            }
        }
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        addNewPersonAlert()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        let person = people[indexPath.row]
        cell.textLabel?.text = person.firstName + " " + person.lastName
        cell.detailTextLabel?.text = String(person.personID ?? 0)

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
