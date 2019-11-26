//
//  EntryTableViewController.swift
//  Travelogue
//
//  Created by Megan Wilson on 11/18/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit
import CoreData


class EntryTableViewController: UITableViewController {
    
    var trip : Trip?
    var entries : [Entry]?
    var dateFormatter = DateFormatter()
    
    @IBOutlet var entryTableView: UITableView!
    @IBOutlet weak var addEntry: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
    }

    override func viewWillAppear(_ animated: Bool) {
        entryTableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return trip?.entries?.count ?? 0
   }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = entryTableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
    
       if let entry = trip?.entries?[indexPath.row]{
           cell.textLabel?.text = entry.entryTitle
       }
        return cell
   }
        
    @IBAction func addEntryButton(_ sender: Any) {
        performSegue(withIdentifier: "newEntrySeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let location = segue.destination as? SingleEntryViewController
            else {
                print("Returning early")
                return
        }
        
        if let selectedRow = self.entryTableView.indexPathForSelectedRow?.row {
            location.entry = trip?.entries?[selectedRow]
        }
            location.trip = trip
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEntry(at: indexPath)
        }
    }
    
    func deleteEntry(at indexPath: IndexPath){
        guard let entry = trip?.entries?[indexPath.row], let managedContent = entry.managedObjectContext
            else {
                return
            }
                managedContent.delete(entry)
            do {
                try managedContent.save()
                    entryTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            catch {
                print("Entry could not be deleted")
                entryTableView.reloadRows(at: [indexPath], with: .automatic)
            }
    }
}
