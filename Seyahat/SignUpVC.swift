//
//  ViewController.swift
//  Seyahat
//
//  Created by Macintosh HD on 22.01.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
     assignbackground()
        
    }
    func assignbackground(){
        let background = UIImage(named: "bak")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        let tempBtn: UIButton = UIButton(frame: CGRect(x: 5, y: 20, width: 40, height: 40))
        tempBtn.backgroundColor = UIColor.red
        
        if userNameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else {
                   
                    //kaydolmuş kullanıcıyı hatırlamak
                    UserDefaults.standard.set(self.userNameText.text!, forKey: "userLoggedIn")
                    UserDefaults.standard.synchronize()
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogIn()
                   
                }
            }
            
            
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "kullanıcı adı // Sifre ??")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        //burada parse a bağlayarak kaydol ma işlemi gerçekleştirecegim.
        if userNameText.text != "" && passwordText.text != "" {
            
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { (success, error) in //-> closuer yapısında self yapılması şartttır.
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!!")
                }
                else {
                    //kaydolmuş kullanıcıyı hatırlamak
                    UserDefaults.standard.set(self.userNameText.text!, forKey: "userLoggedIn")
                    UserDefaults.standard.synchronize()
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogIn()

                }
            }
        }
        else {
            // boş ise hata mesajı döndür
            makeAlert(titleInput: "Error", messageInput: "kullanıcı adı // Sifre ??")
        }
        
    }
    func makeAlert(titleInput : String , messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true , completion: nil)
        
    }
    
    
    
}

