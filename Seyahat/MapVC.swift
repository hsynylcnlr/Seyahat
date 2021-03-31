//
//  MapVC.swift
//  Seyahat
//
//  Created by Macintosh HD on 23.01.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import MapKit
import Parse


class MapVC: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //kaydet butonu
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Kaydet", style: UIBarButtonItem.Style.plain, target: self, action: #selector(KaydetButtonClicked))
        //geri butonu
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //ne kadar doğru bulucak accuracy yerimizi konumumuzu
        locationManager.requestWhenInUseAuthorization() // saadece kullandığım zaman göstermesi yeterli
        locationManager.startUpdatingLocation() // kullanıcının bulunduğu yeri güncelleemeye başlicam
        
        
        //haritaya uzun basıldığında pin seçme işlemlerinden biri
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3 // basma süresi
        mapView.addGestureRecognizer(recognizer) //basma olayını ekledik.
        
    }
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        
        if  gestureRecognizer.state == UIGestureRecognizer.State.began { // biri buraya tıklayıp başlattıysa
            
            let touches = gestureRecognizer.location(in: self.mapView)//tıklanılan noktaları alıyor.
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView) //tıklanılan yeri mapview kullanarak kordinata çevirme
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            //pinli ceğimiz yerlerin üstünde çıkan mekan adı ve tipini oluşturduğumuz modelle mapviewve aktardık.
            
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation) //oluşturduğumuz annotatiıonları u ekliyoruz.
            
            PlaceModel.sharedInstance.PlaceLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.PlaceLongitude = String(coordinates.longitude)
        
            
        }
        
    }
    
    
    //kullanıcının yeri güncellenince ne olucak.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //haritanın boyutunu widht ve hightını belirleme
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

    }
    
    
    @objc func KaydetButtonClicked() {
        //Parse a verileri kaydetme
        
        let placeModel = PlaceModel.sharedInstance
        //parse da places objesi oluşturmak.
        let object = PFObject(className: "Places")
        
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.PlaceLatitude
        object["longitude"] = placeModel.PlaceLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { (success, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true , completion: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
        
    }
    @objc func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
        
    }
   

}
