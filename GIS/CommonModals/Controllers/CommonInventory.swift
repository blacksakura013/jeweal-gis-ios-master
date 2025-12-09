//
//  CommonInventory.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 30/12/22.
//  Copyright © 2022 Hawkscode. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import UIDrawer


protocol GetInventoryDataItemsDelegate {
    func mGetInventoryItems(items:[String])
}

class CommonInventory:UIViewController , UITableViewDelegate , UITableViewDataSource  , RangeSeekSliderDelegate, UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate, GetInventoryFiltersDelegate {
      
        
      
        //Inventory Item Details

        var delegate:GetInventoryDataItemsDelegate? = nil

        @IBOutlet weak var mReserveButtonView: UIView!
        @IBOutlet weak var mReserveButton: UIButton!
        @IBOutlet weak var mHeight: NSLayoutConstraint!
        
        @IBOutlet weak var mStockID: UILabel!
        
        @IBOutlet weak var mInventoryImage: UIImageView!
        
        @IBOutlet weak var mProductStatus: UILabel!

        @IBOutlet weak var mFilterSearchView: UIView!
         
        @IBOutlet weak var mMyInventoryTableView: UITableView!
   
        @IBOutlet weak var mInventoryDetailsView: UIView!
        @IBOutlet weak var mInventoryDetailsHeight: NSLayoutConstraint!
       
        @IBOutlet weak var mStatusDot: UILabel!
        @IBOutlet weak var mStockName: UILabel!
        @IBOutlet weak var mMetaTag: UILabel!
        @IBOutlet weak var mMetalName: UILabel!
        @IBOutlet weak var mStoneName: UILabel!
        @IBOutlet weak var mSize: UILabel!
        @IBOutlet weak var mCollectionName: UILabel!
        @IBOutlet weak var mLocationName: UILabel!
        
        //ShorSummary
        
        @IBOutlet weak var mMaterialName: UILabel!
        @IBOutlet weak var mMaterialWeight: UILabel!
        
        @IBOutlet weak var mStoneOne: UILabel!
        @IBOutlet weak var mStoneOneWeight: UILabel!
        @IBOutlet weak var mStoneTwo: UILabel!
        @IBOutlet weak var mStoneTwoWeight: UILabel!
        
        @IBOutlet weak var mCertificateName: UILabel!
        @IBOutlet weak var mCertificateNumber: UILabel!
        @IBOutlet weak var mReferenceName: UILabel!
        @IBOutlet weak var mProductSummaryView: UIStackView!
        
        @IBOutlet weak var mShowHideButton: UIButton!
        @IBOutlet weak var mShowHideSummaryIcon: UIImageView!
        
    //Filters

        var mItemsData = NSArray()
        var mItemsId = [String]()
        
        var mCollectionData = NSArray()
        var mCollectionId = [String]()
        
        var mMetalsData = NSArray()
        var mMetalsId = [String]()
        
        var mStonesData = NSArray()
        var mStonesId = [String]()
        
        var mLocationsData = NSArray()
        var mLocationsId = [String]()
        
        var mSizeData = NSArray()
        var mSizeId = [String]()
        var mStatusId = [String]()

        
        var mMinPrices = ""
        var mMaxPrices = ""
        var mFilterData = NSMutableDictionary()
       
    /**Summary*/
   
        var mStoneData = ["Diamond","Ruby","Blue Sapphire","Black Onyx","Chalcedony","Aquarmarine","Lapis Lazuli","Turquoise","Topaz","Emerald","Amethyst"]
        var mSelectedIndex = [IndexPath]()
        var mSelectedData = [String]()
       
        var mSelectedInventoryIndex = [IndexPath]()
        var mSelectedInventoryData = [String]()
        
        var mInventoryData = NSMutableArray()
        var mSummaryData = NSArray()
        
        var mIndexInv = -1
        var mIndexSum = -1
        
        
        
        
        var mReserveData = NSMutableArray()
        var mStoneDataArray = NSMutableArray()
        var mProductId = [String]()

        @IBOutlet weak var mTotalReserve: UILabel!

        
        @IBOutlet weak var mSalesPersonName: UILabel!
        var mSalesManList = [String]()
        var mSalesManIDList = [String]()
        var mCustomerId = ""
        var mSalesPersonId = ""
  
        
        let mCustomerSearchTableView = UITableView()

      
        var mReservProductsData = NSMutableArray()
        var mSearchCustomerData = NSArray()
        
        @IBOutlet weak var mSearchFIELD: UITextField!
        @IBOutlet weak var mInventoryHeadingLABEL: UILabel!
        @IBOutlet weak var mICollectionLABEL: UILabel!
        @IBOutlet weak var mIMetalLABEL: UILabel!
        @IBOutlet weak var mIStoneLABEL: UILabel!
        @IBOutlet weak var mISizeLABEL: UILabel!
        @IBOutlet weak var mISKULABEL: UILabel!
        
        @IBOutlet weak var mIStockIdLABEL: UILabel!
        @IBOutlet weak var mIQtyLABEL: UILabel!
        
        @IBOutlet weak var mIPriceLABEL: UILabel!
        
        @IBOutlet weak var mSStockLABEL: UILabel!
        
        @IBOutlet weak var mSStockHLABEL: UILabel!
        @IBOutlet weak var mSReservedLABEL: UILabel!
        @IBOutlet weak var mSAvailableLABEL: UILabel!
        
        @IBOutlet weak var mSItemLABEL: UILabel!
        @IBOutlet weak var mSCollectionLABEL: UILabel!
        
        @IBOutlet weak var mSLocationLABEL: UILabel!
        @IBOutlet weak var mSSKULABEL: UILabel!
        @IBOutlet weak var mSalesPersonLABEL: UILabel!
        @IBOutlet weak var mReserveHeaderLABEL: UILabel!
        
        @IBOutlet weak var mSubmitReserveBUTTON: UIButton!
        
        @IBOutlet weak var mRSKULABEL: UILabel!
        @IBOutlet weak var mRStockIdLABEL: UILabel!
        @IBOutlet weak var mRPriceLABEL: UILabel!
        @IBOutlet weak var mRTotalLABEL: UILabel!
        
        @IBOutlet weak var mRCancelBUTTON: UIButton!
        @IBOutlet weak var mRQtyLABEL: UILabel!
        
        @IBOutlet weak var mRRematkLABEL: UILabel!
        
        @IBOutlet weak var mRSubmitBUTTON: UIButton!
        
        @IBOutlet weak var mFilterLABEL: UILabel!
        @IBOutlet weak var mClearAllBUTTON: UIButton!
        
        @IBOutlet weak var mFItemLABEL: UILabel!
        @IBOutlet weak var mFSelectAllBUTTON: UIButton!
        
        @IBOutlet weak var mFCollectionLABEL: UILabel!
        
        @IBOutlet weak var mFMetalLABEL: UILabel!
        @IBOutlet weak var mFStoneSelectAllBUTTON: UIButton!
        
        @IBOutlet weak var mFCollectionSelectAllBUTTON: UIButton!
        @IBOutlet weak var mFMetalSelectAllBUTTON: UIButton!
        @IBOutlet weak var mFLocationSelectAllBUTTON: UIButton!
        @IBOutlet weak var mFSizeSelcetAllBUTTON: UIButton!
        @IBOutlet weak var mFStoneLABEL: UILabel!
        
        @IBOutlet weak var mFPriceRangeLABEL: UILabel!
        @IBOutlet weak var mFPriceLABEL: UILabel!
        @IBOutlet weak var mFSizeLABEL: UILabel!
        @IBOutlet weak var mFLocationLABEL: UILabel!
        
        var mTYPE = "I"
    
    var mOrderType = "";
    @IBOutlet weak var mHeadingLABEL: UILabel!
    
    @IBOutlet weak var mMetalLABEL: UILabel!
    @IBOutlet weak var mSizeLABEL: UILabel!
    @IBOutlet weak var mCollectionLABEL: UILabel!
    @IBOutlet weak var mStoneLABEL: UILabel!
    
    @IBOutlet weak var mProductSummaryLABEL: UILabel!
    @IBOutlet weak var mMaterialLABEL: UILabel!
    @IBOutlet weak var mPStoneLABEL: UILabel!
    @IBOutlet weak var mReferenceNoLABEL: UILabel!
    @IBOutlet weak var mCertificateLABEL: UILabel!
    
    var mProductIdForImage = ""
    var mSKUForImage = ""
    
    let mInventoryFetchLimit = 20
    var mInventorySkip = 0
    var mInventoryTotal = 0
    @IBOutlet weak var mShowMoreInventory: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        mSearchFIELD.placeholder = "Search by SKU / Stock Id".localizedString
        mHeadingLABEL.text = "Inventory".localizedString
        mCollectionLABEL.text = "Collection".localizedString
        mMetalLABEL.text = "Metal".localizedString
        mStoneLABEL.text = "Stone".localizedString
        mSizeLABEL.text = "Size".localizedString
        mProductSummaryLABEL.text = "Product Summary".localizedString
        mMaterialLABEL.text = "Material".localizedString
        mPStoneLABEL.text = "Stone".localizedString
        mReferenceNoLABEL.text = "Reference No.".localizedString
        mCertificateLABEL.text = "Certificate".localizedString
        
        mReserveButton.setTitle("ADD TO CART".localizedString, for: .normal)
        
        mMyInventoryTableView.isHidden = false
        mShowMoreInventory.isHidden = true
        mInventoryDetailsView.isHidden = false
        mShowHideButton.isSelected = false
        mShowHideSummaryIcon.image = UIImage(named: "bottomic")
        mProductSummaryView.isHidden = true
        mInventoryDetailsHeight.constant = 184.5
        
        mMyInventoryTableView.showsVerticalScrollIndicator = false
        
        mMyInventoryTableView.delegate = self
        mMyInventoryTableView.dataSource = self
        mMyInventoryTableView.reloadData()
        
        
        mGetInventoryData(key : "")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.delegate = self
        mStockName.isUserInteractionEnabled = true
        mStockName.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        tap1.delegate = self
        mInventoryImage.isUserInteractionEnabled = true
        mInventoryImage.addGestureRecognizer(tap1)
        
    }
    
    @objc
    func onTap(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        guard let home = storyBoard.instantiateViewController(withIdentifier: "SKUProductSummary") as? SKUProductSummary else { return }
        home.mOriginalData =  NSArray(array: mStoneDataArray)
        home.modalPresentationStyle = .automatic
        home.transitioningDelegate = self
        self.present(home,animated: true)
    }
    
    @objc
    func onTapImage(){
        if mProductIdForImage != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
            guard let mGlobalImageViewer = storyBoard.instantiateViewController(withIdentifier: "GlobalImageViewer") as? GlobalImageViewer else { return }
            mGlobalImageViewer.modalPresentationStyle = .overFullScreen
            mGlobalImageViewer.mProductId = mProductIdForImage
            mGlobalImageViewer.mSKUName = mSKUForImage
            mGlobalImageViewer.transitioningDelegate = self
            self.present(mGlobalImageViewer,animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addDoneButtonOnKeyboard()
        
    }

    @IBAction func mScanNow(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "invdata", bundle: nil)
        guard let home = storyBoard.instantiateViewController(withIdentifier: "SearchInventory") as? SearchInventory else { return }
        home.mType = "Inventory"
        home.mFrom = "2"
        self.navigationController?.pushViewController(home, animated:true)
        
    }
    
    @IBAction func mHome(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        mSearchFIELD.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        
        if mTYPE == "S" {
            
        }else {
            self.mGetInventoryData(key: mSearchFIELD.text ?? "")
        }
        mSearchFIELD.resignFirstResponder()
    }
    
    @IBAction func mOpenCertificateLink(_ sender: Any) {
    }
    
    @IBAction func mShowHideProductSummary(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            mProductSummaryView.isHidden = false
            mShowHideSummaryIcon.image = UIImage(named: "top_ic")
            mInventoryDetailsHeight.constant = 344
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }else{
            
            mShowHideSummaryIcon.image = UIImage(named: "bottomic")
            mInventoryDetailsHeight.constant = 184.5
            UIView.animate(withDuration: 1.0) {
                self.mProductSummaryView.isHidden = true
                
                self.view.layoutIfNeeded()
            }
            
        }
    }
        
    
    @IBAction func mSubmitReserveItems(_ sender: Any) {
        
        var mParams = [String : Any]()
        var url = ""
        if mOrderType == "reserve" {
            url = mAddCustomProduct
            mParams = ["product_id":mProductId, "customer_id":mCustomerId, "sales_person_id":"", "type":"inventory", "order_type":mOrderType]
        }else{
            url = mAddCustomProduct
            mParams = ["product_id":mProductId, "customer_id":mCustomerId, "sales_person_id":"", "type":"inventory", "order_type":mOrderType]
        }
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        CommonClass.showFullLoader(view: self.view)
        mGetData(url: url,headers: sGisHeaders, params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
                if "\(response.value(forKey: "code") ?? "")" == "200" {
                    self.dismiss(animated: true)
                    self.delegate?.mGetInventoryItems(items: self.mProductId)
                }
            }
        }
    }
    
    @IBAction func mSearch(_ sender: Any) {
        mFilterSearchView.isHidden =  false
    }
    
    @IBAction func mFilter(_ sender: Any) {
        
        view.endEditing(true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        guard let mFilters = storyBoard.instantiateViewController(withIdentifier: "CommonFilters") as? CommonFilters else { return }
        mFilters.delegate = self
        mFilters.mType = "inventory"
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
        
        
        if mTYPE == "S"{
            
        }else{
            mInventorySkip = 0
            mGetInventoryData(key: "")
            
        }
    }
    
    @IBAction func mShowmore(_ sender: Any) {
        
        self.mGetInventoryData(key : "")
    }
    
    
    @IBAction func mApplyFilter(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == mMyInventoryTableView {
            count =  mInventoryData.count
        }
        
        return count
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        var cell  = UITableViewCell()
        if tableView == mMyInventoryTableView {
            if let  cells = tableView.dequeueReusableCell(withIdentifier: "InventoryCell") as? InventoryCell {
                
                cells.mView.backgroundColor = (indexPath.row % 2 == 0) ? UIColor(named: "themeBackground") : #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
                
                if let mData = mInventoryData[indexPath.row] as? NSDictionary {
                    
                    if let isDesign = mData.value(forKey: "isDesign") as? Bool, isDesign {
                        cells.mDesignView.isHidden = false
                    }else{
                        cells.mDesignView.isHidden = true
                    }
                    
                    cells.mStockName.text = "\(mData.value(forKey: "SKU") ?? "--")"
                    
                    cells.mStockId.text = "\(mData.value(forKey: "stock_id") ?? "--")"
                    
                    cells.mQuantity.text = "\(mData.value(forKey: "po_QTY") ?? "--") Pcs"
                    cells.mAmount.text =  "\(mData.value(forKey: "price") ?? "--")"
                    
                    
                    let isEmptyInventory = mSelectedInventoryIndex.isEmpty
                    mHeight.constant = isEmptyInventory ? 0 : 90
                    mReserveButton.isHidden = isEmptyInventory
                    mReserveButtonView.isHidden = isEmptyInventory
                    
                    if !isEmptyInventory {
                        mReserveButtonView.layer.cornerRadius = 10
                        mReserveButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    }
                    
                    cells.mStockName.text = "\(mData.value(forKey: "SKU") ?? "--")"
                    cells.mStockId.text = "\(mData.value(forKey: "stock_id") ?? "--")"
                    cells.mQuantity.text = "\(mData.value(forKey: "po_QTY") ?? "--") Pcs"
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        cells.mAmount.text =  "\(mData.value(forKey: "price") ?? "--")"
                    }else{
                        cells.mAmount.text =  "\(mData.value(forKey: "price") ?? "--")"
                        
                    }
                    
                    cells.mStatusColor.textColor = .clear
                    if let statusType = mData.value(forKey: "status_type") as? String {
                        switch statusType {
                            case "stock":
                                cells.mStatusColor.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                            case "reserve":
                                cells.mStatusColor.backgroundColor = #colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1)
                            case "custom_order":
                                cells.mStatusColor.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                            case "repair_order":
                                cells.mStatusColor.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1)
                            case "warehouse":
                                cells.mStatusColor.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                            case "transit":
                                cells.mStatusColor.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                            default:
                                break
                        }
                    } else {
                        cells.mStatusColor.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                    }
                    
                    cells.mCheckIcon.image = mSelectedInventoryIndex.contains(indexPath) ? UIImage(named: "check_item") : UIImage(named: "uncheck_item")
                    
                    cells.layoutSubviews()
                    
                    if mIndexInv == indexPath.row {
                        if let statusType = mData.value(forKey: "status_type") as? String {
                            switch statusType {
                            case "stock":
                                let color = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                                self.setProductStatus(color: color, text: "Stock")
                            case "reserve":
                                let color = #colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1)
                                self.setProductStatus(color: color, text: "Reserved")
                            case "custom_order":
                                let color = #colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                                self.setProductStatus(color: color, text: "Reserved")
                            case "repair_order":
                                let color = #colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1)
                                self.setProductStatus(color: color, text: "Repair")
                            case "warehouse":
                                let color = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                                self.setProductStatus(color: color, text: "Warehouse")
                            case "transit":
                                let color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                                self.setProductStatus(color: color, text: "Transit")
                            default:
                                break
                            }
                        } else {
                            let color = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                            self.setProductStatus(color: color, text: "Stock")
                        }
                    }

                }
                cell = cells
            }
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == mCustomerSearchTableView {
            return 78
        }
        return 52
        
    }
    
    func setProductStatus(color: UIColor, text: String) {
        self.mProductStatus.textColor = color
        self.mStatusDot.backgroundColor = color
        self.mProductStatus.text = text
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView == mMyInventoryTableView {
            
            mIndexInv = indexPath.row
            
            if let mData = mInventoryData[indexPath.row] as? NSDictionary {
                self.mInventoryImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "main_image") ?? "")")
                
                self.mStockID.text = "\(mData.value(forKey: "stock_id") ?? "")"
                self.mStockName.text = "\(mData.value(forKey: "SKU") ?? "")"
                self.mMetaTag.text = "\(mData.value(forKey: "Matatag") ?? "")"
                self.mLocationName.text = "\(mData.value(forKey: "location_name") ?? "")"
                self.mMetalName.text = "\(mData.value(forKey: "metal_name") ?? "")"
                self.mStoneName.text = "\(mData.value(forKey: "stone_name") ?? "")"
                self.mSize.text = "\(mData.value(forKey: "size_name") ?? "")"
                self.mCollectionName.text = "\(mData.value(forKey: "collection_name") ?? "")"
                
                self.mMaterialName.text = "\(mData.value(forKey: "metal_name") ?? "--")"
                self.mStoneOne.text = "\(mData.value(forKey: "stone_name") ?? "--")"
                self.mReferenceName.text = "\(mData.value(forKey: "referenceNo") ?? "--")"
                self.mMaterialWeight.text = "\(mData.value(forKey: "NetWt") ?? "--")"
                self.mStoneOneWeight.text = "\(mData.value(forKey: "Cts") ?? "--")"
                self.mCertificateName.text = "\(mData.value(forKey: "certificate_type") ?? "--")"
                self.mCertificateNumber.text = "\(mData.value(forKey: "certificate_number") ?? "--")"
                
                if mIndexInv == indexPath.row {
                    if let statusType = mData.value(forKey: "status_type") as? String {
                        switch statusType {
                        case "stock":
                            let color = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                            self.setProductStatus(color: color, text: "Stock")
                        case "reserve":
                            let color = #colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1)
                            self.setProductStatus(color: color, text: "Reserved")
                        case "custom_order":
                            let color = #colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                            self.setProductStatus(color: color, text: "Reserved")
                        case "repair_order":
                            let color = #colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1)
                            self.setProductStatus(color: color, text: "Repair")
                        case "warehouse":
                            let color = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                            self.setProductStatus(color: color, text: "Warehouse")
                        case "transit":
                            let color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                            self.setProductStatus(color: color, text: "Transit")
                        default:
                            break
                        }
                    } else {
                        let color = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                        self.setProductStatus(color: color, text: "Stock")
                    }
                }
                
                if let statusType = mData.value(forKey: "status_type") as? String {
                    if ["stock", "reserve", "custom_order", "repair_order"].contains(statusType) {
                        
                        
                        if ["custom_order", "reserve", "repair_order"].contains(statusType) {
                            if let mInvData = mInventoryData[indexPath.row] as? NSDictionary {
                                
                                if let mCOData = mInvData.value(forKey: "pos") as? NSDictionary {
                                    if self.mCustomerId != mCOData.value(forKey: "customer_id") as? String {
                                        let msg = "This Item is reserved for \(mCOData.value(forKey: "customer_name") ?? "Other user")"
                                        CommonClass.showSnackBar(message: msg)
                                        return
                                    }
                                }
                            }
                        }
                        
                        if let poProductId = mData.value(forKey: "po_product_id") as? String {
                            if mProductId.contains(poProductId) {
                                mProductId = mProductId.filter {$0 != poProductId }
                            }else{
                                mProductId.append(poProductId)
                            }
                        }
                        
                        if self.mSelectedInventoryIndex.contains(indexPath) {
                            self.mSelectedInventoryIndex = mSelectedInventoryIndex.filter {$0 != indexPath }
                        }else{
                            self.mSelectedInventoryIndex.append(indexPath)
                        }
                    }
                    
                }
                
                self.mSKUForImage = "\(mData.value(forKey: "SKU") ?? "")"
                self.mProductIdForImage = "\(mData.value(forKey: "product_id") ?? "")"
                
                self.mStoneDataArray = NSMutableArray()
                self.mStoneDataArray.add(mData)
                self.mMyInventoryTableView.reloadData()
            }
        }
    }
       
    @IBAction func mOpenCustomer(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerSearch") as? CustomerSearch {
            self.navigationController?.pushViewController(home, animated:true)
        }
    }
    
    @IBAction func mReserve(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
        if let mInventoryPage = storyBoard.instantiateViewController(withIdentifier: "InventoryReservedItems") as? InventoryReservedItems {
            mInventoryPage.mType = "Inventory"
            self.navigationController?.pushViewController(mInventoryPage, animated:true)
        }
    }
    
    @IBAction func mPreview(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
        guard let mPrint = storyBoard.instantiateViewController(withIdentifier: "PrintItem") as? PrintItem else {return}
        mPrint.mTYPE = mTYPE
        self.navigationController?.pushViewController(mPrint, animated:true)
    }

    func mGetInventoryData(key : String){
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
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
        mFilterData.setValue(mStatusId, forKey: "status")
        
        let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
        
        let urlPath =  mGetInventory
        var params = ["location":mLocation,"filter": mFilterData ,"search":key ] as [String : Any]
        
        if key.trim().isEmpty {
            params["skip"] = mInventorySkip
            params["limit"] = mInventoryFetchLimit
        }
        
        mShowMoreInventory.isHidden = true
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post,parameters: params ,encoding: JSONEncoding.default, headers: sGisHeaders2).responseJSON
            { response in
                
                if(response.error != nil){
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                }else{
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
                        
                        self.mInventoryTotal = jsonResult.value(forKey: "total") as? Int ?? 0
                        
                        if let mData = jsonResult.value(forKey: "data") as? NSArray, mData.count > 0 {
                            
                            if let data = mData[0] as? NSDictionary {
                                self.mStoneDataArray = NSMutableArray()
                                self.mStoneDataArray.add(data)
                                self.mMaterialName.text = "\(data.value(forKey: "metal_name") ?? "--")"
                                self.mStoneOne.text = "\(data.value(forKey: "stone_name") ?? "--")"
                                self.mReferenceName.text = "\(data.value(forKey: "referenceNo") ?? "--")"
                                self.mMaterialWeight.text = "\(data.value(forKey: "NetWt") ?? "--")"
                                self.mStoneOneWeight.text = "\(data.value(forKey: "Cts") ?? "--")"
                                self.mCertificateName.text = "\(data.value(forKey: "certificate_type") ?? "--")"
                                self.mCertificateNumber.text = "\(data.value(forKey: "certificate_number") ?? "--")"
                                
                                if let statusType = data.value(forKey: "status_type") as? String {
                                    if statusType == "stock" {
                                        self.mProductStatus.textColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                                        self.mStatusDot.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                                        self.mProductStatus.text = "Stock"
                                    }else if statusType == "reserve" {
                                        
                                        self.mProductStatus.textColor = #colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1)
                                        self.mStatusDot.backgroundColor = #colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1)
                                        self.mProductStatus.text = "Reserved"
                                    }else if statusType == "custom_order" {
                                        
                                        self.mProductStatus.textColor = #colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                                        self.mStatusDot.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                                        self.mProductStatus.text = "Reserved"
                                    }else if statusType == "repair_order"  {
                                        self.mProductStatus.textColor = #colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1)
                                        self.mStatusDot.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1)
                                        self.mProductStatus.text = "Repair"
                                        
                                    }else if statusType == "warehouse" {
                                        
                                        self.mProductStatus.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                                        self.mStatusDot.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                                        self.mProductStatus.text = "WareHouse"
                                    }else if statusType == "transit" {
                                        
                                        self.mProductStatus.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                                        self.mStatusDot.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                                        self.mProductStatus.text = "Transit"
                                    }
                                    
                                } else {
                                    
                                    self.mProductStatus.textColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                                    self.mStatusDot.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                                    self.mProductStatus.text = "Stock"
                                }
                                
                                self.mInventoryImage.downlaodImageFromUrl(urlString: "\(data.value(forKey: "main_image") ?? "")")
                                
                                self.mStockID.text = "\(data.value(forKey: "stock_id") ?? "")"
                                self.mStockName.text = "\(data.value(forKey: "SKU") ?? "")"
                                self.mMetaTag.text = "\(data.value(forKey: "Matatag") ?? "")"
                                self.mLocationName.text = "\(data.value(forKey: "location_name") ?? "")"
                                self.mMetalName.text = "\(data.value(forKey: "metal_name") ?? "")"
                                self.mStoneName.text = "\(data.value(forKey: "stone_name") ?? "")"
                                self.mSize.text = "\(data.value(forKey: "size_name") ?? "")"
                                self.mCollectionName.text = "\(data.value(forKey: "collection_name") ?? "")"
                                
                                if !key.trim().isEmpty {
                                    self.mInventoryData.removeAllObjects()
                                }
                                if let skip = params["skip"] as? Int {
                                    if skip == 0 {
                                        self.mInventoryData.removeAllObjects()
                                    }
                                }
                                
                                let mDataAsAny = mData.compactMap { $0 as Any }
                                self.mInventoryData.addObjects(from: mDataAsAny)
                                self.mIndexInv = -1
                                
                                self.mSKUForImage = "\(data.value(forKey: "SKU") ?? "")"
                                self.mProductIdForImage = "\(data.value(forKey: "product_id") ?? "")"
                                
                                
                                self.mMyInventoryTableView.delegate = self
                                self.mMyInventoryTableView.dataSource = self
                                self.mMyInventoryTableView.reloadData()
                                
                                if key.trim().isEmpty {
                                    self.mInventorySkip += 20
                                }else{
                                    self.mInventorySkip = 0
                                }
                            }
                        }else{
                            if self.mInventorySkip == 0 {
                                self.mInventoryData.removeAllObjects()
                                self.mMyInventoryTableView.delegate = self
                                self.mMyInventoryTableView.dataSource = self
                                self.mMyInventoryTableView.reloadData()
                            }
                            self.mProductStatus.text = "--"
                            self.mStockID.text = "--"
                            self.mStockName.text = "--"
                            self.mMetaTag.text = "--"
                            self.mLocationName.text = "--"
                            self.mMetalName.text = "--"
                            self.mStoneName.text = "--"
                            self.mSize.text = "--"
                            self.mCollectionName.text = "--"
                        }
                        
                    }else{
                        self.mProductStatus.text = "--"
                        self.mStockID.text = "--"
                        self.mStockName.text = "--"
                        self.mMetaTag.text = "--"
                        self.mLocationName.text = "--"
                        self.mMetalName.text = "--"
                        self.mStoneName.text = "--"
                        self.mSize.text = "--"
                        self.mCollectionName.text = "--"
                        
                        if let error = jsonResult.value(forKey: "error") as? String{
                            if error == "Authorization has been expired" {
                                CommonClass.sessionExpired(isExpired: true, navigation:self.navigationController)
                            } else {
                                let code = jsonResult.value(forKey: "code") as? Int ?? -1
                                let msg = (code == -1) ? "OOP's something went wrong!" : "Error \(code): \(error)"
                                CommonClass.showSnackBar(message: msg)
                            }
                            
                        }
                    }
                    
                }
                
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.size.height
        
        // Check if you are near the bottom of the UICollectionView
        if contentOffsetY + scrollViewHeight >= contentHeight {
            // You have reached the bottom of the UICollectionView
            // Add your code here to perform any actions when scrolled to the bottom.
            
            if self.mInventorySkip < self.mInventoryTotal{
                mShowMoreInventory.isHidden = false
            }
        }else{
            mShowMoreInventory.isHidden = true
        }
    }
}
