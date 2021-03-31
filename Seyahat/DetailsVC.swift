//
//  DetailsVC.swift
//  Seyahat
//
//  Created by Macintosh HD on 23.01.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController  , MKMapViewDelegate{

    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var choosenPlaceId = "" //bunu yapmaktaaki amaç placedeki Id ile eşitleyip ordaki bilgileri details e aktarmak segue gerçekleştiği zaman
    var choosenLatitude  = Double()
    var choosenLongitude = Double()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getDataFromParse()
        detailsMapView.delegate = self

}
    
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId) // parse daki objectId choosenId ye eşit olanları getir.
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                
                
            }
            else{
                if objects != nil {
                    if objects!.count > 0 {
                        let choosenPlaceObject = objects![0]
                        
                        // textlabel bilgilerini almak
                        if let placeName = choosenPlaceObject.object(forKey: "name") as? String {
                            self.detailsNameLabel.text = placeName
                        }
                        if let placeType = choosenPlaceObject.object(forKey: "type") as? String {
                            self.detailsTypeLabel.text = placeType
                        }
                        
                        if let placeAtmosphere = choosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.detailsAtmosphereLabel.text = placeAtmosphere
                        }
                        // enlemi almak
                        if let placeLatitude = choosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.choosenLatitude = placeLatitudeDouble
                            }
                        }
                            //boylamı almak
                            if let placeLongitude = choosenPlaceObject.object(forKey: "longitude") as? String {
                                if let placeLongitudeDouble = Double(placeLongitude) {
                                    self.choosenLongitude = placeLongitudeDouble
                                }
                                
                            }
                            if let imageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject {
                                imageData.getDataInBackground(block: { (data, error) in
                                    if error == nil {
                                        if data != nil {
                                            self.detailsImageView.image = UIImage(data: data!)
                                        }
                                    }
                                    
                                })
                            }
                        
                        
                            //MAPS i Detailsde göstermek
                        
                        let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detailsMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title  = self.detailsNameLabel.text!
                        annotation.subtitle = self.detailsTypeLabel.text!
                        self.detailsMapView.addAnnotation(annotation)
                        
                        
                            
                        }
                        
                    }
                }
            }
            
        }
    
    //navigasyon ekleme işlemleri
    
    //Pin ekleme ve pine tıklanınca button cıkması
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //tıklandığında i harfi çıkıyor oda navigasyona gidiyor.
        if annotation is MKUserLocation{ //kullanıcı ile ilgili bir anatsyon lokasyon varsa onla ilgili birşey olmasın.
            return nil
        }
        
        let reusaId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusaId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusaId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure) // i yi button olarak ayarlama
            pinView?.rightCalloutAccessoryView = button
        }
        else{
            pinView?.annotation = annotation
        }
     
        return pinView
    }// butonu oluşturduk
    
    
    
    //butona tıklanıldığı zaman ne olacak.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLongitude != 0.0 && self.choosenLatitude != 0.0 { //enlem ve boylam kontolü
            
            let requsetLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requsetLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let lounchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: lounchOptions) //arabayla nasıl gideeceğimizi default olarak gösteriyor.
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
    }
    
    
    

