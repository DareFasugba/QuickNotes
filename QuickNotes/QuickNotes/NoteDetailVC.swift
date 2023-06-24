//
//  ViewController.swift
//  QuickNotes
//
//  Created by The Fasugba Crew  on 18/06/2023.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedNote != nil) {
            titleTF.text = selectedNote?.title
            descriptionTV.text = selectedNote?.desc
            self.titleTF.delegate = self
            self.descriptionTV.delegate = self
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTF.text
            newNote.desc = descriptionTV.text
            do {
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("context save error")
            }
        }
        else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    if(note == selectedNote) {
                        note.title = titleTF.text
                        note.desc = descriptionTV.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Fetch failed")
            }
        }
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let note = result as! Note
                if(note == selectedNote) {
                    note.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch failed")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return titleTF.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

