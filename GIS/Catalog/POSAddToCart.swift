//
//  POSAddToCart.swift
//  GIS
//
//  Created by Apple Hawkscode on 12/04/21.
//

import UIKit
import DropDown
import Alamofire


class ProductImageCell :UICollectionViewCell {
    
    @IBOutlet weak var mProductImage: UIImageView!
    
}

class ProductLocationCell : UITableViewCell {
    
    @IBOutlet weak var mLocationFlag: UIImageView!

    @IBOutlet weak var mLocationName: UILabel!
    
    @IBOutlet weak var mLocationQty: UILabel!
}

var posTabBarInstance: POSTabBarController?

class POSAddToCart: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate ,UITableViewDelegate, UITableViewDataSource{
   
    
    @IBOutlet weak var mTotalCount: UILabel!
    @IBOutlet weak var mProductCollectionView: UICollectionView!
    @IBOutlet weak var mProductImage: UIImageView!
    
    @IBOutlet weak var mMetaTag: UITextView!
    @IBOutlet weak var mPageController: UIPageControl!
    @IBOutlet weak var mSize: UILabel!
    
    @IBOutlet weak var mSKUName: UITextView!
    @IBOutlet weak var mMetalView: UIView!
    
    @IBOutlet weak var mStoneView: UIView!
    @IBOutlet weak var mChooseMetalButt: UIButton!
    @IBOutlet weak var mChooseStoneButt: UIButton!
    @IBOutlet weak var mChooseSizeButt: UIButton!
    @IBOutlet weak var mProductName: UITextView!
    
    @IBOutlet weak var mReferenceNo: UILabel!
    @IBOutlet weak var mChooseShapeButton: UIButton!
    @IBOutlet weak var mChoosePointerButton: UIButton!
    @IBOutlet weak var mDescription: UITextView!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mMetalName: UITextField!
    @IBOutlet weak var mStoneName: UITextField!
    @IBOutlet weak var mSizeName: UITextField!
    
    @IBOutlet weak var mPointerView: UIView!
    @IBOutlet weak var mShapeView: UIView!
    @IBOutlet weak var mShapeName: UITextField!
    @IBOutlet weak var mPointerName: UITextField!
    var mStoneList = [String]()
    var mMetalList = [String]()
    
    var mStoneIdList = [String]()
    var mMetalIdList = [String]()
    var mChoiceData = NSArray()

    @IBOutlet weak var mHeart: UIImageView!
    var mSizeList = [String]()
    var mSizeIdList = [String]()
    var mShapeList = [String]()
    var mShapeIdList = [String]()
    var mPointerList = [String]()
    var mPointerdIdList = [String]()
    var mMetalId = ""
    var mStoneId = ""
    var mSizeId = ""
    var mShapeId = ""
    var mPointerId = ""
    var mData = NSDictionary()
    var mImageData = NSArray()
    var mProductId = ""
    var mSKU = ""
    var mPointerdPriceList = [String]()
    var mSelectedPointerPrice = ""

    var mType = ""
    var isWishListed = ""
    var mCustomerId = ""

   
    @IBOutlet weak var mHeading: UILabel!

    @IBOutlet weak var mPStoneWeight: UILabel!
    @IBOutlet weak var mPStoneName: UILabel!
    @IBOutlet weak var mPMetalWeight: UILabel!
    @IBOutlet weak var mPMetalName: UILabel!
    @IBOutlet weak var mAddToCartBUTTON: UIButton!
    @IBOutlet weak var mSizeView: UIView!
    @IBOutlet weak var mMetalLABEL: UILabel!
    
    @IBOutlet weak var mStoneLABEL: UILabel!
    
    @IBOutlet weak var mSizeLABEL: UILabel!
    
    @IBOutlet weak var mPointerLABEL: UILabel!
    @IBOutlet weak var mShapeLABEL: UILabel!
    
    @IBOutlet weak var mDescriptionLABEL: UILabel!
    
    @IBOutlet weak var mOrderNowButton: UIButton!
    @IBOutlet weak var mProductSummaryLABEL: UILabel!
    @IBOutlet weak var mMaterialLABEL: UILabel!
    @IBOutlet weak var mPStoneLABEL: UILabel!
    @IBOutlet weak var mReferenceNoLABEL: UILabel!
    @IBOutlet weak var mCertificateLABEL: UILabel!
    
    var mProductIdForImage = ""
    var mSKUForImage = ""
    
    var mVarientProductId = ""
    
    var mLocationData = NSArray()
    @IBOutlet weak var mLocationTable: UITableView!
    @IBOutlet weak var mLocationTableHeight: NSLayoutConstraint!
    
    
    override func viewWillAppear(_ animated: Bool) {

        
        
        mProductSummaryLABEL.text = "Product Summary".localizedString
        mMaterialLABEL.text = "Material".localizedString
        mPStoneLABEL.text = "Stone".localizedString
        mReferenceNoLABEL.text = "Reference No.".localizedString
        mCertificateLABEL.text = "Certificate".localizedString

        mDescriptionLABEL.text = "Description".localizedString
        mMetalLABEL.text = "Metal".localizedString
        mStoneLABEL.text = "Stone".localizedString
        mSizeLABEL.text = "Size".localizedString

        mStoneName.placeholder = "Select".localizedString
        mMetalName.placeholder = "Select".localizedString
        mSizeName.placeholder = "Select".localizedString
        mAddToCartBUTTON.setTitle("ADD TO CART".localizedString, for: .normal)
        mOrderNowButton.setTitle("ORDER".localizedString, for: .normal)
        
        if mCustomerId == "" {
            mHeart.isHidden = true
        }else{
            mHeart.isHidden = false
        }
        
        
    }
    
    var mStoreCurrency = "$"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        tap.delegate = self
        mProductImage.isUserInteractionEnabled = true
        mProductImage.addGestureRecognizer(tap)
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
               
        if let mStoreCurr = UserDefaults.standard.string(forKey: "currencySymbol") {
            self.mStoreCurrency = mStoreCurr
        }
        
        if mType == "catalog" {
            mHeading.text = "Catalog".localizedString
            mOrderNowButton.isHidden = true
        }else{
            mHeading.text = "Inventory".localizedString
        }
       
        let mLocation = UserDefaults.standard.string(forKey: "location")
 
        mProductId =  "\(mData.value(forKey: "product_id") ?? "")"
        mSKU =  "\(mData.value(forKey: "SKU") ?? "")"
        
        self.mSKUForImage = mSKU
        self.mProductIdForImage = mProductId
        
        mLocationTable.dataSource = self
        mLocationTable.delegate = self
        mLocationTableHeight.constant = 0
        
        isWishListed =  "\(mData.value(forKey: "isWishlist") ?? "0")"
    
        if isWishListed == "0"{
            mHeart.image = UIImage(systemName: "heart")

            mHeart.tintColor = UIColor(named: "themeExtraLightText1")
        }else{
            mHeart.image = UIImage(systemName: "heart.fill")

            mHeart.tintColor = UIColor(named: "themeLightRed")
        }
        mProductImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "main_image") ?? "")")

        
        let params:[String: Any] = ["product_id" : mProductId, "search":"",
                                    "sku":"\(mData.value(forKey: "SKU") ?? "")",
                                    "type":mType,
                                    "metal":[],
                                    "size":[],
                                    "stone":[],
                                    "location":mLocation ?? "",
                                    "shape":[],
                                    "pointer":[],
                                    "isWishlist":isWishListed]
        
        CommonClass.showFullLoader(view: view)
        mGetData(url: mGetCatalogDetails,headers: sGisHeaders,  params: params) { response , status in
            CommonClass.stopLoader()
            if status {
                
                guard let statusCode = response.value(forKey: "code") as? Int else {
                    CommonClass.showSnackBar(message: "Oops! Something went wrong.")
                    return
                }
                
                if statusCode == 200 {
                    print(response,"check1")
                    if let mData = response.value(forKey: "data") as? NSDictionary,
                       let mProductData = mData.value(forKey: "productdata_details") as? NSDictionary {
                        
                        self.mProductName.text = "\(mProductData.value(forKey: "name") ?? "--" )"
                        self.mMetaTag.text = "\(mProductData.value(forKey: "Matatag") ?? "--" )"
                        self.mSKUName.text = "\(mProductData.value(forKey: "SKU") ?? "--")"
                        self.mDescription.text = "\(mProductData.value(forKey: "description") ?? "--")"
                        self.mSizeName.text = "\(mProductData.value(forKey: "size_name") ?? "--" )"
                        self.mReferenceNo.text = "\(mProductData.value(forKey: "referenceNo") ?? "--" )"
                        
                        self.mMetalName.text = "\(mProductData.value(forKey: "metal_name") ?? "--" )"
                        self.mStoneName.text = "\(mProductData.value(forKey: "stone_name") ?? "--" )"
                        
                        
                        self.mShapeName.text = "\(mProductData.value(forKey: "shape_name") ?? "")"
                        self.mPointerName.text = "\(mProductData.value(forKey: "pointer_name") ?? "")"
                        
                        
                        self.mPMetalName.text = "\(mProductData.value(forKey: "metal_name") ?? "--" )"
                        self.mPMetalWeight.text = "\(mProductData.value(forKey: "GrossWt") ?? "--" )"
                        self.mPStoneName.text = "\(mProductData.value(forKey: "stone_name") ?? "--" )"
                        self.mPStoneWeight.text = "\(mProductData.value(forKey: "Cts") ?? "--" )"
                        self.mPrice.text =  self.mStoreCurrency + " \(mProductData.value(forKey: "price") ?? "0.00" )"
                        self.mSelectedPointerPrice = " \(mProductData.value(forKey: "price") ?? "0.00" )"
                        //BaseVarientId
                        self.mVarientProductId = "\(mData.value(forKey: "baseVariant_id") ?? "")"
                        
                        self.mProductImage.downlaodImageFromUrl(urlString: "\(mProductData.value(forKey: "images") ?? "")")
                        let sku = "\(mProductData.value(forKey: "SKU") ?? "")"
                        self.mSKUForImage = (!sku.isEmpty) ? sku : self.mSKUForImage
                        self.mProductIdForImage = (!self.mVarientProductId.isEmpty) ? self.mVarientProductId : self.mProductIdForImage
                        
                        if let mArr = mData.value(forKey:"Size_arr") as? NSArray, mArr.count > 0 {
                            
                            if "\(mProductData.value(forKey: "size_name") ?? "")" == "" {
                                if let data = mArr[0] as? NSDictionary {
                                    self.mSizeName.text = "\(data.value(forKey: "sizeName") ?? "")"
                                    self.mSizeId = "\(data.value(forKey: "id") ?? "")"
                                }
                            }
                            
                            for i in mArr {
                                if let sizeData = i as? NSDictionary {
                                    if let sizeName = sizeData.value(forKey:"sizeName") as? String,
                                       let sizeId = sizeData.value(forKey:"id") as? String{
                                        self.mSizeList.append(sizeName)
                                        self.mSizeIdList.append(sizeId)
                                        
                                        if "\(mProductData.value(forKey: "size_name") ?? "")" == sizeName {
                                            self.mSizeId = sizeId
                                            self.mSizeName.text = sizeName
                                        }
                                    }
                                }
                            }
                            
                        }else{
                            self.mSizeView.isHidden = true
                        }
                        
                        if let metalArr = mData.value(forKey:"metalArr") as? NSArray,
                           metalArr.count > 0 {
                            if let productMetalName = mProductData.value(forKey: "metal_name") as? String,
                               productMetalName.isEmpty,
                               let data = metalArr[0] as? NSDictionary {
                                self.mMetalName.text = "\(data.value(forKey: "metalName") ?? "")"
                                self.mMetalId = "\(data.value(forKey: "id") ?? "")"
                            }
                            
                            for i in metalArr {
                                if let data = i as? NSDictionary,
                                   let metalName = data.value(forKey: "metalName") as? String,
                                   let metalId = data.value(forKey: "id") as? String {
                                    
                                    self.mMetalList.append("\(metalName) ")
                                    self.mMetalIdList.append("\(metalId)")
                                    
                                    if let productMetalName = mProductData.value(forKey: "metal_name") as? String,
                                       productMetalName == metalName {
                                        self.mMetalId = metalId
                                        self.mMetalName.text = metalName
                                    }
                                }
                            }
                            
                        } else {
                            self.mMetalView.isHidden = true
                        }

                        if let mArr = mData.value(forKey:"shapeArr") as? NSArray,
                           mArr.count > 0{
                            
                            if "\(mProductData.value(forKey: "shape_name") ?? "")" == "" {
                                if let data = mArr[0] as? NSDictionary {
                                    self.mShapeName.text = "\(data.value(forKey: "shapeName") ?? "")"
                                    self.mShapeId = "\(data.value(forKey: "id") ?? "")"
                                }
                            }
                            
                            for i in mArr {
                                if let data = i as? NSDictionary {
                                    if let shapeName = data.value(forKey:"shapeName") as? String,
                                       let shapeId = data.value(forKey:"id") as? String{
                                        self.mShapeList.append(shapeName)
                                        self.mShapeIdList.append(shapeId)
                                        
                                        if "\(mProductData.value(forKey: "shape_name") ?? "")" == shapeName {
                                            self.mShapeId = shapeId
                                            self.mShapeName.text = shapeName
                                        }
                                    }
                                }
                            }
                            
                        }else{
                            self.mShapeView.isHidden = true
                        }
                        
                        if let stoneArr = mData.value(forKey:"stoneArr") as? NSArray ,
                           stoneArr.count > 0 {
                            if let productStoneName = mProductData.value(forKey: "stone_name") as? String,
                               productStoneName.isEmpty,
                               let data = stoneArr[0] as? NSDictionary {
                                self.mStoneName.text = "\(data.value(forKey: "stoneName") ?? "")"
                                self.mStoneId = "\(data.value(forKey: "id") ?? "")"
                            }
                            
                            for i in stoneArr {
                                if let data = i as? NSDictionary,
                                   let stName = data.value(forKey:"stoneName") as? String {
                                    self.mStoneList.append("\(stName) ")
                                    
                                    if let stId = data.value(forKey:"id") as? String {
                                        self.mStoneIdList.append("\(stId)")
                                    }
                                    
                                    if let productStoneName = mProductData.value(forKey: "stone_name") as? String,
                                       productStoneName == stName {
                                        self.mStoneId = "\(data.value(forKey: "id") ?? "")"
                                    }
                                }
                            }
                            
                        } else {
                            self.mStoneView.isHidden = true
                        }
                        if let locationArray = mData.value(forKey: "location_arr") as? [[String: Any]] {

                            var totalQty = 0
                            var locArr: [[String: Any]] = []

                            for item in locationArray {
                                if let qty = item["qty"] as? Int {
                                    totalQty += qty
                                    locArr.append(item)
                                }
                            }

                            self.mLocationData = locArr as NSArray
                            self.mTotalCount.text = "(\(totalQty))"

                            let height = locArr.count * 40
                            self.mLocationTableHeight.constant = CGFloat(height)
                            self.mLocationTable.reloadData()

                        } else {
                            self.mTotalCount.text = "(0)"
                        }

                        // if let locationArray = mData.value(forKey: "location_arr") as? NSArray {

                        //     if let mTotal = mData.value(forKey: "totallocation_qty") as? Int {
                        //         self.mTotalCount.text = "(\(mTotal))"
                        //     }else{
                        //         self.mTotalCount.text = "(0)"
                        //     }
                        //     let locArr = NSMutableArray()
                        //     for i in 0..<locationArray.count {
                        //         if let mData = locationArray[i] as? NSDictionary , mData.value(forKey: "qty") as? Int != 0 {
                                    
                        //             locArr.add(mData)
                        //          }
                        //     }
                            
                        //     self.mLocationData = locArr as NSArray
                        //     let height = self.mLocationData.count * 40
                        //     self.mLocationTableHeight.constant = CGFloat(integerLiteral: height)
                        //     self.mLocationTable.reloadData()
                            
                        // }else{
                        //     self.mTotalCount.text = "(0)"
                        // }
                        
                        if let mArr = mData.value(forKey:"choice_data") as? NSArray,
                           mArr.count > 0 {
                            for i in mArr {
                                if let data = i as? NSDictionary {
                                    self.mShapeList.append("\(data.value(forKey:"name") ?? "") ")
                                    self.mShapeIdList.append("\(data.value(forKey:"id") ?? "")")
                                    
                                    if "\(mProductData.value(forKey: "shape_name") ?? "")" == "\(data.value(forKey: "name") ?? "")" {
                                        self.mShapeId = "\(data.value(forKey: "id") ?? "")"
                                        
                                        if let mArr = mData.value(forKey:"data") as? NSArray,
                                           mArr.count > 0 {
                                            
                                            self.mPointerList = [String]()
                                            self.mPointerdPriceList = [String]()
                                            
                                            if "\(mProductData.value(forKey: "pointer_name") ?? "")" == "" {
                                                if let data = mArr[0] as? NSDictionary{
                                                    self.mPointerName.text = "\(data.value(forKey: "pointer") ?? "")"
                                                    self.mPointerId = "\(data.value(forKey: "pointer") ?? "")"
                                                    self.mPrice.text =  self.mStoreCurrency +  " \(data.value(forKey: "price") ?? "0.00")"
                                                }
                                            }
                                            
                                            for i in mArr {
                                                if let data = i as? NSDictionary {
                                                    
                                                    self.mPointerList.append("\(data.value(forKey:"pointer") ?? "0.0")")
                                                    self.mPointerdPriceList.append("\(data.value(forKey:"price") ?? "0.00" )")
                                                    
                                                    if "\(mProductData.value(forKey: "pointer_name") ?? "")" == "\(data.value(forKey: "pointer") ?? "")" {
                                                        self.mPointerId = "\(data.value(forKey: "pointer") ?? "")"
                                                        self.mPointerName.text = "\(data.value(forKey: "pointer") ?? "")"
                                                        self.mPrice.text =  self.mStoreCurrency +  " \(data.value(forKey: "price") ?? "0.00")"
                                                    }
                                                }
                                            }
                                            self.mPointerView.isHidden = false
                                        }else{
                                            self.mPointerView.isHidden = true
                                        }
                                        
                                    }
                                    
                                    
                                    if "\(mProductData.value(forKey: "shape_name") ?? "")" == "" {
                                        
                                        self.mPointerList = [String]()
                                        self.mPointerdPriceList = [String]()
                                        
                                        self.mShapeName.text = "\(data.value(forKey: "name") ?? "")"
                                        self.mShapeId = "\(data.value(forKey: "id") ?? "")"
                                        
                                        if let mData = mArr[0] as? NSDictionary {
                                            if let mArr = mData.value(forKey: "data") as? NSArray,
                                               mArr.count > 0 {
                                                if let data = mArr[0] as? NSDictionary {
                                                    self.mPointerName.text = "\(data.value(forKey: "pointer") ?? "0.0")"
                                                    self.mPointerId = "\(data.value(forKey: "pointer") ?? "0.0")"
                                                    self.mPrice.text =  self.mStoreCurrency +  " \(data.value(forKey: "price") ?? "0.00")"
                                                }
                                                
                                                for data in mArr {
                                                    if let mData = data as? NSDictionary {
                                                        self.mPointerList.append("\(mData.value(forKey: "pointer") ?? "0.0")")
                                                        self.mPointerdPriceList.append("\(mData.value(forKey: "price") ?? "0.00")")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            self.mPointerId = ""
                            self.mShapeId = ""
                            self.mShapeView.isHidden = true
                            self.mPointerView.isHidden = true
                            
                        }
                        
                    } else{
                        CommonClass.showSnackBar(message: "Oops! Something went wrong.")
                    }
                    
                }else {
                    if let error = response.value(forKey: "error") as? String{
                        if error == "Authorization has been expired" {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        } else {
                            CommonClass.showSnackBar(message: "Error \(statusCode): \(error)")
                        }
                    }
                    if let message = response.value(forKey: "message") as? String {
                        CommonClass.showSnackBar(message: "Error \(statusCode): \(message)")
                    }
                }
            }
            
        }
            
    }
    
    @IBAction func mViewImage(_ sender: Any) {
        mOpenGlobalImageViewer()
    }
    
    @objc func onTapImage(){
        mOpenGlobalImageViewer()
    }
    
    func mOpenGlobalImageViewer(){
        if mProductIdForImage != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
            if let mGlobalImageViewer = storyBoard.instantiateViewController(withIdentifier: "GlobalImageViewer") as? GlobalImageViewer {
                mGlobalImageViewer.modalPresentationStyle = .overFullScreen
                mGlobalImageViewer.mProductId = mProductIdForImage
                mGlobalImageViewer.mSKUName = mSKUForImage
                mGlobalImageViewer.transitioningDelegate = self
                self.present(mGlobalImageViewer,animated: false)
            }
        }
    }
 
    //Show hide views
    @IBOutlet weak var mDiscriptionDropDownImage: UIImageView!
    @IBOutlet weak var mDiscriptionDetailsView: UIView!
    @IBAction func mShowHideDiscription(_ sender: Any) {
        UIView.transition(with: mDiscriptionDetailsView, duration: 0.1, options: .transitionCrossDissolve , animations: {
            self.mDiscriptionDetailsView.isHidden = !self.mDiscriptionDetailsView.isHidden
            self.mDiscriptionDropDownImage.transform = self.mDiscriptionDetailsView.isHidden ? CGAffineTransform.init(rotationAngle: -CGFloat.pi/2) : .identity
        })
    }
    
    @IBOutlet weak var mSummaryDropDownImage: UIImageView!
    @IBOutlet weak var mProductSummeryView: UIView!
    @IBAction func mShowHideSummery(_ sender: Any) {
        UIView.transition(with: mProductSummeryView, duration: 0.1, options: .transitionCrossDissolve , animations: {
            self.mProductSummeryView.isHidden = !self.mProductSummeryView.isHidden
            self.mSummaryDropDownImage.transform = self.mProductSummeryView.isHidden ? CGAffineTransform.init(rotationAngle: -CGFloat.pi/2) : .identity
        })
    }
    
    // Back Naviagation
    @IBAction func mBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated:true)
    }
 
    
    
    @IBAction func mLikeDislike(_ sender: Any) {
        
        
        if mCustomerId == "" {
            return
        }
        
        CommonClass.showFullLoader(view: self.view)
        let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
        let params = ["search":mSKU,"location":mLocation,"customer_id":mCustomerId, "isWishlist":isWishListed,"SKU":mSKU, "type":mType, "product_id": mProductId]
        
        mGetData(url: mAddToFav,headers: sGisHeaders,  params: params) { response , status in
            CommonClass.stopLoader()
            if status {
                if "\(response.value(forKey: "code") ?? "")" == "200" {
                    
                    if let mData = response.value(forKey: "data") as? NSDictionary {
                        
                        self.isWishListed = "\(mData.value(forKey: "isWishlist") ?? "0")"
                        self.mHeart.image = UIImage(systemName: self.isWishListed == "0" ? "heart" : "heart.fill")
                        self.mHeart.tintColor = UIColor(named: self.isWishListed == "0" ? "themeExtraLightText1" : "themeLightRed")
                    }
                    
                }
                
            }
        }
        
    }
    @IBAction func mAddSize(_ sender: Any) {
        let count = mSize.text ?? "0"
        let mTotal =  Int(count) ?? 0 + 1
      
        mSize.text = "\(mTotal)"
        
    }
    @IBAction func mSubtractSize(_ sender: Any) {
        
        let count = mSize.text ?? "0"
       
        if(count != "0"){
            
        
            let mTotal = Int(count) ?? 0 - 1
          
            mSize.text = "\(mTotal)"
            
        }
    }
    
    
    
    @IBAction func mOrderNow(_ sender: UIButton) {
        sender.showAnimation{
            
            CommonClass.showFullLoader(view: self.view)
            
            
            let mParams = ["product_id":[self.mProductId], "customer_id":self.mCustomerId, "sales_person_id":"", "type":self.mType, "order_type":"custom_order"] as [String : Any]
            
            0
            mGetData(url: mAddCustomProduct,headers: sGisHeaders,  params: mParams) { response , status in
                CommonClass.stopLoader()
                if status {
                    guard let statusCode = response.value(forKey: "code") as? Int else {
                        CommonClass.showSnackBar(message: "Oops! Something went wrong.")
                        return
                    }
                    
                    if statusCode == 200 {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "customOrder", bundle: nil)
                        if let mCustomCart = storyBoard.instantiateViewController(withIdentifier: "CustomCart") as? CustomCart {
                            self.navigationController?.pushViewController(mCustomCart, animated:true)
                        }
                    }else{
                        if let error = response.value(forKey: "error") as? String{
                            if error == "Authorization has been expired" {
                                CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                            } else {
                                CommonClass.showSnackBar(message: "Error \(statusCode): \(error)")
                            }
                        }
                        if let message = response.value(forKey: "message") as? String {
                            CommonClass.showSnackBar(message: "Error \(statusCode): \(message)")
                        }
                    }
                }
            }
        }
    }

    @IBAction func mAddToCart(_ sender: UIButton) {
        
        sender.showAnimation{
            
            if self.mType == "inventory" {
                
                let mParams = ["product_id":[self.mProductId], "customer_id":self.mCustomerId, "sales_person_id":"", "type":self.mType , "order_type": "pos_order"] as [String : Any]
                
                mGetData(url: mAddCustomProduct,headers: sGisHeaders,  params: mParams) { response , status in
                    CommonClass.stopLoader()
                    if status {
                        guard let statusCode = response.value(forKey: "code") as? Int else {
                            CommonClass.showSnackBar(message: "Oops! Something went wrong.")
                            return
                        }
                        
                        if statusCode == 200 {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "posBoard", bundle: nil)
                            if let viewControllers = self.navigationController?.viewControllers{
                                if !viewControllers.contains(where: {return $0 is POSTabBarController}){
                                    posTabBarInstance = nil
                                }
                            }
                            if let mHomePage = posTabBarInstance {
                                mHomePage.selectedIndex = 2
                                
                                // Mark-: Comment for due to crash issue ....
                                
//                                if let navigationController = self.navigationController {
//                                    var controllers = navigationController.viewControllers
//                                    controllers.removeLast()
//                                    controllers.append(mHomePage)
//                                    navigationController.setViewControllers(controllers, animated: true)
//                                }
                                
                                if let mHomePage  = storyBoard.instantiateViewController(withIdentifier: "POSTabBarController") as? POSTabBarController {
                                    mHomePage.mIndex = 2
                                    if let navigationController = self.navigationController {
                                        var controllers = navigationController.viewControllers
                                        controllers.removeLast()
                                        controllers.append(mHomePage)
                                        navigationController.setViewControllers(controllers, animated: true)
                                    }
                                }
                                
                            }else{
                                print("checkejdnnfjn")
                                if let mHomePage  = storyBoard.instantiateViewController(withIdentifier: "POSTabBarController") as? POSTabBarController {
                                    mHomePage.mIndex = 2
                                    if let navigationController = self.navigationController {
                                        var controllers = navigationController.viewControllers
                                        controllers.removeLast()
                                        controllers.append(mHomePage)
                                        navigationController.setViewControllers(controllers, animated: true)
                                    }
                                }
                            }
                            
                        }else{
                            if let error = response.value(forKey: "error") as? String{
                                if error == "Authorization has been expired" {
                                    CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                                } else {
                                    CommonClass.showSnackBar(message: "Error \(statusCode): \(error)")
                                }
                            }
                            if let message = response.value(forKey: "message") as? String {
                                CommonClass.showSnackBar(message: "Error \(statusCode): \(message)")
                            }
                        }
                    }
                }
            }else{
                CommonClass.showFullLoader(view: self.view)
                
                
                let mParams = ["product_id":[self.mVarientProductId], "customer_id":self.mCustomerId, "sales_person_id":"", "type":self.mType, "order_type":"custom_order", "pointerPrice":self.mSelectedPointerPrice, "pointer":self.mPointerId] as [String : Any]
                
                mGetData(url: mAddCustomProduct,headers: sGisHeaders,  params: mParams) { response , status in
                    CommonClass.stopLoader()
                    if status {
                        guard let statusCode = response.value(forKey: "code") as? Int else {
                            CommonClass.showSnackBar(message: "Oops! Something went wrong.")
                            return
                        }
                        
                        if statusCode == 200 {
                            
                            let storyBoard = UIStoryboard(name: "customOrder", bundle: nil)
                            
                            if let existingCartIndex = self.navigationController?.viewControllers.firstIndex(where: { $0 is CustomCart }) {
                                // The CustomCart is already in the navigation stack
                                if let cart = self.navigationController?.viewControllers[existingCartIndex] {
                                    self.navigationController?.popToViewController(cart, animated: true)
                                }
                            } else {
                                // The CustomCart is not in the navigation stack, push it
                                if let mCustomCart = storyBoard.instantiateViewController(withIdentifier: "CustomCart") as? CustomCart{
                                    self.navigationController?.pushViewController(mCustomCart, animated: true)
                                }
                            }
                            
                        }else{
                            if let error = response.value(forKey: "error") as? String{
                                if error == "Authorization has been expired" {
                                    CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                                } else {
                                    CommonClass.showSnackBar(message: "Error \(statusCode): \(error)")
                                }
                            }
                            if let message = response.value(forKey: "message") as? String {
                                CommonClass.showSnackBar(message: "Error \(statusCode): \(message)")
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mLocationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cells = tableView.dequeueReusableCell(withIdentifier: "ProductLocationCell") as? ProductLocationCell else {
            return UITableViewCell()
        }
        
        if let mData = self.mLocationData[indexPath.row] as? NSDictionary{
            cells.mLocationQty.text = "\(mData.value(forKey: "qty") ?? "--")"
            
            cells.mLocationName.text = "\(mData.value(forKey: "location") ?? "--")"
            
        }else{
            cells.isHidden = true
        }
        
        return cells
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell",for:indexPath) as? ProductImageCell else{
            return UICollectionViewCell()
        }
        
        if let mDatas = mImageData[indexPath.row] as? NSDictionary {
            cells.mProductImage.downlaodImageFromUrl(urlString: "\(mDatas.value(forKey: "image") ?? "")")
        }
        return cells
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell",for:indexPath) as? ProductImageCell,
           let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            
            return CGSize(width: view.frame.width, height: 220)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / width
        let roundedIndex = round(index)
        self.mPageController.currentPage = Int(roundedIndex)

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.mPageController.currentPage = Int(scrollView.contentOffset.x)
            / Int (scrollView.frame.width)
        
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.mPageController.currentPage = Int(scrollView.contentOffset.x) /  Int(scrollView.frame.width
        )
    }
    
    
    
    @IBAction func mChooseMetal(_ sender: Any) {
        
        let dropdown = DropDown()
        dropdown.anchorView = self.mChooseMetalButt
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: self.mChooseMetalButt.frame.size.height)
        dropdown.width = 200
        dropdown.dataSource = mMetalList
        dropdown.selectionAction = {
            [unowned self](index:Int, item: String) in
            self.mMetalName.text  = item
            if self.mMetalId != self.mMetalIdList[index] {
                
                self.mMetalId = self.mMetalIdList[index]
                self.mUpdateData()
                
            }
        }
        dropdown.show()
        
    }

    @IBAction func mChooseStone(_ sender: Any) {
        let dropdown = DropDown()
        dropdown.anchorView = self.mChooseStoneButt
        dropdown.direction = .any
        dropdown.bottomOffset = CGPoint(x: 0, y: self.mChooseStoneButt.frame.size.height)
        dropdown.width = 200
        dropdown.dataSource = mStoneList
        dropdown.selectionAction = {
            [unowned self](index:Int, item: String) in
            self.mStoneName.text  = item
            if self.mStoneId != self.mStoneIdList[index] {
                
                self.mStoneId =  self.mStoneIdList[index]
                self.mUpdateData()
                
            }
        }
        dropdown.show()
        
    }

    @IBAction func mChooseSize(_ sender: Any) {
        
        let dropdown = DropDown()
        dropdown.anchorView = self.mChooseSizeButt
        dropdown.direction = .any
        dropdown.bottomOffset = CGPoint(x: 0, y: self.mChooseSizeButt.frame.size.height)
        dropdown.width = 200
        dropdown.dataSource = mSizeList
        dropdown.selectionAction = {
            [unowned self](index:Int, item: String) in
            self.mSizeName.text  = item
            if self.mSizeId != self.mSizeIdList[index] {
                
                self.mSizeId =  self.mSizeIdList[index]
                self.mUpdateData()
                
            }
        }
        dropdown.show()
        
    }
    
    @IBAction func mChooseShape(_ sender: Any) {
        
        let dropdown = DropDown()
        dropdown.anchorView = self.mChooseShapeButton
        dropdown.direction = .any
        dropdown.bottomOffset = CGPoint(x: 0, y: self.mChooseShapeButton.frame.size.height)
        dropdown.width = 220
        dropdown.dataSource = mShapeList
        dropdown.selectionAction = {
            [unowned self](index:Int, item: String) in
            self.mShapeName.text  = item
            
            self.mShapeId =  self.mShapeIdList[index]
           
            for data in self.mChoiceData {
                if let mData = data as? NSDictionary {
                    if mData.value(forKey: "id") as? String ?? "" == self.mShapeId {
                        if let mArr = mData.value(forKey: "data") as? NSArray,
                           mArr.count > 0 {
                            self.mPointerList = [String]()
                            self.mPointerdPriceList = [String]()

                            if let data = mArr[0] as? NSDictionary {
                                self.mPointerName.text = "\(data.value(forKey: "pointer") ?? "0.0")"
                                self.mPointerId = "\(data.value(forKey: "pointer") ?? "0.0")"
                                self.mPrice.text =   self.mStoreCurrency + " \(data.value(forKey: "price") ?? "0.00")"
                            }
                            
                            for data in mArr {
                                if let mData = data as? NSDictionary {
                                    self.mPointerList.append(mData.value(forKey: "pointer") as? String ?? "0.0")
                                    self.mPointerdPriceList.append(mData.value(forKey: "price") as? String ?? "0.00")
                                }
                            }

                        }
                    }
                }
            }
            
        }
        dropdown.show()
        
    }

    @IBAction func mChoosePointer(_ sender: Any) {
        
        let dropdown = DropDown()
        dropdown.anchorView = self.mChoosePointerButton
        dropdown.direction = .any
        dropdown.bottomOffset = CGPoint(x: 0, y: self.mChoosePointerButton.frame.size.height)
        dropdown.width = 200
        dropdown.dataSource = mPointerList
        dropdown.selectionAction = {
            [unowned self](index:Int, item: String) in
            self.mPointerName.text  = item
            
            self.mPointerId =  self.mPointerList[index]
            self.mPrice.text =   self.mStoreCurrency + " " + self.mPointerdPriceList[index]
            self.mSelectedPointerPrice = self.mPointerdPriceList[index]
        }
        dropdown.show()
        
    }
    
    
    func mUpdateData(){
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        let mLocation = UserDefaults.standard.string(forKey: "location")
     

        if Reachability.isConnectedToNetwork() == true {
            let params:[String: Any] = ["product_id" : mProductId,"type":mType,"Metal":mMetalId,"Size":mSizeId, "Stone":mStoneId]
            
            CommonClass.showFullLoader(view: self.view)
            
            
            
            mGetData(url: mGetMixAndMatchCatalogDetails,headers: sGisHeaders,  params: params) { response , status in
                CommonClass.stopLoader()
                if status {
                    guard let statusCode = response.value(forKey: "code") as? Int else {
                        CommonClass.showSnackBar(message: "Oops! Something went wrong.")
                        return
                    }
                    
                if statusCode == 200 {
                    if let mData = response.value(forKey: "data") as? NSDictionary,
                       let mProductData = response.value(forKey: "data") as? NSDictionary{
                        
                        
                        //Varient Product ID
                        self.mVarientProductId = "\(mProductData.value(forKey: "_id") ?? "--" )"
                        
                        self.mProductName.text = "\(mProductData.value(forKey: "name") ?? "--" )"
                        self.mMetaTag.text = "\(mProductData.value(forKey: "Matatag") ?? "--" )"

                        self.mSKUName.text = "\(mProductData.value(forKey: "SKU") ?? "--")"
                        self.mDescription.text = "\(mProductData.value(forKey: "Description") ?? "--")"
                        self.mSizeName.text = "\(mProductData.value(forKey: "size_name") ?? "--" )"
                        self.mReferenceNo.text = "\(mProductData.value(forKey: "referenceNo") ?? "--" )"

                        self.mMetalName.text = "\(mProductData.value(forKey: "metal_name") ?? "--" )"
                        self.mStoneName.text = "\(mProductData.value(forKey: "stone_name") ?? "--" )"
                        
                    
                        self.mShapeName.text = "\(mProductData.value(forKey: "shape_name") ?? "")"
                        self.mPointerName.text = "\(mProductData.value(forKey: "pointer_name") ?? "")"
                        self.mReferenceNo.text = "\(mProductData.value(forKey: "SKU") ?? "--")"
                        self.mPMetalName.text = "\(mProductData.value(forKey: "metal_name") ?? "--" )"
                        self.mPMetalWeight.text = "\(mProductData.value(forKey: "GrossWt") ?? "--" )"
                        self.mPStoneName.text = "\(mProductData.value(forKey: "stone_name") ?? "--" )"
                        self.mPStoneWeight.text = "\(mProductData.value(forKey: "diamondWt") ?? "--" )"
                        self.mPrice.text =   self.mStoreCurrency + " \(mProductData.value(forKey: "price") ?? "0.00" )"
                        self.mSelectedPointerPrice = " \(mProductData.value(forKey: "price") ?? "0.00" )"
                        
                        self.mProductImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "main_image") ?? "")")
                        let sku = "\(mProductData.value(forKey: "SKU") ?? "")"
                        self.mSKUForImage = (!sku.isEmpty) ? sku : self.mSKUForImage
                        self.mProductIdForImage = (!self.mVarientProductId.isEmpty) ? self.mVarientProductId : self.mProductIdForImage
                        
                        self.mPointerList = [String]()
                        self.mPointerdPriceList = [String]()
                        
                        self.mShapeList = [String]()
                        self.mShapeIdList = [String]()
                        
                        if let mStatistic = mData.value(forKey: "inventory_statistics") as? NSDictionary {

                            if let mTotal = mStatistic.value(forKey: "total") as? Int {
                                self.mTotalCount.text = "(\(mTotal))"
                            }else{
                                self.mTotalCount.text = "(0)"
                            }
                            if let mLocArr = mStatistic.value(forKey: "response") as? NSArray {
                                
                                let locArr = NSMutableArray()
                                for i in 0..<mLocArr.count {
                                    if let mData = mLocArr[i] as? NSDictionary , mData.value(forKey: "qty") as? Int != 0 {
                                        locArr.add(mData)
                                    }
                                }
                                
                                self.mLocationData = locArr as NSArray
                                
                                let height = self.mLocationData.count * 40
                                self.mLocationTableHeight.constant = CGFloat(integerLiteral: height)
                                self.mLocationTable.reloadData()
                            }else{
                                self.mTotalCount.text = "(0)"
                            }
                            
                        }else{
                            self.mTotalCount.text = "(0)"
                        }
                        
                        if let mArr = mData.value(forKey:"stone_value") as? NSArray {
                            
                            var isTrue = false
                            if mArr.count > 0 {
                                for i in mArr {
                                    if let data = i as? NSDictionary {

                                        if self.mStoneId == "\(data.value(forKey: "_id") ?? "")" {
                                            isTrue = true
                                            self.mStoneName.text = "\(data.value(forKey: "name") ?? "")"
                                            self.mPStoneName.text = "\(data.value(forKey: "name") ?? "")"
                                            self.mStoneId = "\(data.value(forKey: "_id") ?? "")"
                                        }
                                    }
                                }
                                
                                if !isTrue {
                                    if let datas = mArr[0] as? NSDictionary {
                                        self.mStoneName.text = "\(datas.value(forKey: "name") ?? "")"
                                        self.mPStoneName.text = "\(datas.value(forKey: "name") ?? "")"
                                        self.mStoneId = "\(datas.value(forKey: "_id") ?? "")"
                                    }
                                }
                            }else{
                                self.mStoneId = ""
                                self.mStoneView.isHidden = true
                            }
                        }
                        
                        if let mArr  = mData.value(forKey: "choice_data") as? NSArray {
                            if mArr.count > 0 {
                                self.mChoiceData =  mArr
                            }
                        }
                        
                        if let mArr = mData.value(forKey:"size_value") as? NSArray {
                            
                            if mArr.count > 0 {
                                
                                var isTrue = false
                                for i in mArr {
                                    if let sizeData = i as? NSDictionary {
                                        
                                        if self.mSizeId == "\(sizeData.value(forKey:"_id") ?? "")" {
                                            isTrue = true
                                            self.mSizeName.text = "\(sizeData.value(forKey: "name") ?? "")"
                                            self.mSizeId = "\(sizeData.value(forKey: "_id") ?? "")"
                                        }
                                    }
                                }

                                if !isTrue {
                                    if let datas = mArr[0] as? NSDictionary {
                                        self.mSizeName.text = "\(datas.value(forKey: "name") ?? "")"
                                        self.mSizeId = "\(datas.value(forKey: "_id") ?? "")"
                                    }
                                }
                                
                            }else{
                                self.mSizeId = ""
                                self.mSizeView.isHidden = true
                            }
                        }
                        
                        if let mArr = mData.value(forKey:"metal_value") as? NSArray {
                            if mArr.count > 0 {
                                var isTrue = false
                                
                                for i in mArr {
                                    if let data = i as? NSDictionary {
                                        
                                        if self.mMetalId == "\(data.value(forKey:"_id") ?? "")" {
                                            isTrue = true
                                            self.mMetalName.text = "\(data.value(forKey: "name") ?? "")"
                                            self.mPMetalName.text = "\(data.value(forKey: "name") ?? "")"
                                            self.mMetalId = "\(data.value(forKey: "_id") ?? "")"
                                        }
                                    }
                                }
                                
                                if !isTrue {
                                    if let datas = mArr[0] as? NSDictionary {
                                        self.mMetalName.text = "\(datas.value(forKey: "name") ?? "")"
                                        self.mPMetalName.text = "\(datas.value(forKey: "name") ?? "")"
                                        self.mMetalId = "\(datas.value(forKey: "_id") ?? "")"
                                    }
                                }
                                
                            }else{
                                self.mMetalId = ""
                                self.mMetalView.isHidden = true
                                
                            }
                        }

                        if let mArr = mData.value(forKey:"choice_data") as? NSArray {
                            if mArr.count > 0 {
                                for i in mArr {
                                    if let data = i as? NSDictionary {
                                        self.mShapeList.append("\(data.value(forKey:"name") ?? "") ")
                                        self.mShapeIdList.append("\(data.value(forKey:"id") ?? "")")
                                        
                                        if "\(mProductData.value(forKey: "shape_name") ?? "")" == "\(data.value(forKey: "name") ?? "")" {
                                            self.mShapeId = "\(data.value(forKey: "id") ?? "")"
                                            
                                            if let mArr = mData.value(forKey:"data") as? NSArray {
                                                
                                                if mArr.count > 0 {
                                                    for i in mArr {
                                                        if let data = i as? NSDictionary {
                                                            
                                                            self.mPointerList.append("\(data.value(forKey:"pointer") ?? "0.0")")
                                                            self.mPointerdPriceList.append("\(data.value(forKey:"price") ?? "0.00" )")
                                                            
                                                            if "\(mProductData.value(forKey: "pointer_name") ?? "")" == "\(data.value(forKey: "pointer") ?? "")" {
                                                                self.mPointerId = "\(data.value(forKey: "pointer") ?? "")"
                                                            }
                                                            
                                                            if "\(mProductData.value(forKey: "pointer_name") ?? "")" == "" {
                                                                
                                                                if let data = mArr[0] as? NSDictionary {
                                                                    self.mPointerName.text = "\(data.value(forKey: "pointer") ?? "")"
                                                                    self.mPointerId = "\(data.value(forKey: "pointer") ?? "")"
                                                                    self.mPrice.text =  self.mStoreCurrency +  " \(data.value(forKey: "price") ?? "0.00")"
                                                                }
                                                            }
                                                        }
                                                    }
                                                }else{
                                                    self.mPointerView.isHidden = true
                                                }
                                            }
                                            
                                        }
                                        
                                        if "\(mProductData.value(forKey: "shape_name") ?? "")" == "" {
                                            
                                            self.mPointerList = [String]()
                                            self.mPointerdPriceList = [String]()
                                            if let mData = mArr[0] as? NSDictionary {
                                                self.mShapeName.text = "\(data.value(forKey: "name") ?? "")"
                                                self.mShapeId = "\(data.value(forKey: "id") ?? "")"
                                                if let mArr = mData.value(forKey: "data") as? NSArray {
                                                    if mArr.count > 0 {
                                                        for data in mArr {
                                                            if let mData = data as? NSDictionary {
                                                                self.mPointerList.append("\(mData.value(forKey: "pointer") ?? "0.0")")
                                                                self.mPointerdPriceList.append("\(mData.value(forKey: "price") ?? "0.00")")
                                                            }
                                                        }
                                                        
                                                        if let data = mArr[0] as? NSDictionary {
                                                            self.mPointerName.text = "\(data.value(forKey: "pointer") ?? "0.0")"
                                                            self.mPointerId = "\(data.value(forKey: "pointer") ?? "0.0")"
                                                            self.mPrice.text =  self.mStoreCurrency +  " \(data.value(forKey: "price") ?? "0.00")"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }else{
                                self.mPointerId = ""
                                self.mShapeId = ""
                                self.mShapeView.isHidden = true
                                
                            }
                        }else{
                            self.mPointerId = ""
                            self.mShapeId = ""
                            self.mShapeView.isHidden = true
                            self.mPointerView.isHidden = true
                        }
                   }
                    
                }else {
                    if let error = response.value(forKey: "error") as? String{
                        if error == "Authorization has been expired" {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        } else {
                            CommonClass.showSnackBar(message: "Error \(statusCode): \(error)")
                        }
                    }
                    if let message = response.value(forKey: "message") as? String {
                        CommonClass.showSnackBar(message: "Error \(statusCode): \(message)")
                    }
                }

            }
        }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }


     }
    
}
