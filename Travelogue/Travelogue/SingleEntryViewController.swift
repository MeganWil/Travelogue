//
//  SingleEntryViewController.swift
//  Travelogue
//
//  Created by Megan Wilson on 11/18/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit

class SingleEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var dateFormatter = DateFormatter()
    let imagePicker = UIImagePickerController()
    var entry : Entry?
    var trip : Trip?
        
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            imagePicker.delegate = self
            dateFormatter.timeStyle = .long
            dateFormatter.dateStyle = .long
            dateFormatter.dateFormat = "EEEE, MMM d yyyy h:mm a"
            self.infoTextView.layer.borderWidth = 1.0
        
            if let entry = entry{
                infoTextView.text = entry.entryTitle
                infoTextView.text = entry.text
                dateLabel.text = "Date: \(dateFormatter.string(from: ((entry.date ?? nil) ?? nil)!))"
                imageView.image = entry.image ?? nil
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        imagePicker.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        infoTextView.resignFirstResponder()
           return false
    }
    
    @IBAction func photoTaken(_ sender: Any) {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let alertController = UIAlertController(title: "No Camera", message: "The devide does not have a camera", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        else {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func composePhotos(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveInfo(_ sender: Any) {
         if entry == nil {
            let title = titleTF.text ?? ""
            let text = infoTextView.text ?? ""
            let date = Date(timeIntervalSinceNow: 0)
            let photo = imageView.image
                    
                if let entry = Entry(entryTitle: title, text: text, date: date, image: photo){
                    print("Entry exists")
                        if let trip = trip {
                            print("Adding entry")
                            trip.addToRawEntries(entry)
                        }
                        do {
                            try entry.managedObjectContext?.save()
                            self.navigationController?.popViewController(animated: true)
                        }
                        catch{
                            print("Entry was not saved")
                        }
                            print("Entry should be saved")
                }
        }
        else {
            let title = titleTF.text ?? ""
            let text = infoTextView.text ?? ""
            let date = Date(timeIntervalSinceNow: 0)
            let photo = imageView.image
            
                entry?.update(entryTitle: title, text: text, date: date, image: photo)
            
                do {
                    let managedContext = entry?.managedObjectContext
                    try managedContext?.save()
                }
                catch {
                    print("The entry was not saved")
                }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("The imageview is not good")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Setting the imageview")
            imageView.image = image
        }
        else {
            print("Imageview is not setting")
        }
        dismiss(animated: true, completion: nil)
    }
}
