//
//  PlacesVC.swift
//  Seyahat
//
//  Created by Macintosh HD on 23.01.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import Parse


class PlacesVC: UIViewController , UITableViewDelegate , UITableViewDataSource{

   @IBOutlet weak var tableView: UITableView!
   
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Çıkış Yap", style: UIBarButtonItem.Style.plain, target: self, action: #selector(CikisButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getDataFromParse()
    }
    
    func getDataFromParse(){ // verileri parsean almak için ve namearrayları table viewde göstermek için
        //parse objemiz places
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                
            }
            else{
                
                if objects != nil {
            
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        //parsedan istediğimiz keydaki verileri cekmek için forkey column kısmından
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId  {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    @objc func addButtonClicked() {
        
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        
        
    }
    
    @objc func CikisButtonClicked() {
        //logout çıkış yapmak
        PFUser.logOutInBackground { (error) in
            
            if error != nil {
            
           self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                
            }
            else {
                //kullanıcı çııkış yapmışsa ana ekrana gitmesini sağlamak için
                UserDefaults.standard.removeObject(forKey: "userLoggedIn")
                UserDefaults.standard.synchronize()
                //çıkış yapınca gidilecek yer sıngup ilk ekran
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
                
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //segue olmadan önce ne yapacağımız anlamına gelen fonksiyon
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC // details e gidilcekse önce kaydedilecek. VE içindeki değişkenlere ulaşılabilecek.
            destinationVC.choosenPlaceId = selectedPlaceId
        }
        
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //tableviewv üzerinde bi row a tıklandığında napacağımız
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    //tableview de gözükmesini sağlayan mekan isimleri yeri
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //tableview de ne olacak
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // kaç satır olacak
        
        return placeNameArray.count
    }
    
    
    func makeAlert(titleInput : String , messageInput : String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert , animated: true , completion: nil)
        
    }

}
