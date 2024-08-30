//
//  ScannerVC.swift
//  Grabem
//
//  Created by Callsoft on 16/01/19.
//  Copyright © 2019 callsoft. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation


class ScannerVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate{

    
    @IBOutlet weak var vwScanner: UIView!
    
    var restaurantID = ""
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setScannerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        captureSession?.startRunning()
    }
    
    func setScannerView() {
        
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width ), height: Int(self.vwScanner.frame.size.height))
            videoPreviewLayer?.edgeAntialiasingMask = .layerBottomEdge
            
            vwScanner.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 5
                vwScanner.addSubview(qrCodeFrameView)
                vwScanner.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            
            print(error)
            return
        }
    }
    
    //  MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            qrCodeFrameView?.layer.borderColor = UIColor.red.cgColor
            
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
                
               // self.apiCallForBarCodeScan(qrcode: metadataObj.stringValue!)
                self.scannerQRCodeApiCall(msg:metadataObj.stringValue!)
                self.captureSession!.stopRunning()
                
            }
        }
        
    }
    

}
//MARK: - extension web services
extension ScannerVC{
    //qrcodeverification
    func scannerQRCodeApiCall(msg:String){
        let user_id = UserDefaults.standard.value(forKey: "unique_user_id") as? String ?? ""
        let parameters = ["msg":msg,
                          "user_id":user_id,
                          "restaurant_id":restaurantID]
        ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kQrcodeVerification, parameters: parameters, completion: { (dic) in
            
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            guard let message = dic.object(forKey: "message") as? String else{
                print("No message.")
                return
            }
            if status == "SUCCESS"{
                
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                
            } else if status == "FAILURE"{
                
              //  CommonMethod.makeAlert(alertMsg: "QR code not scanned, try again" as String)
                 CommonMethod.makeAlert(alertMsg: message)
            }
        })
    }
}
