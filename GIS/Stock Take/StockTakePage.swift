//
//  StockTakePage.swift
//  GIS
//
//  Created by Apple Hawkscode on 11/12/20.
//

import UIKit
import CoreBluetooth
import AVFoundation
import Alamofire
import Foundation
import SwiftyGif



class DeviceItems: UITableViewCell {
    @IBOutlet weak var mDeviceName: UILabel!
    @IBOutlet weak var mDeviceStatus: UILabel!
    @IBOutlet weak var mDeviceId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ data: CBPeripheral, _ isConnected: Bool = false) {
        mDeviceName.text = data.name
        mDeviceId.text = data.identifier.uuidString
        
        let statusText = isConnected ? "Connected" : "Disconnected"
        mDeviceStatus.text = statusText.localizedString
    }
}

class StockTakePage: UIViewController, UITableViewDelegate , UITableViewDataSource, AVCaptureMetadataOutputObjectsDelegate, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,UIViewControllerTransitioningDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, GetInventoryFiltersDelegate {
    
    @IBOutlet weak var mSearchDeviceView: UIView!
    @IBOutlet weak var mBottomView: UIView!
    
    @IBOutlet weak var mScanNowLabel: UILabel!
    
    let shape = CAShapeLayer()
    let layer = CAGradientLayer()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var prevPeripheral : CBPeripheral?
    var SiriID = ""
    
    var bluetoothService : BluetoothLeService?
    
    @IBOutlet weak var mScannerCamView: UIView!
    @IBOutlet weak var mScannerImage: UIImageView!
    
    @IBOutlet weak var mDeviceView: UIView!
    let storyBoard: UIStoryboard = UIStoryboard(name: "stockBoard", bundle: nil)
    
    var m_lock: NSLock?
    @IBOutlet weak var mConnectIcon: UIImageView!
    @IBOutlet weak var mConnectLabel: UILabel!
    
    @IBOutlet weak var mRefreshIcon: UIImageView!
    @IBOutlet weak var mRefreshLabel: UILabel!
    
    @IBOutlet weak var mPowerIcon: UIImageView!
    @IBOutlet weak var mPowerLabel: UILabel!
    
    @IBOutlet weak var mMoreIcon: UIImageView!
    @IBOutlet weak var mMoreLabel: UILabel!
    
    @IBOutlet weak var mConnectDeviceLABEL: UILabel!
    @IBOutlet weak var mStartIcon: UIImageView!
    
    var cr_characteristic: CBCharacteristic?
    
    @IBOutlet weak var mDeviceTableView: UITableView!
    var mTimer = Timer()
    var mPeripherals = [CBPeripheral]()
    var mPeripheral : CBPeripheral?
    var mPerph = CBCentralManager()
    var mDeviceData = NSMutableArray()
    var mDataTags = [String]()
    var mSelected = -1
    var heartRatePeripheral: CBPeripheral!
    
    var mDATA = [""]
    @IBOutlet weak var mSearchStock: UITextField!
    @IBOutlet weak var mTotalStocks: UILabel!
    
    @IBOutlet weak var mScannedStocks: UILabel!
    
    @IBOutlet weak var mUnscannedStocks: UILabel!
    @IBOutlet weak var mConflictStocks: UILabel!
    @IBOutlet weak var mUnknownStocks: UILabel!
    var mScannedData = [String]()
    var mScannedSKU = [String]()
    var mScannedCount = [Int]()
    var mUnscannedData = [String]()
    var mConflictData = [String]()
    var mInventoryData = NSArray()
    var mTData = NSArray()
    
    var mStatusData = NSMutableArray()
    var mSCANNED = NSMutableArray()
    var mUNSCANNED = NSMutableArray()
    var mCONFLICTARRAY = NSMutableArray()
    var mUNKNOWNARRAY = NSMutableArray()
    
    var mSAVESCANNED = NSMutableArray()
    var mSAVEUNSCANNED = NSMutableArray()
    var mCONFLICT = [String]()
    var FINALCONFLICT = [String]()
    var mINVData = NSMutableArray()
    var m_recvData: Data?
    
    @IBOutlet weak var mStartScannView: UIView!
    @IBOutlet weak var mScannerView: UIView!
    
    @IBOutlet weak var mStockTakeHeaderLABEL: UILabel!
    
    @IBOutlet weak var mTotalLABEL: UILabel!
    
    @IBOutlet weak var mScannedLABEL: UILabel!
    
    @IBOutlet weak var mUnscannedLABEL: UILabel!
    
    @IBOutlet weak var mConflictLABEL: UILabel!
    
    @IBOutlet weak var mUnknownLABEL: UILabel!
    @IBOutlet weak var mFilterView: UIView!
    @IBOutlet weak var mFilterSubView: UIView!
    @IBOutlet weak var mFilterLABEL: UILabel!
    @IBOutlet weak var mClearAllBUTTON: UIButton!
    @IBOutlet weak var mFItemLABEL: UILabel!
    @IBOutlet weak var mFSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFCollectionLABEL: UILabel!
    @IBOutlet weak var mFMetalLABEL: UILabel!
    @IBOutlet weak var mFCollectionSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFMetalSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFLocationSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFLocationLABEL: UILabel!
    @IBOutlet weak var mItemCollectionView: UICollectionView!
    @IBOutlet weak var mCollectCollectionView: UICollectionView!
    @IBOutlet weak var mMetalCollectionView: UICollectionView!
    @IBOutlet weak var mLocationCollectionView: UICollectionView!
    @IBOutlet weak var mApplyFilterView: UIView!
    
    @IBOutlet weak var mApplyFilterBUTTON: UIButton!
    
    var mItemsData = NSArray()
    var mItemsId = [String]()
    
    var mCollectionData = NSArray()
    var mCollectionId = [String]()
    
    var mMetalsData = NSArray()
    var mMetalsId = [String]()
    
    var mStonesData = NSArray()
    var mStonesId = [String]()
    
    var mStatusId = [String]()
    
    var mLocationsData = NSArray()
    var mLocationsId = [String]()
    
    var mSizeData = NSArray()
    var mSizeId = [String]()
    
    var mMinPrices = ""
    var mMaxPrices = ""
    var mFilterData = NSMutableDictionary()
    
    
    @IBOutlet weak var mPowerView: UIView!
    @IBOutlet weak var mPowerSlider: UISlider!
    @IBOutlet weak var mFrequencySlider: UISlider!
    @IBOutlet weak var mPowerValue: UILabel!
    @IBOutlet weak var mFrequency: UILabel!
    
    @IBOutlet weak var mPowerpLABEL: UILabel!
    @IBOutlet weak var mPowerLABEL: UILabel!
    @IBOutlet weak var mFrequencyLABEL: UILabel!
    var centralManager : CBCentralManager?
    let ScanPeriod : Double = 10.0
    var arrPeripheral = Array<CBPeripheral>()
    
    //MIC related outlets
    @IBOutlet weak var sMicParentView: UIView!
    @IBOutlet weak var sMicImageView: UIImageView!
    private let speechRecongniger = SpeechRecognizer(localeIdentifier: "en-US")
    private var isSpeechRecongnitionOn = false
    
    //Stock Take loader
    @IBOutlet weak var sStockTakeLoading: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        // Set default slider values
        mPowerSlider.setValue(0, animated: false)
        mFrequencySlider.setValue(0, animated: false)
        
        // Set default labels and text
        mPowerValue.text = "Max"
        mFrequency.text = "Max"
        mScanNowLabel.text = "Scan now".localizedString
        mStockTakeHeaderLABEL.text = "Stock Take".localizedString
        mTotalLABEL.text = "TOTAL".localizedString
        mScannedLABEL.text = "SCANNED".localizedString
        mUnscannedLABEL.text = "UNSCANNED".localizedString
        mConflictLABEL.text = "CONFLICT".localizedString
        mUnknownLABEL.text = "UNKNOWN".localizedString
        mConnectLabel.text = "Connect".localizedString
        mRefreshLabel.text = "Refresh".localizedString
        mConnectDeviceLABEL.text = "Connect".localizedString
        mFrequencyLABEL.text = "Frequency".localizedString
        mPowerpLABEL.text = "Power".localizedString
        mPowerLabel.text = "Power".localizedString
        mMoreLabel.text = "Save".localizedString
        mSearchStock.placeholder = "Search by SKU / Stock ID".localizedString
        
        // Set UI states
        mPowerView.isHidden = true
        mFilterView.isHidden = true
        
        // Set UI colors and images
        mPowerLabel.textColor = UIColor(named: "theme6A")
        mStartIcon.image = UIImage(named: "play_icgreen")
        mConnectIcon.image = UIImage(named: "connect_icgrey")
        mConnectLabel.textColor = UIColor(named: "theme6A")

        // Start capture session if not running
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve user login token from UserDefaults
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")

        // Configure filter subview
        mFilterSubView.layer.cornerRadius = 20
        mFilterSubView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // Initialize Bluetooth service
        bluetoothService = BluetoothLeService(main: self)

        // Set delegates and data sources for collection views
        mItemCollectionView.delegate = self
        mItemCollectionView.dataSource = self
        mCollectCollectionView.delegate = self
        mCollectCollectionView.dataSource = self
        mMetalCollectionView.delegate = self
        mMetalCollectionView.dataSource = self
        mLocationCollectionView.delegate = self
        mLocationCollectionView.dataSource = self

        // Set initial stock counts
        mScannedStocks.text = "0"
        mUnscannedStocks.text = "0"
        mConflictStocks.text = "0"
        mTotalStocks.text = "0"
        mUnknownStocks.text = "0"
   if let gif = try? UIImage(gifName: "scanner.gif") {
    mScannerImage.setGifImage(gif)
} else {
    print("⚠️ ไม่พบไฟล์ scanner.gif")
}


        //mScannerImage.image = UIImage.gif(asset: "scanner")

        // Add tap gesture to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false

        // Configure bottom view
        mBottomView.layer.cornerRadius = 10
        mBottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mBottomView.dropShadow()

        // Configure search device view
        mSearchDeviceView.layer.cornerRadius = 10
        mSearchDeviceView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // Configure power view
        mPowerView.layer.cornerRadius = 10
        mPowerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // Configure apply filter view
        mApplyFilterView.layer.cornerRadius = 10
        mApplyFilterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mApplyFilterView.dropShadow()

        // Set delegates and data sources for device table view
        self.mDeviceTableView.delegate = self
        self.mDeviceTableView.dataSource = self

        // Fetch inventory data
        self.mGetInventoryDataStock(key: "")

        // Add done button to keyboard
        addDoneButtonOnKeyboard()
        print("Siri ID: \(SiriID)")
        self.mSearchStock.text = SiriID
    }
    
    
    func mGetInventoryFilterData(itemsId: [String], metalId: [String], collectionId: [String], stoneId: [String], sizeId: [String], locationId: [String], statusId: [String], minPrice: String, maxPrice: String) {
        
        mItemsId = itemsId
        mMetalsId = metalId
        mCollectionId = collectionId
        mStonesId = stoneId
        mSizeId = sizeId
        mStatusId = statusId
        mLocationsId = locationId
        mMinPrices = minPrice
        mMaxPrices = maxPrice
        
        mGetInventoryDataStock(key: "")
    }
    
    //Mic Button
    @IBAction func sSpeakStockIdOrSku(_ sender: Any) {
        
        if !isSpeechRecongnitionOn {
            self.isSpeechRecongnitionOn = true
            self.sMicImageView.image = UIImage(systemName: "mic.slash.fill")
            speechRecongniger.startRecognition { value in
                
                DispatchQueue.main.async {
                    self.isSpeechRecongnitionOn = false
                    self.sMicImageView.image = UIImage(systemName: "mic.fill")
                    if let text = value , !text.isEmpty{
                        self.mSearchStock.text = text
                        self.mSearchStock.becomeFirstResponder()
                    }
                }
            }
            
        } else {
            self.sMicImageView.image = UIImage(systemName: "mic.fill")
            self.isSpeechRecongnitionOn = false
            speechRecongniger.stopRecognition()
        }

    }

    @IBAction func mFrequencySliding(_ sender: UISlider) {
       
        let round = Float(sender.value/0.25).rounded()
        let newVal = Float(round) * 0.25
        sender.setValue(newVal, animated: false)
        sender.addTarget(self, action: #selector(onSlide(slider: event:index:)), for: .valueChanged)
        
    }

    @objc func onSlide(slider: UISlider , event: UIEvent ,index: Int){
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
                case .began: break
                case .moved: break
                case .ended:
                    if(slider.value == 0.0){
                        self.mFrequency.text = "90%"
                        self.bluetoothService?.sendSettingTxCycle(on: 180, off: 20)
                    }
                    if(slider.value == 0.25){
                        self.bluetoothService?.sendSettingTxCycle(on: 160, off: 40)
                        self.mFrequency.text = "80%"
                    }
                    if(slider.value == 0.5){
                        self.bluetoothService?.sendSettingTxCycle(on: 120, off: 80)
                        self.mFrequency.text = "60%"
                    }
                    if(slider.value == 0.75){
                        self.bluetoothService?.sendSettingTxCycle(on: 80, off: 120)
                        self.mFrequency.text = "40%"
                    }
                    if(slider.value == 1.0){
                        self.bluetoothService?.sendSettingTxCycle(on: 20, off: 180)
                        self.mFrequency.text = "20%"
                    }
                default: break
            }
        }
    }
    
    @IBAction func mPowerSliding(_ sender: UISlider) {
        let round = Float(sender.value/0.1).rounded()
        let newVal = Float(round) * 0.1
        sender.setValue(newVal, animated: false)
        sender.addTarget(self, action: #selector(onSlideF(slider: event:index:)), for: .valueChanged)
    }
    
    @objc func onSlideF(slider: UISlider , event: UIEvent ,index: Int){
        
        if let touchEvent = event.allTouches?.first {
            
            switch touchEvent.phase {
                
            case .began,.moved:  break
            case .ended:
                let sliderValue = slider.value
                let powerValue: Int
                let displayText: String
                
                switch sliderValue {
                case 0.0:
                    powerValue = 0
                    displayText = "Max"
                case 0.01...0.10:
                    powerValue = -1
                    displayText = "-1dB"
                case 0.11...0.20:
                    powerValue = -2
                    displayText = "-2dB"
                case 0.21...0.30:
                    powerValue = -3
                    displayText = "-3dB"
                case 0.31...0.40:
                    powerValue = -4
                    displayText = "-4dB"
                case 0.41...0.50:
                    powerValue = -5
                    displayText = "-5dB"
                case 0.51...0.60:
                    powerValue = -6
                    displayText = "-6dB"
                case 0.61...0.70:
                    powerValue = -7
                    displayText = "-7dB"
                case 0.71...0.80:
                    powerValue = -8
                    displayText = "-8dB"
                case 0.81...1.0:
                    powerValue = -9
                    displayText = "-9dB"
                default:
                    return
                }
                
                bluetoothService?.sendSettingTxPower(power: powerValue)
                self.mPowerValue.text = displayText
            default:
                break
            }
        }
    }
    

    
    @IBAction func mFilter(_ sender: Any) {
        
        view.endEditing(true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        guard let mFilters = storyBoard.instantiateViewController(withIdentifier: "CommonFilters") as? CommonFilters else { return }
        mFilters.delegate = self
        mFilters.mType = "inventory"
        mFilters.hideLocation = true
        mFilters.mItemsId = mItemsId
        mFilters.mMetalsId = mMetalsId
        mFilters.mCollectionId = mCollectionId
        mFilters.mStonesId = mStonesId
        mFilters.mSizeId = mSizeId
        mFilters.mLocationsId = mStatusId
        mFilters.mStatusId = mLocationsId
        mFilters.mMinPrices = mMinPrices
        mFilters.mMaxPrices = mMaxPrices
        mFilters.modalPresentationStyle = .automatic
        mFilters.transitioningDelegate = self
        self.present(mFilters,animated: true)
    }
    
    
    
    @IBAction func mMinimizeFilter(_ sender: Any) {
        mFilterView.slideTop()
        mFilterView.isHidden = true
    }
    
    @IBAction func mApplyFilter(_ sender: Any) {
        let defaultZero = "0"
        self.mScannedStocks.text = defaultZero
        self.mUnscannedStocks.text = defaultZero
        self.mConflictStocks.text = defaultZero
        self.mUnknownStocks.text = defaultZero
        
        self.mScannedData = []
        self.mScannedSKU = []
        self.mScannedCount = []
        self.mUnscannedData = []
        self.mConflictData = []
        self.mInventoryData = NSArray()
        self.mStatusData = NSMutableArray()
        self.mSCANNED = NSMutableArray()
        self.mUNSCANNED = NSMutableArray()
        self.mSAVESCANNED = NSMutableArray()
        self.mSAVEUNSCANNED = NSMutableArray()
        self.mCONFLICT = []
        self.FINALCONFLICT = []
        
        mGetInventoryDataStock(key: "")
        mFilterView.slideTop()
        mFilterView.isHidden = true
    }
    
    func connect(_ peripheral: CBPeripheral) {
     
        if bluetoothService?.isConnected() == true {
            if bluetoothService?.peripheral == peripheral {
                bluetoothService?.byeBluetoothDevice()
                self.mConnectIcon.image = UIImage(named: "connect_icgrey")
                self.mConnectLabel.textColor = UIColor(named: "theme6A")
                
                CommonClass.showFullLoader(view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    CommonClass.stopLoader()
                    if let cbPeripheral = self.bluetoothService?.peripheral {
                        self.centralManager?.cancelPeripheralConnection(cbPeripheral)
                        self.mDeviceTableView.reloadData()
                    }
                })
                
                return
            } else {
                
                self.mConnectIcon.image = UIImage(named: "connect_icgrey")
                self.mConnectLabel.textColor = UIColor(named: "theme6A")
                bluetoothService?.byeBluetoothDevice()
                CommonClass.showFullLoader(view: self.view)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    CommonClass.stopLoader()
                    
                    if let cbPeripheral = self.bluetoothService?.peripheral {
                        self.centralManager?.cancelPeripheralConnection(cbPeripheral)
                    }
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.bluetoothService?.peripheral = peripheral
                    peripheral.delegate = self
                    self.centralManager?.connect(peripheral)
                    CommonClass.showFullLoader(view: self.view)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
                        CommonClass.stopLoader()
                        self.mConnectIcon.image = UIImage(named: "connect_icgreen")
                        self.mConnectLabel.textColor =  UIColor(named: "themeColor")
                        self.mDeviceView.isHidden = true
                        
                    })
                })
                self.mDeviceTableView.reloadData()
                
            }
            
            self.mDeviceTableView.reloadData()
            
        } else {
            bluetoothService?.peripheral = peripheral
            peripheral.delegate = self
            centralManager?.connect(peripheral)
            CommonClass.showFullLoader(view: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.mDeviceView.isHidden = true
                self.mConnectIcon.image = UIImage(named: "connect_icgreen")
                self.mConnectLabel.textColor =  UIColor(named: "themeColor")
                CommonClass.stopLoader()
                
            })
        }
        self.mDeviceTableView.reloadData()
    }
    
    func search() {
        arrPeripheral.removeAll()
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        } else {
            if centralManager?.isScanning ?? false {
                centralManager?.stopScan()
            }
            if let peripheral = bluetoothService?.peripheral {

                arrPeripheral.append(peripheral)
            }
            let peripherls = centralManager?.retrieveConnectedPeripherals(withServices: [bluetoothService?.R5000_SERVICE, bluetoothService?.R800_3000_SERVICE].compactMap { $0 })
            
            peripherls?.map { it in
                addPeripheral(peripheral: it)
            }
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + ScanPeriod, execute: {
                self.mScanNowLabel.text = "Scan now".localizedString
                self.centralManager?.stopScan()
                self.stopScan()
            })
        }
        
        mDeviceTableView.reloadData()
    }
    
    
    func stopScan() {
        if centralManager?.isScanning ?? false {
            centralManager?.stopScan()
        }
        mDeviceTableView.reloadData()
    }
    
    func startScanner() {
        if bluetoothService?.isConnected() ?? false {
            bluetoothService?.sendCmdScannerScanStart()
            bluetoothService?.scannerIsRunning = 2

        }
    }
    func stopScanner() {
        if bluetoothService?.isConnected() ?? false {
            bluetoothService?.sendCmdScannerScanStop()
            bluetoothService?.scannerIsRunning = 0

        }
    }
    
    func startRFID() {
        if bluetoothService?.isConnected() ?? false {
            bluetoothService?.sendCmdInventory(f_s: 0, f_m: 0, to: 0)
            bluetoothService?.scannerIsRunning = 1

        }
    }
    func stopRFID() {
        
        if bluetoothService?.isConnected() ?? false {
            bluetoothService?.sendCmdStop()
            bluetoothService?.scannerIsRunning = 0

        }
    }
    
    var arrMSG : [String] = []
    func completeConnect() {
        arrMSG.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.bluetoothService?.packetClear()
            self.arrMSG.removeAll()
            self.arrMSG.append("MSG_OPEN_INTERFACE1")
            self.arrMSG.append("MSG_GET_FW_VERSION")
            self.arrMSG.append("MSG_GET_SCANNER_TYPE")
            self.arrMSG.append("MSG_SET_DEFAULT")
            self.arrMSG.append("MSG_SET_TAGFOCUS")
            self.bluetoothService?.sendCmdOpenInterface1()
        })
        
       
    }
    
    
    func receiveData() {
        var msg = bluetoothService?.popPacket()
        
        var sentMsg = ""
        while msg != nil {
            sentMsg = ""
            if arrMSG.count > 0 {
                sentMsg = arrMSG[0]

                if msg?.contains(find: "$>") == true {
                    arrMSG.removeFirst()
                    
                    sendNextMsg()
                }
            }
            switch sentMsg {
            case "MSG_GET_SCANNER_TYPE":
                if let msg = msg, msg.starts(with: "ok,"),
                   let scannerType = Int(msg.substring(from: 3)) {
                    bluetoothService?.scannerType = scannerType
                }
                break
            case "MSG_GET_FW_VERSION":
                if let msg = msg, msg.starts(with: "ok,") {
                    bluetoothService?.firmwareVer = msg.substring(from: 3)
                }
                break
            case "MSG":
                break
            default:
                break
            }
            if let msg = msg {
                if msg.starts(with: "^") ||
                    msg.starts(with: "$") ||
                    msg.starts(with: "ok") ||
                    msg.starts(with: "err") ||
                    msg.starts(with: "end") ||
                    msg.starts(with: ",") ||
                    msg.contains(find: ",e="){
                    if msg.starts(with: "err_scan=") { //no scanner
                        bluetoothService?.scannerType = 0
                    }
                    else if msg.starts(with: "ok,ver=") { // firmwareVersion
                        bluetoothService?.firmwareVer = msg.split(usingRegex: "=")[1]
                    }
                    else if msg.starts(with: "err_tag=") || msg.starts(with: "err_op=") { // read/write acc error
              
                    }
                    else if msg.starts(with: "ok,e=") { // write success

                    }
                    else if msg.contains(",e=") { // read success

                    }
                    else if msg.starts(with: "end=0,w") {

                    }
                    else if msg.starts(with: "ok,") {
                        
                    }
                    else if msg.starts(with: "$trigger=") {
                        if msg.starts(with: "$trigger=0") {
                            
                            bluetoothService?.scannerIsRunning = 0
                            stopRFID()
                            
                        } else if msg.starts(with: "$trigger=1") {
                            
                            bluetoothService?.scannerIsRunning = 1
                            startRFID()
                            
                        } else if msg.starts(with: "$trigger=2") {
                            bluetoothService?.scannerIsRunning = 0
                            stopScanner()
                        } else if msg.starts(with: "$trigger=3") {
                            bluetoothService?.scannerIsRunning = 2
                            startScanner()
                        }
                    }
                    else if msg.starts(with: "$online=0") || msg.starts(with: "$pwr=0") {
                        
                    }
                    else if msg.starts(with: "end") {
                        if msg.contains(find: "sc.start") {
                        } else if msg.contains(find: ",i") {
                      
                        }
                    }
                    else if msg.starts(with: "err") {
                        
                    }
                    else if msg.starts(with: "^") {
                        
                    }
                } else if bluetoothService?.scannerIsRunning != 0 { // rfid, barcode data
                    if  bluetoothService?.scannerIsRunning == 1 {

                        addData(msg)
                        
                    } else if bluetoothService?.scannerIsRunning == 2 {
                        
                        addDataScanner(msg)
                        
                    }
                }
            }
            msg = bluetoothService?.popPacket()
        }
    }
    
    func addData(_ data: String) {
        var time = "", rssi = "", bctype = ""
        var data = data
        if data.contains(find: ",t=") {
            time = data.split(usingRegex: ",")[1]
            if time.contains(find: ",s=") {
                time = time.split(usingRegex: ",")[0]
            }
            time = time.replace(target: "t=", withString: "")
            if data.contains(find: ",s=") {
                rssi = data.split(usingRegex: ",")[2].replace(target: "s=", withString: "")
            }
            data = data.split(usingRegex: ",")[0]
        } else if data.contains(find: ",s=") {
            rssi = data.split(usingRegex: ",")[1].replace(target: "s=", withString: "")
            data = data.split(usingRegex: ",")[0]
        } else if data.contains(find: ",z=") { // barcode
            return
        }
        
        if data.isEmpty {
            return
        }
        getRFIDData(data: data.hexToString())
        
    }
   
    func addDataScanner(_ data: String) {
        var time = "", rssi = "", bctype = ""
        var data = data
        if data.contains(find: ",t=") {
            time = data.split(usingRegex: ",")[1]
            if time.contains(find: ",s=") {
                time = time.split(usingRegex: ",")[0]
            }
            time = time.replace(target: "t=", withString: "")
            if data.contains(find: ",s=") {
                rssi = data.split(usingRegex: ",")[2].replace(target: "s=", withString: "")
            }
            data = data.split(usingRegex: ",")[0]
        } else if data.contains(find: ",s=") {
            rssi = data.split(usingRegex: ",")[1].replace(target: "s=", withString: "")
            data = data.split(usingRegex: ",")[0]
        } else if data.contains(find: ",z=") {
            bctype = data.split(usingRegex: ",")[1].replace(target: "z=", withString: "")
            data = data.split(usingRegex: ",")[0]
            if data.isEmpty {
                return
            }
        }
     
        getRFIDData(data: data)
        
    }
    func sendNextMsg() {
        let msg = arrMSG.count > 0 ? arrMSG[0] : ""
        switch msg {
        case "MSG_GET_FW_VERSION":
            bluetoothService?.sendGetVersion()
            break
        case "MSG_GET_SCANNER_TYPE":
            bluetoothService?.sendGetScannerType()
            break
        case "MSG_SET_DEFAULT":
            bluetoothService?.sendSetDefaultParameter()
            break
        case "MSG_SET_POWER":
            bluetoothService?.sendSettingTxPower(power: 0)
            break
        case "MSG_SET_TX_CYCLE":
            bluetoothService?.sendSettingTxCycle(on: 40, off: 140)
            break
        case "MSG_SET_INVENTORY_PARAM":
            bluetoothService?.sendInventoryParam(session: 1, q: 5, m_ab: 0)
            break
        case "MSG_SET_TAGFOCUS":
            bluetoothService?.sendCmdRfidTagFocus(enable: 0)
            break
        default:
            break
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unsupported:
            self.centralManager = nil
            self.bluetoothService?.peripheral = nil
            break
        case .unauthorized:
            self.centralManager = nil
            self.bluetoothService?.peripheral = nil
            break
        case .poweredOff:
            self.centralManager = nil
            self.bluetoothService?.peripheral = nil
            break
        case .poweredOn:
            let peripherls = centralManager?.retrieveConnectedPeripherals(withServices: [self.bluetoothService?.R5000_SERVICE, self.bluetoothService?.R800_3000_SERVICE].compactMap { $0 })
            
            peripherls?.map { it in
                addPeripheral(peripheral: it)
            }
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + ScanPeriod, execute: {
                self.centralManager?.stopScan()
            })
            break
        default:
            self.centralManager = nil
            self.bluetoothService?.peripheral = nil
            break
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        addPeripheral(peripheral: peripheral)
    }
    func addPeripheral(peripheral: CBPeripheral) {
        var isContain = false
        arrPeripheral.map { it in
            if it == peripheral {
                isContain = true
            }
        }
        
        if let name = peripheral.name, !isContain, let service = bluetoothService {
            if name.starts(with: service.HQ_UHF_READER) ||
                name.starts(with: service.TSS900_UHF_READER) ||
                name.starts(with: service.DOTR900_UHF_READER) ||
                name.starts(with: service.DOTR800_UHF_READER) ||
                name.starts(with: service.G2W_UHF_READER) ||
                name.starts(with: service.TSS2000_UHF_READER) ||
                name.starts(with: service.DOT2000_UHF_READER) ||
                name.starts(with: service.DOTR3000_UHF_READER) ||
                name.starts(with: service.TSS3000_UHF_READER) ||
                name.starts(with: service.RF800_UHF_READER) ||
                name.starts(with: service.DOTR5000_UHF_READER) {
                arrPeripheral.append(peripheral)
                mDeviceTableView.reloadData()
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        central.stopScan()
     
        if peripheral == self.bluetoothService?.peripheral {
            prevPeripheral = peripheral
            self.bluetoothService?.reset()
            peripheral.discoverServices([self.bluetoothService?.R5000_SERVICE, self.bluetoothService?.R800_3000_SERVICE, self.bluetoothService?.R800_3000_TSERVICE].compactMap { $0 })
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.bluetoothService?.peripheral {
            self.bluetoothService?.peripheral = nil
        }
    }
    
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services,
           let bluetoothService = self.bluetoothService,
           peripheral == self.bluetoothService?.peripheral {
            
            if let r5000Service = services.first(where: { $0.uuid == bluetoothService.R5000_SERVICE }) {

                peripheral.discoverCharacteristics([bluetoothService.R5000_RX, bluetoothService.R5000_TX], for: r5000Service)
                
            } else {
                for service in services {

                    if service.uuid == bluetoothService.R5000_SERVICE ||
                        service.uuid == bluetoothService.R800_3000_SERVICE ||
                        service.uuid == bluetoothService.R800_3000_TSERVICE {

                        //Now kick off discovery of characteristics
                        peripheral.discoverCharacteristics(nil, for: service)
                        
                    }
                }
            }
        }
    }

    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characteristics = service.characteristics, peripheral == self.bluetoothService?.peripheral {
            for characteristic in characteristics {
               
                completeConnect()
                
                if characteristic.properties.contains(.notify) {
                  
                    self.bluetoothService?.readCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                    if bluetoothService?.writeCharacteristic != nil {
                        completeConnect()
                    }
                } else {
                    self.bluetoothService?.readCharacteristic = nil
                }
                
                if (characteristic.uuid == self.bluetoothService?.R5000_TX && service.uuid == self.bluetoothService?.R5000_SERVICE) || (characteristic.uuid == self.bluetoothService?.R800_3000_TX && service.uuid == self.bluetoothService?.R800_3000_TSERVICE) {
                    if characteristic.properties.contains(.notify) {
                        
                        self.bluetoothService?.readCharacteristic = characteristic
                        peripheral.setNotifyValue(true, for: characteristic)
                        if bluetoothService?.writeCharacteristic != nil {
                            completeConnect()
                        }
                    } else {
                        self.bluetoothService?.readCharacteristic = nil
                    }
                } else if (characteristic.uuid == self.bluetoothService?.R5000_RX && service.uuid == self.bluetoothService?.R5000_SERVICE) || (characteristic.uuid == self.bluetoothService?.R800_3000_RX && service.uuid == self.bluetoothService?.R800_3000_SERVICE) {
                    if characteristic.properties.contains(.write) ||  characteristic.properties.contains(.writeWithoutResponse) {
                       
                        self.bluetoothService?.writeCharacteristic = characteristic
                        if bluetoothService?.readCharacteristic != nil {
                            completeConnect()
                        }
                    } else {
                        self.bluetoothService?.writeCharacteristic = nil
                    }
                    
                }
            }
            
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Error Writing... \(error?.localizedDescription ?? "")")
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("Error Writing : \(error?.localizedDescription ?? "")")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let val = characteristic.value, let str = String(data: val, encoding: .utf8) {

        }
        
        switch characteristic.uuid {
        case self.bluetoothService?.R5000_TX:
            if characteristic.service?.uuid == self.bluetoothService?.R5000_SERVICE {
                self.bluetoothService?.pushPacket(data: characteristic.value)
            }
            break
        case self.bluetoothService?.R800_3000_TX2:
            
            if characteristic.service?.uuid == self.bluetoothService?.R800_3000_TSERVICE {
                self.bluetoothService?.pushPacket(data: characteristic.value)
                
            }
            break
        default:
            print("didUpdateValues: " + characteristic.uuid.uuidString + characteristic.description)
        }
        
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let val = characteristic.value, let str = String(data: val, encoding: .utf8) {

        }
        switch characteristic.uuid {
        case self.bluetoothService?.R5000_TX:
            if characteristic.service?.uuid == self.bluetoothService?.R5000_SERVICE {
                self.bluetoothService?.pushPacket(data: characteristic.value)
            }
            break
        case self.bluetoothService?.R800_3000_TX:
            if characteristic.service?.uuid == self.bluetoothService?.R800_3000_TSERVICE {
                self.bluetoothService?.pushPacket(data: characteristic.value)
            }
            break
        default:
            print("didUpdateNotificationStateFor: " + characteristic.uuid.uuidString + characteristic.description)
        }
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.mItemCollectionView {
            count = mItemsData.count
            
        }else if collectionView == self.mCollectCollectionView {
            count = mCollectionData.count
            
            
        }else if collectionView == self.mMetalCollectionView {
            count = mMetalsData.count
            
        }else if collectionView == self.mLocationCollectionView {
            count = mLocationsData.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if collectionView == self.mItemCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
                return UICollectionViewCell()
            }
            
            if let mData = mItemsData[indexPath.row] as? NSDictionary {
                
                cells.mItemName.text = mData.value(forKey: "name") as? String
                if let mItemsDataId = mData.value(forKey: "_id") as? String {
                    cells.mItemName.backgroundColor = mItemsId.contains(mItemsDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                    cells.backgroundColor = mItemsId.contains(mItemsDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                }
            }
            cells.layoutSubviews()
            cell = cells
        } else if collectionView == self.mCollectCollectionView {
            
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else {
                return UICollectionViewCell()
            }
            
            if let mData = mCollectionData[indexPath.row] as? NSDictionary {
                
                cells.mCollectionName.text = mData.value(forKey: "name") as? String
                if let mCollectionDataId = mData.value(forKey: "_id") as? String {
                    cells.mCollectionName.backgroundColor = mCollectionId.contains(mCollectionDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                    cells.backgroundColor = mCollectionId.contains(mCollectionDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                }
            
            }
            cells.layoutSubviews()
            cell = cells
            
        } else if collectionView == self.mMetalCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "MetalCell", for: indexPath) as? MetalCell else {
                return UICollectionViewCell()
            }
            
            if let mData = mMetalsData[indexPath.row] as? NSDictionary {
                cells.mMetalName.text = mData.value(forKey: "name") as? String
                if let mMetalsDataId = mData.value(forKey: "_id") as? String {
                    cells.mMetalName.backgroundColor = mMetalsId.contains(mMetalsDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                    cells.backgroundColor = mMetalsId.contains(mMetalsDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                }
                
            }
            cells.layoutSubviews()
            cell = cells
            
        } else if collectionView == self.mLocationCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as? LocationCell else {
                return UICollectionViewCell()
            }
            
            if let mData = mLocationsData[indexPath.row] as? NSDictionary {
                cells.mLocationName.text = mData.value(forKey: "name") as? String
                
                if let mLocationDataId = mData.value(forKey: "_id") as? String {
                    cells.mLocationName.backgroundColor = mLocationsId.contains(mLocationDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                    cells.backgroundColor = mLocationsId.contains(mLocationDataId) ? #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                }
               
            }
            cells.layoutSubviews()
            cell = cells
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.mLocationCollectionView {
            
            if let mData = mLocationsData[indexPath.row] as? NSDictionary {
                if let mLocationsDataId = mData.value(forKey: "id") as? String {
                    if mLocationsId.contains(mLocationsDataId) {
                        mLocationsId = mLocationsId.filter {$0 != mLocationsDataId }
                    }else{
                        mLocationsId.append(mLocationsDataId)
                    }
                }
                
            }
            self.mLocationCollectionView.reloadData()
            
        }
        
        if collectionView == self.mMetalCollectionView {
            
            if let mData = mMetalsData[indexPath.row] as? NSDictionary {
                if let mMetalsDataId = mData.value(forKey: "id") as? String {
                    if mMetalsId.contains(mMetalsDataId) {
                        mMetalsId = mMetalsId.filter {$0 != mMetalsDataId }
                    }else{
                        mMetalsId.append(mMetalsDataId)
                    }
                }
            }
            self.mMetalCollectionView.reloadData()
            
        }
        
        if collectionView == self.mItemCollectionView {
            
            if let mData = mItemsData[indexPath.row] as? NSDictionary {
                if let mItemsDataId = mData.value(forKey: "id") as? String {
                    if mItemsId.contains(mItemsDataId) {
                        mItemsId = mItemsId.filter {$0 != mItemsDataId }
                    }else{
                        mItemsId.append(mItemsDataId)
                    }
                }
            }
            self.mItemCollectionView.reloadData()
            
        }
        if collectionView == self.mCollectCollectionView {
            
            if let mData = mCollectionData[indexPath.row] as? NSDictionary {
                if let mCollectionDataId = mData.value(forKey: "id") as? String {
                    if mCollectionId.contains(mCollectionDataId) {
                        mCollectionId = mCollectionId.filter {$0 != mCollectionDataId }
                    }else{
                        mCollectionId.append(mCollectionDataId)
                    }
                }
            }
            self.mCollectCollectionView.reloadData()
        }
   
    }

    
    @IBAction func mClearAllFilters(_ sender: Any) {
        
        self.mItemsId.removeAll()
        self.mCollectionId.removeAll()
        self.mMetalsId.removeAll()
        self.mStonesId.removeAll()
        self.mLocationsId.removeAll()
        self.mSizeId.removeAll()
        self.mItemCollectionView.reloadData()
        self.mCollectCollectionView.reloadData()
        self.mMetalCollectionView.reloadData()

        self.mLocationCollectionView.reloadData()

        
        self.mScannedStocks.text = "0"
        self.mUnscannedStocks.text = "0"
        self.mConflictStocks.text = "0"
        self.mSCANNED = NSMutableArray()
        self.mUNSCANNED = NSMutableArray()
        self.mCONFLICT = [String]()
        self.mUnknownStocks.text = "0"
        
        self.mScannedData = [String]()
        self.mScannedSKU = [String]()
        self.mScannedCount = [Int]()
        self.mUnscannedData = [String]()
        self.mConflictData = [String]()
        self.mInventoryData = NSArray()
        self.mStatusData = NSMutableArray()
        self.mSCANNED = NSMutableArray()
        self.mUNSCANNED = NSMutableArray()
        
        self.mSAVESCANNED = NSMutableArray()
        self.mSAVEUNSCANNED = NSMutableArray()
        self.mCONFLICT = [String]()
        self.FINALCONFLICT = [String]()
        
        mGetInventoryDataStock(key:  "")
        
    }
    
    @IBAction func mSelectAllItems(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mItemsId.removeAll()
            
            mItemCollectionView.reloadData()
            
        }else{
            
            sender.isSelected = true
            mItemsId.removeAll()
            
            for (index, _) in self.mItemsData.enumerated(){
                if let mData = mItemsData[index] as? NSDictionary, let id = mData.value(forKey: "_id") as? String {
                    mItemsId.append(id)
                }
            }
            sender.setTitle("Deselect".localizedString, for: .normal)
            mItemCollectionView.reloadData()
            
        }
    }

    @IBAction func mSelectAllCollection(_ sender: UIButton) {
        
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mCollectionId.removeAll()
            
            mCollectCollectionView.reloadData()
            
        }else{
            sender.setTitle("Deselect".localizedString, for: .normal)
            sender.isSelected = true
            mCollectionId.removeAll()
            
            
            for (index, _) in self.mCollectionData.enumerated(){
                if let mData = mCollectionData[index] as? NSDictionary, let id = mData.value(forKey: "id") as? String {
                    mCollectionId.append(id)
                }
            }
            mCollectCollectionView.reloadData()
            
        }
    }
  
    
    @IBAction func mSelectAllMetals(_ sender: UIButton) {
        
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mMetalsId.removeAll()
            
            mMetalCollectionView.reloadData()
            
        }else{
            sender.setTitle("Deselect".localizedString, for: .normal)
            sender.isSelected = true
            mMetalsId.removeAll()
            
            
            for (index, _) in self.mMetalsData.enumerated(){
                
                if let mData = mMetalsData[index] as? NSDictionary, let id = mData.value(forKey: "id") as? String {
                    mMetalsId.append(id)
                }
            }
            mMetalCollectionView.reloadData()
            
        }
    }
    
    @IBAction func mSelectAllLocation(_ sender: UIButton) {
        
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mLocationsId.removeAll()
            
            mLocationCollectionView.reloadData()
            
        }else{
            
            sender.isSelected = true
            sender.setTitle("Deselect".localizedString, for: .normal)
            mLocationsId.removeAll()
            
            
            for (index, _) in self.mLocationsData.enumerated(){
                if let mData = mLocationsData[index] as? NSDictionary, let id = mData.value(forKey: "id") as? String {
                    mLocationsId.append(id)
                }
            }
            mLocationCollectionView.reloadData()
            
        }
    }

    @IBAction func mSaveData(_ sender: Any) {
        
    }
    
    @IBAction func mSearchStock(_ sender: UITextField) {
        
    }
    
    func mGetScanResults() {
        var isUnknown = true
        for i in mStatusData {
            if let mValue = i as? NSMutableDictionary,
               let sku = mValue.value(forKey: "SKU") as? String,
               let stockID = mValue.value(forKey: "stock_id") as? String,
               let poQtyString = mValue.value(forKey: "po_QTY") as? String,
               let poQty = Int(poQtyString) {
                
                let searchKey = mSearchStock.text
                if searchKey == sku || searchKey == stockID {
                    if !mScannedData.contains(stockID) {
                        mScannedData.append(stockID)
                        mScannedCount.append(poQty)
                        let items = uniqueElementsFrom(array: mScannedData)
                        mScannedData = items
                        mScannedStocks.text = "\(mScannedCount.reduce(0, {$0 + $1}))"
                        let mUnsCount = (Int(mTotalStocks.text ?? "0") ?? 0) - (Int(mScannedStocks.text ?? "0") ?? 0)
                        mUnscannedStocks.text = "\(mUnsCount)"
                        mSCANNED.add(mValue)
                        
                        let mData = NSMutableDictionary()
                        mData.setValue(stockID, forKey: "stock_id")
                        mData.setValue(poQty, forKey: "po_QTY")
                        mData.setValue(sku, forKey: "SKU")
                        mData.setValue("\(mValue.value(forKey: "_id") ?? "")", forKey: "_id")
                        mData.setValue("\(mValue.value(forKey: "location_id") ?? "")", forKey: "location_id")
                        
                        mSAVESCANNED.add(mData)
                    }
                    isUnknown = false
                }
            }
        }
        
        if isUnknown {
            
            let mUnknowdNewData = NSMutableDictionary()
            mUnknowdNewData.setValue(mSearchStock.text ?? "", forKey: "SKU")
            mUnknowdNewData.setValue(mSearchStock.text ?? "", forKey: "stock_id")
            mUnknowdNewData.setValue("", forKey: "po_QTY")
            mUnknowdNewData.setValue("", forKey: "_id")
            mUnknowdNewData.setValue("", forKey: "location_id")
            self.mUNKNOWNARRAY.add(mUnknowdNewData)
            
            
            mCONFLICT.append(mSearchStock.text ?? "" + "UKN")
            let items = uniqueElementsFrom(array: mCONFLICT)
            mCONFLICT = items
    
        }
        
        mStatus()
        
    }
    
    func getRFIDData(data: String){
        var mUnknown = true
        for i in mStatusData {
            
            if let mValue = i as? NSMutableDictionary,
               let sku = mValue.value(forKey: "SKU") as? String,
               let stockID = mValue.value(forKey: "stock_id") as? String,
               let poQtyString = mValue.value(forKey: "po_QTY") as? String,
               let poQty = Int(poQtyString) {
                
                if !data.isEmpty {
                    let searchKey = data
                    if searchKey == sku || searchKey == stockID {
                        if !mScannedData.contains(stockID){
                            mScannedData.append(stockID)
                            mScannedCount.append(poQty)
                            let items = uniqueElementsFrom(array: mScannedData)
                            mScannedData = items
                            mScannedStocks.text = "\(mScannedCount.reduce(0, {$0 + $1}))"
                            let mUnsCount = (Int(mTotalStocks.text ?? "0") ?? 0) - (Int(mScannedStocks.text ?? "0") ?? 0)
                            mUnscannedStocks.text = "\(mUnsCount)"
                            mSCANNED.add(mValue)
                            
                            let mData = NSMutableDictionary()
                            mData.setValue(stockID, forKey: "stock_id")
                            mData.setValue(poQty, forKey: "po_QTY")
                            mData.setValue(sku, forKey: "SKU")
                            mData.setValue("\(mValue.value(forKey: "_id") ?? "")", forKey: "_id")
                            mData.setValue("\(mValue.value(forKey: "location_id") ?? "")", forKey: "location_id")
                            
                            mSAVESCANNED.add(mData)
                        }
                        mUnknown = false
                    }else{
                        
                    }
                    
                }
            }
        }
        
        if mUnknown {
            let mUnknowdNewData = NSMutableDictionary()
            mUnknowdNewData.setValue(mSearchStock.text ?? "", forKey: "SKU")
            mUnknowdNewData.setValue(mSearchStock.text ?? "", forKey: "stock_id")
            mUnknowdNewData.setValue("", forKey: "po_QTY")
            mUnknowdNewData.setValue("", forKey: "_id")
            mUnknowdNewData.setValue("", forKey: "location_id")
            self.mUNKNOWNARRAY.add(mUnknowdNewData)
            
            
            mCONFLICT.append(mSearchStock.text ?? "" + "UKN")
            let items = uniqueElementsFrom(array: mCONFLICT)
            mCONFLICT = items
        }
        
        
        mPowerView.isHidden = true
        mPowerIcon.image = UIImage(named: "power_icgrey")
        mPowerLabel.textColor =  UIColor(named: "theme6A")
        mStatus()
    }
    
    func mStatus(){
        mUNSCANNED = NSMutableArray()
        mSAVEUNSCANNED = NSMutableArray()
        
        var mCONF = [String]()
        var mUNK = [String]()

        
        if mCONFLICT.count > 0 {
            for i in 0...mCONFLICT.count - 1 {
                
                FINALCONFLICT.append(mCONFLICT[i].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted))
                let items = uniqueElementsFrom(array: FINALCONFLICT)
                FINALCONFLICT = items
                if mCONFLICT[i].contains("UKN") {
                    mUNK.append(mCONFLICT[i])
                }else{
                    mCONF.append(mCONFLICT[i])
                }
            }
            mConflictStocks.text = "\(mCONF.count)"
            mUnknownStocks.text = "\(mUNK.count)"
            
        }
        
        for i in mStatusData {
            if let mValue = i as? NSDictionary,
               let stockID = mValue.value(forKey: "stock_id") as? String,
               let poQtyString = mValue.value(forKey: "po_QTY") as? String,
               let poQty = Int(poQtyString),
               !mScannedData.contains(stockID) {
                
                let mData = NSMutableDictionary()
                mData.setValue(stockID, forKey: "stock_id")
                mData.setValue(poQty, forKey: "QTY")
                mData.setValue(mValue.value(forKey: "SKU") as? String ?? "", forKey: "SKU")
                mData.setValue(mValue.value(forKey: "_id") as? String ?? "", forKey: "po_product_id")
                mData.setValue(mValue.value(forKey: "location_id") as? String ?? "", forKey: "location_id")
                
                mSAVEUNSCANNED.add(mData)
                mUNSCANNED.add(mValue)
            }
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        mSearchStock.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        mSearchStock.resignFirstResponder()
        mGetScanResults()
    }
    
    @IBAction func mHideDeviceView(_ sender: Any) {

        mDeviceView.isHidden = true
    }
    @IBAction func mHideScanner(_ sender: Any) {
        mScannerView.isHidden = true
        
        shape.removeFromSuperlayer()
        self.mScannerCamView.layer.sublayers?.remove(at: 0)
        layer.sublayers?.remove(at: 1)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        captureSession = nil
        
        
    }
    
    @IBAction func mOpenScanner(_ sender: Any) {
        mStartQRcode()
    }
    
    
    @IBAction func mStart(_ sender: UIButton) {
        
        
        
        if bluetoothService?.isConnected() == true {
            if sender.isSelected == true {
                sender.isSelected = false
                mStartIcon.image = UIImage(named: "play_icgreen")
                stopRFID()
            }else{
                sender.isSelected = true
                mStartIcon.image = UIImage(named: "play_icred")
                startRFID()
            }
        }else{
            if sender.isSelected == true {
                sender.isSelected = false
                
                mStartIcon.image = UIImage(named: "play_icgreen")
                
            }
            
        }
    }
    
    
    @IBAction func mScanNow(_ sender: UIButton) {
        
        if centralManager?.isScanning ?? false {
            self.mScanNowLabel.text = "Scan now".localizedString
            stopScan()
        } else {
            self.mScanNowLabel.text = "Scanning".localizedString
            search()
        }
        
    }
    
    @IBAction func mConnect(_ sender: UIButton) {
        
        mPowerView.isHidden = true
        mPowerIcon.image = UIImage(named: "power_icgrey")
        mPowerLabel.textColor =  UIColor(named: "theme6A")
        
        search()
        mDeviceView.isHidden = false
        
        if bluetoothService?.isConnected() == true {

            mStartIcon.image = UIImage(named: "play_icgreen")
            mConnectIcon.image = UIImage(named: "connect_icgrey")
            mConnectLabel.textColor =  UIColor(named: "theme6A")
            stopRFID()
            stopScan()
            
            
        }else{
   
            mStartIcon.image = UIImage(named: "play_icgreen")
            mDeviceView.isHidden = false
            mConnectIcon.image = UIImage(named: "connect_icgreen")
            mConnectLabel.textColor = UIColor(named: "themeColor")
            mDeviceData = NSMutableArray()
            self.mDeviceTableView.reloadData()
            search()
            
            
        }
        if sender.isSelected == true {
            sender.isSelected = false
            
        }else{
            
            sender.isSelected = true
            
            
        }
        
    }
    
    
    
    
    @IBAction func mHome(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:true)
    }
    
    
    @IBAction func mTotalScanned(_ sender: Any) {
        if mTotalStocks.text != "0" {
            if let mTotalStock = storyBoard.instantiateViewController(withIdentifier: "TotalStock") as? TotalStock {
                mTotalStock.mType = "Total"
                mTotalStock.mTotalStockData = mStatusData
                
                mTotalStock.mCount = mTotalStocks.text ?? "0"
                self.navigationController?.pushViewController(mTotalStock, animated:true)
            }
        }
        
    }
    @IBAction func mScanned(_ sender: Any) {
        
        if mScannedStocks.text != "0" {
            
            if let mTotalStock = storyBoard.instantiateViewController(withIdentifier: "TotalStock") as? TotalStock {
                mTotalStock.mType = "Scanned"
                mTotalStock.mTotalStockData = mSCANNED
                mTotalStock.mCount = mScannedStocks.text ?? "0"
                self.navigationController?.pushViewController(mTotalStock, animated:true)
            }
        }
    }
    @IBAction func mUnscanned(_ sender: Any) {
        
        if mUnscannedStocks.text != "0" {
            if let mTotalStock = storyBoard.instantiateViewController(withIdentifier: "TotalStock") as? TotalStock {
                mTotalStock.mType = "Unscanned"
                mTotalStock.mTotalStockData = mUNSCANNED
                mTotalStock.mCount = mUnscannedStocks.text ?? "0"
                self.navigationController?.pushViewController(mTotalStock, animated:true)
            }
        }
    }
    
    @IBAction func mConflictUnknown(_ sender: Any) {
        
        if mConflictStocks.text != "0" || mUnknownStocks.text != "0"{
            if let mConflictUnknownStock = storyBoard.instantiateViewController(withIdentifier: "ConflictUnknownStock") as? ConflictUnknownStock {
                mConflictUnknownStock.mConflictData = mCONFLICT
                mConflictUnknownStock.mCount = mConflictStocks.text ?? "0"
                self.navigationController?.pushViewController(mConflictUnknownStock, animated:true)
            }
        }
    }
    
    @IBAction func mUnknownTags(_ sender: Any) {
        
        if mConflictStocks.text != "0" || mUnknownStocks.text != "0"{
            if let mConflictUnknownStock = storyBoard.instantiateViewController(withIdentifier: "ConflictUnknownStock") as? ConflictUnknownStock {
                mConflictUnknownStock.mConflictData = mCONFLICT
                mConflictUnknownStock.mCount = "\((Int(mConflictStocks.text ?? "0") ?? 0) + (Int(mUnknownStocks.text ?? "0") ?? 0))"
                self.navigationController?.pushViewController(mConflictUnknownStock, animated:true)
            }
        }
    }
    
    
    
    @IBAction func mRefresh(_ sender: Any) {
        
        if mStartIcon.image == UIImage(named: "play_icred") {
            
        }else{
            mRefreshIcon.image = UIImage(named: "refresh_icgreen")
            mRefreshLabel.textColor =  UIColor(named: "themeColor")
            self.mTimer = .scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.mTimerForButton), userInfo: nil, repeats: false)
        }
        
    }
    @IBAction func mPower(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if bluetoothService?.isConnected() == true {
            if centralManager?.isScanning == true {
                mPowerView.isHidden = true
                mPowerIcon.image = UIImage(named: "power_icgrey")
                mPowerLabel.textColor =  UIColor(named: "theme6A")
                return
            }
            
            if sender.isSelected {
                mPowerView.isHidden = true
                mPowerIcon.image = UIImage(named: "power_icgrey")
                mPowerLabel.textColor =  UIColor(named: "theme6A")
            }else{
                
                mPowerView.isHidden = false
                mPowerIcon.image = UIImage(named: "power_icgreen")
                mPowerLabel
                    .textColor =  UIColor(named: "themeColor")
                
            }
        }else{
            mPowerView.isHidden = true
            mPowerIcon.image = UIImage(named: "power_icgrey")
            mPowerLabel.textColor =  UIColor(named: "theme6A")
        }
        
        
        if centralManager?.isScanning ?? false{
            
        }else{
            
        }
        
    }
    
    @IBAction func mMore(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if mScannedStocks.text != "0" {
            
            mMoreIcon.image = UIImage(named: "save_ic")
            mMoreLabel.textColor =  UIColor(named: "themeColor")
 
            getVoucherID()
            
        }else{
            
            mMoreIcon.image = UIImage(named: "save_icg")
            mMoreLabel.textColor =  UIColor(named: "theme6A")
            CommonClass.showSnackBar(message: "No Data Scanned!")
        }
    }
    
    @objc
    func mTimerForButton(){
        
        mItemsId = [String]()
        mMetalsId = [String]()
        mCollectionId = [String]()
        mStonesId = [String]()
        mSizeId = [String]()
        mStatusId = [String]()
        mLocationsId = [String]()
        mMinPrices = ""
        mMaxPrices = ""
        self.mScannedStocks.text = "0"
        self.mUnscannedStocks.text = "0"
        self.mConflictStocks.text = "0"
        self.mSCANNED = NSMutableArray()
        self.mUNSCANNED = NSMutableArray()
        self.mCONFLICTARRAY = NSMutableArray()
        self.mUNKNOWNARRAY = NSMutableArray()
        self.mCONFLICT = [String]()
        self.mUnknownStocks.text = "0"
        
        self.mScannedData = [String]()
        self.mScannedSKU = [String]()
        self.mScannedCount = [Int]()
        self.mUnscannedData = [String]()
        self.mConflictData = [String]()
        self.mInventoryData = NSArray()
        self.mStatusData = NSMutableArray()
        self.mSCANNED = NSMutableArray()
        self.mUNSCANNED = NSMutableArray()
        
        self.mSAVESCANNED = NSMutableArray()
        self.mSAVEUNSCANNED = NSMutableArray()
        self.mCONFLICTARRAY = NSMutableArray()
        self.mUNKNOWNARRAY = NSMutableArray()
        self.mCONFLICT = [String]()
        self.FINALCONFLICT = [String]()

        mScannedData = [String]()
        mScannedSKU = [String]()
        mScannedCount = [Int]()
        mUnscannedData = [String]()
        mConflictData = [String]()
        mInventoryData = NSArray()
        mStatusData = NSMutableArray()
        mSCANNED = NSMutableArray()
        mUNSCANNED = NSMutableArray()
        mRefreshIcon.image = UIImage(named: "refresh_icgrey")
        mRefreshLabel.textColor =  UIColor(named: "theme6A")
        mScannedStocks.text = "0"
        mUnscannedStocks.text = "0"
        mConflictStocks.text = "0"
        
        mUnknownStocks.text = "0"
        self.mGetInventoryDataStock(key: "")
        
        self.mTimer.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrPeripheral.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceItems") as? DeviceItems else { return UITableViewCell() }
        cell.setData(arrPeripheral[indexPath.row], arrPeripheral[indexPath.row] == bluetoothService?.peripheral)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connect(arrPeripheral[indexPath.row])
        self.mDeviceTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
      
    func mStartQRcode(){
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        
            metadataOutput.metadataObjectTypes = [.code128,.code39,
                                                  .qr,.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = mScannerCamView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        mScannerCamView.layer.addSublayer(previewLayer)
        mScannerView.isHidden = false
        captureSession.startRunning()
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }


    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        
        var mUnknown = true
        for i in mStatusData {
            
            if let mValue = i as? NSMutableDictionary,
               let sku = mValue.value(forKey: "SKU") as? String,
               let stockID = mValue.value(forKey: "stock_id") as? String,
               let poQtyString = mValue.value(forKey: "po_QTY") as? String,
               let poQty = Int(poQtyString) {
                
                if !code.isEmpty {
                    let searchKey = code
                    if searchKey == sku || searchKey == stockID {
                        if !mScannedData.contains(stockID){
                            mScannedData.append(stockID)
                            mScannedCount.append(poQty)
                            let items = uniqueElementsFrom(array: mScannedData)
                            mScannedData = items
                            mScannedStocks.text = "\(mScannedCount.reduce(0, {$0 + $1}))"
                            let mUnsCount = (Int(mTotalStocks.text ?? "0") ?? 0) - (Int(mScannedStocks.text ?? "0") ?? 0)
                            mUnscannedStocks.text = "\(mUnsCount)"
                            mSCANNED.add(mValue)
                            
                            let mData = NSMutableDictionary()
                            mData.setValue(stockID, forKey: "stock_id")
                            mData.setValue(poQty, forKey: "po_QTY")
                            mData.setValue(sku, forKey: "SKU")
                            mData.setValue("\(mValue.value(forKey: "_id") ?? "")", forKey: "_id")
                            mData.setValue("\(mValue.value(forKey: "location_id") ?? "")", forKey: "location_id")
                            
                            mSAVESCANNED.add(mData)
                        }
                        mUnknown = false
                    }else{
                        
                    }
                }
            }
        }
        
        if mUnknown {
            let mUnknowdNewData = NSMutableDictionary()
            mUnknowdNewData.setValue(mSearchStock.text ?? "", forKey: "SKU")
            mUnknowdNewData.setValue(mSearchStock.text ?? "", forKey: "stock_id")
            mUnknowdNewData.setValue("", forKey: "po_QTY")
            mUnknowdNewData.setValue("", forKey: "_id")
            mUnknowdNewData.setValue("", forKey: "location_id")
            self.mUNKNOWNARRAY.add(mUnknowdNewData)
            
            
            mCONFLICT.append(mSearchStock.text ?? "" + "UKN")
            let items = uniqueElementsFrom(array: mCONFLICT)
            mCONFLICT = items
        }
        
        if captureSession != nil {
            captureSession.startRunning()
        }
        mStatus()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func mGetInventoryDataStock(key: String) {
        let params: [String: Any] = [
            "price": ["min": mMinPrices, "max": mMaxPrices],
            "item": mItemsId,
            "collection": mCollectionId,
            "location": mLocationsId,
            "metal": mMetalsId,
            "stone": mStonesId,
            "size": mSizeId,
        ]
        
        let urlPath = mGetStockTake
        
        
        guard Reachability.isConnectedToNetwork() else {
            CommonClass.showSnackBar(message: "No Internet Connection")
            return
        }
        
        CommonClass.showLoader(view: sStockTakeLoading)
        
        mGetData(url: urlPath, headers: sGisHeaders, params: params) { response, status in
            CommonClass.stopLoader()

            
            guard status else {
                CommonClass.showSnackBar(message: "Oops, something went wrong!")
                return
            }
            
            if let mCode = response.value(forKey: "code") as? Int, mCode == 403 {
                CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                return
            }
            
            if let code = response.value(forKey: "code") as? Int, code == 200 {
                if let mData = response.value(forKey: "data") as? [NSDictionary] {
         
                    self.mInventoryData = mData as NSArray
                    var arr = [NSMutableDictionary]()
                    var totalPoQty = 0
                    var unscannedPoQty = 0
                    var unscannedData = [NSDictionary]()
                    
                    for data in mData {
                        if let SKU = data["SKU"] as? String,
                           let stock_id = data["stock_id"] as? String,
                           let poQty = Int("\(data["po_QTY"] ?? "0")"),
                           let _id = data["_id"] as? String,
                           let location_id = data["location_id"] as? String {
                            
                            let poQtyString = "\(data["po_QTY"] ?? "0")"
                            
                            let mData = NSMutableDictionary()
                            mData.setValue(SKU, forKey: "SKU")
                            mData.setValue(stock_id, forKey: "stock_id")
                            mData.setValue(poQtyString, forKey: "po_QTY")
                            mData.setValue(_id, forKey: "_id")
                            mData.setValue(location_id, forKey: "location_id")
                            
                            arr.append(mData)
                            
                            totalPoQty += poQty
                            if poQty != 0 {
                                unscannedPoQty += poQty
                                unscannedData.append(data)
                            }
                        }
                    }
                    
                   
                    DispatchQueue.main.async {
                        self.mStatusData.removeAllObjects()
                        self.mStatusData.addObjects(from: arr)
                        self.mTotalStocks.text = "\(totalPoQty)"
                        self.mUnscannedStocks.text = "\(unscannedPoQty)"
                        self.mUNSCANNED.removeAllObjects()
                        self.mUNSCANNED.addObjects(from: unscannedData)
                    }
                } else {
                    // Handle case where response.value(forKey: "data") is empty
                 
                    DispatchQueue.main.async {
                        self.mStatusData.removeAllObjects()
                        self.mTotalStocks.text = "0"
                        self.mUnscannedStocks.text = "0"
                        self.mUNSCANNED.removeAllObjects()
                    }
                }
            } else {
                if let error = response.value(forKey: "error") as? String, error == "Authorization has been expired" {
                    CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                } else {
                    CommonClass.showSnackBar(message: "Error! \(response.value(forKey: "code") ?? "Unknown Error")")
                }
            }
        }
    }
    
    
    func mUploadStocksSave(voucherId: String){
        
        
        let mPriceData = NSMutableDictionary()
        mPriceData.setValue(mMinPrices, forKey: "min")
        mPriceData.setValue(mMaxPrices, forKey: "max")
        mFilterData.setValue(mPriceData, forKey: "price")
        mFilterData.setValue(mItemsId, forKey: "item")
        mFilterData.setValue(mCollectionId, forKey: "collection")
        mFilterData.setValue(mLocationsId, forKey: "location")
        mFilterData.setValue(mMetalsId, forKey: "metal")
        mFilterData.setValue(mStonesId, forKey: "stone")
        mFilterData.setValue(mSizeId, forKey: "size")
        
        let urlPath =  mUploadStocks
        
        let  mParams:[String:Any] = [
            "unscanned":mSAVEUNSCANNED,
            "scanned":mSAVESCANNED,
            "unknown":mUNKNOWNARRAY,
            "conflict":mCONFLICTARRAY,
            "total_scanned_qty":Int(mScannedStocks.text ?? "") ?? 0,
            "total_unscanned_qty":Int(mUnscannedStocks.text ?? "") ?? 0,
            "conflict_qty":Int(mConflictStocks.text ?? "") ?? 0,
            "unknown_qty": Int(mUnknownStocks.text ?? "") ?? 0,
            "voucher_id":voucherId,
            "filter":mFilterData]
        

        
        if Reachability.isConnectedToNetwork() == true {
            CommonClass.showFullLoader(view: self.view)
            
            AF.request(urlPath, method:.post,parameters:mParams,encoding: JSONEncoding.default, headers: sGisHeaders2).responseJSON
            { response in
                self.mMoreIcon.image = UIImage(named: "save_icg")
                self.mMoreLabel.textColor =  UIColor(named: "theme6A")
                
                CommonClass.stopLoader()
                
                guard response.error == nil else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                guard let jsonData = response.data else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                
                guard let jsonResult = json as? NSDictionary else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                if jsonResult.value(forKey: "code") as? Int == 200 {
                    CommonClass.showSnackBar(message: "Successfully Updated!")
                    self.mScannedStocks.text = "0"
                    self.mUnscannedStocks.text = "0"
                    self.mConflictStocks.text = "0"
                    self.mSCANNED = NSMutableArray()
                    self.mUNSCANNED = NSMutableArray()
                    self.mUNKNOWNARRAY = NSMutableArray()
                    self.mCONFLICTARRAY = NSMutableArray()
                    self.mCONFLICT = [String]()
                    self.mUnknownStocks.text = "0"
                    
                    self.mScannedData = [String]()
                    self.mScannedSKU = [String]()
                    self.mScannedCount = [Int]()
                    self.mUnscannedData = [String]()
                    self.mConflictData = [String]()
                    self.mInventoryData = NSArray()
                    self.mStatusData = NSMutableArray()
                    self.mSCANNED = NSMutableArray()
                    self.mUNSCANNED = NSMutableArray()
                    
                    self.mSAVESCANNED = NSMutableArray()
                    self.mSAVEUNSCANNED = NSMutableArray()
                    self.mUNKNOWNARRAY = NSMutableArray()
                    self.mCONFLICTARRAY = NSMutableArray()
                    self.mCONFLICT = [String]()
                    self.FINALCONFLICT = [String]()
                    
                    self.mGetInventoryDataStock(key: "")
                    
                }else{
                    if let error = jsonResult.value(forKey: "error") as? String {
                        if error == "Authorization has been expired" {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        }
                    }
                }
                
                
            }
        }else{
            mMoreIcon.image = UIImage(named: "save_icg")
            mMoreLabel.textColor =  UIColor(named: "theme6A")
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
    
    func getVoucherID(){
        let params:[String: Any] = [
            "query":"{\n        vouchers(group: \"Stock_Take\") {\n          id\n          name \n      }\n        }",
            "variables":"{}"
        ]
        mGetData(url: mInventoryGrapQlUrl, headers: sGisHeaders, params: params) { response, status in
            CommonClass.stopLoader()
            
            guard status else {
                CommonClass.showSnackBar(message: "Oops, something went wrong!")
                return
            }
            
            if let dataDictionary = response.value(forKey: "data") as? [String: Any],
               let vouchersArray = dataDictionary["vouchers"] as? [[String: Any]],
               let firstVoucher = vouchersArray.first,
               let voucherId = firstVoucher["id"] as? String {
                
                self.mUploadStocksSave(voucherId: voucherId)
            } else {
               
            }
        }
    }
    
    //UI Element
    func createScanningIndicator() {
        
        let height: CGFloat = 15
        let opacity: Float = 0.4
        let topColor = UIColor.green.withAlphaComponent(0)
        let bottomColor = UIColor.green
        
        let layer = CAGradientLayer()
        layer.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.opacity = opacity
        
        let squareWidth = mScannerCamView.frame.width * 0.6
        let xOffset = mScannerCamView.frame.width * 0.2
        let yOffset = mScannerCamView.frame.midY - (squareWidth / 2)
        layer.frame = CGRect(x: xOffset, y: yOffset, width: squareWidth, height: height)
        
        self.mScannerCamView.layer.insertSublayer(layer, at: 1)
        
        let initialYPosition = layer.position.y
        let finalYPosition = initialYPosition + squareWidth - height
        let duration: CFTimeInterval = 2
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = initialYPosition as NSNumber
        animation.toValue = finalYPosition as NSNumber
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: nil)
    }
    //UI Element
    func createScanningFrame() {
        
        let lineLength: CGFloat = 15
        let squareWidth = mScannerCamView.frame.width * 0.6
        let topLeftPosX = mScannerCamView.frame.width * 0.2
        let topLeftPosY = mScannerCamView.frame.midY - (squareWidth / 2)
        let btmLeftPosY = mScannerCamView.frame.midY + (squareWidth / 2)
        let btmRightPosX = mScannerCamView.frame.midX + (squareWidth / 2)
        let topRightPosX = mScannerCamView.frame.width * 0.8
        
        let path = UIBezierPath()
        
        //top left
        path.move(to: CGPoint(x: topLeftPosX, y: topLeftPosY + lineLength))
        path.addLine(to: CGPoint(x: topLeftPosX, y: topLeftPosY))
        path.addLine(to: CGPoint(x: topLeftPosX + lineLength, y: topLeftPosY))
        
        //bottom left
        path.move(to: CGPoint(x: topLeftPosX, y: btmLeftPosY - lineLength))
        path.addLine(to: CGPoint(x: topLeftPosX, y: btmLeftPosY))
        path.addLine(to: CGPoint(x: topLeftPosX + lineLength, y: btmLeftPosY))
        
        //bottom right
        path.move(to: CGPoint(x: btmRightPosX - lineLength, y: btmLeftPosY))
        path.addLine(to: CGPoint(x: btmRightPosX, y: btmLeftPosY))
        path.addLine(to: CGPoint(x: btmRightPosX, y: btmLeftPosY - lineLength))
        
        //top right
        path.move(to: CGPoint(x: topRightPosX, y: topLeftPosY + lineLength))
        path.addLine(to: CGPoint(x: topRightPosX, y: topLeftPosY))
        path.addLine(to: CGPoint(x: topRightPosX - lineLength, y: topLeftPosY))
        
        
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 3
        shape.fillColor = UIColor.clear.cgColor
        
        self.mScannerCamView.layer.insertSublayer(shape, at: 1)
    }
    //Filter and remove duplicate item from array.
    func uniqueElementsFrom(array:[String]) -> [String] {
        
        var set = Set<String>()
        let result = array.filter {
            
            guard !set.contains($0)  else { return  false }
            
            set.insert($0)
            return true
        }
        
        return result
    }
    
    
    func mGetFilterData(){
        
        let urlPath =  mGetInventoryFilter

        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, headers: sGisHeaders2).responseJSON
            { response in
                
                guard response.error == nil else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                guard let jsonData = response.data else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                
                guard let jsonResult = json as? NSDictionary else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                if jsonResult.value(forKey: "code") as? Int == 200 {
                    
                    if let mData = jsonResult.value(forKey: "data") as? NSDictionary {
                        
                        if let mItems = mData.value(forKey: "item_name") as? NSArray {
                            if mItems.count > 0 {
                                self.mItemsData = mItems
                                self.mItemCollectionView.reloadData()
                            }
                        }
                        
                        if let mMetal = mData.value(forKey: "Metal") as? NSArray {
                            if mMetal.count > 0 {
                                self.mMetalsData = mMetal
                                self.mMetalCollectionView.reloadData()
                            }
                        }
                        
                        if let mLocation = mData.value(forKey: "location_name") as? NSArray {
                            if mLocation.count > 0 {
                                self.mLocationsData = mLocation
                                self.mLocationCollectionView.reloadData()
                            }
                        }
                    }
                    
                }else{
                    if let error = jsonResult.value(forKey: "error") as? String {
                        if error == "Authorization has been expired" {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        }
                    }
                }
                
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
    
    
    
}

extension Array where Element : Hashable{
    
    
    func removingDuplicates() -> [Element]
    {
        
        var addedDict = [Element:Bool]()
        return filter {
            addedDict.updateValue(true,forKey:$0) == nil
        }
    }
    
    
    mutating func removingDuplicates() {
        
        self = self.removingDuplicates()
    }
}

extension String {
    
    func hexToString()->String{
        
        var finalString = ""
        let chars = Array(self)
        
        for count in stride(from: 0, to: chars.count - 1, by: 2){
            let firstDigit =  Int.init("\(chars[count])", radix: 16) ?? 0
            let lastDigit = Int.init("\(chars[count + 1])", radix: 16) ?? 0
            let decimal = firstDigit * 16 + lastDigit
            let decimalString = String(format: "%c", decimal) as String
            finalString.append(decimalString.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
            )
        }
        return finalString
        
        
        
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .init(rawValue: 0))
    }
   
}

extension DataProtocol {
    func hexEncodedString(uppercase: Bool = false) -> String {
        return self.map {
            if $0 < 16 {
                return "0" + String($0, radix: 16, uppercase: uppercase)
            } else {
                return String($0, radix: 16, uppercase: uppercase)
            }
        }.joined()
    }
}
extension Data {
    func hexEncodedStrings() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

