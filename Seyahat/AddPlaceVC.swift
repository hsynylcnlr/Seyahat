//
//  AddPlaceVC.swift
//  Seyahat
//
//  Created by Macintosh HD on 23.01.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit

class AddPlaceVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var mekanAdi: UITextField!
    
    @IBOutlet weak var mekanTipi: UITextField!
    
    @IBOutlet weak var mekanAtmosferi: UITextField!
    
    
    @IBOutlet weak var mekanİmageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //görsele tıklanabileceği anlamına geliyor
        mekanİmageView.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage)) //kullanıcı birşeye tıklayabilirmi tıklarsa  nolucak
        mekanİmageView.addGestureRecognizer(gestureRecognizer)
        
    }
    

    @IBAction func ileriButtonClicked(_ sender: Any) {
        
        //singleton yapısı ile daha guvenilir kaydetmiş olduk.
        if mekanAdi.text != "" && mekanTipi.text != "" && mekanAtmosferi.text != ""{
            if let chosenImage = mekanİmageView.image{
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = mekanAdi.text!
                placeModel.placeType = mekanTipi.text!
                placeModel.placeAtmosphere = mekanAtmosferi.text!
                placeModel.placeImage = chosenImage
                
                
            }
             performSegue(withIdentifier: "toMapVC", sender: nil)
        }
        else{
            
            let alert = UIAlertController(title: "Error", message: "Mekanadi/Tipi/atmosferi ??", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            present(alert,animated: true, completion: nil)
            
        }
        
        
       
    }
    
    @objc func chooseImage() { // fotograf secme

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true , completion: nil)
    }
    //fotoseçildiktensonraki olayı.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        mekanİmageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}
