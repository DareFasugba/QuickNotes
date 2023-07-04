//
//  ChatBotViewController.swift
//  QuickNotes
//
//  Created by The Fasugba Crew  on 23/06/2023.
//

import Foundation
import UIKit

class ChatBotViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let field: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .red
        textField.returnKeyType = .done
        return textField
    }()
    
    private var models = [String]()
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(field)
        view.addSubview(table)
        field.delegate = self
        table.delegate = self
        table.dataSource = self
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 50),
            field.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            field.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: field.topAnchor)
        ])
        setUpActivityIndicator()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            models.append(text)
            
            // Show the activity indicator
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            print("Is animating")
            
            APICaller.shared.getResponse(input: text) { [weak self] result in
                // Hide the activity indicator
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    print("isnt animating")
                }
                
                switch result {
                case .success(let output):
                    self?.models.append(output)
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                        self?.field.text = nil
                        self?.field.resignFirstResponder()
                    }
                case .failure:
                    self?.showAlertAction(title: "Failure", message: "Encountered error")
                    print("Failed")
                }
            }
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlertAction(title: String, message: String){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    print("Action")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    func setUpActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.black
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }

    
}
