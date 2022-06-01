// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SindhLandDepartment {

address public LandInspectorID;


constructor () { LandInspectorID=msg.sender;}

    mapping (address => LandInspector) public Landinspector;
    mapping (uint => LandID) public LandDetails;
    mapping (uint => address) public LandOwner;
    mapping (address => Buyer) public buyerDetail;
    mapping (address => Seller) public Property_Seller;
    mapping (address => bool) public RejectBuyer;
    mapping (address => bool) public RejectSeller;
    mapping (uint => bool) public LandVerification;
    mapping (address => bool) public _IsSeller;
    mapping (address => bool) public _IsBuyer;


struct LandInspector {

    string LandInspector;
    uint age;
    string designation;
}

struct LandID {

    uint LandId;
    uint area;
    string city;
    string state;
    uint landprice;
    uint PropertyID;
}

struct Buyer {

    address BuyerID;
    string name;
    uint age;
    string city;
    uint cnic;
    string email;
}

struct Seller {

    address SellerID;
    string name;
    uint age;
    string city;
    uint cnic;
    string email;
}


    function LandInspection(string memory _LandInspector, uint age,
    string memory designation) public {
    Landinspector[LandInspectorID] = LandInspector (_LandInspector, age, designation);
}


    function NewLandRegistry(uint LandId, uint area, string memory city, string memory state,
    uint landprice, uint PropertyID) public {

    require (_IsSeller[msg.sender]==true, "You are not verified");

    LandDetails[LandId] = LandID (LandId, area, city, state, landprice, PropertyID);

    LandOwner [LandId]=msg.sender;
}


    function BuyerDetails (string memory name, uint age, string memory city, uint cnic,
    string memory email) public {
        
    require(!_IsBuyer[msg.sender] ,"This user aready exist");

    buyerDetail[msg.sender] = Buyer (msg.sender, name, age, city, cnic, email);

    _IsBuyer[msg.sender]=true;

}


    function SellerDetails (string memory name, uint age, string memory city, uint cnic,
    string memory email) public {

    require(!_IsSeller[msg.sender] ,"This user aready exist");

    Property_Seller[msg.sender] = Seller (msg.sender, name, age, city, cnic, email);

    _IsSeller[msg.sender]=true;

}

modifier OnlyLandInspector {
require (LandInspectorID==msg.sender, "You are not LandInspector");
_;}


    function _Verifyseller (address _address) public OnlyLandInspector {
    _IsSeller[_address]=true;


}


    function _VerifyPurchaser (address _address) public OnlyLandInspector {
    _IsBuyer[_address]=true;

}


    function _RejectBuyer (address _address) public OnlyLandInspector {
    RejectBuyer[_address]=true;

}


    function _RejectSeller (address _address) public OnlyLandInspector {
    RejectSeller[_address]=true;

}


    function updateBuyer(string memory _name, uint _age, string memory _city,
    uint _cnic, string memory _email) public {


    buyerDetail[msg.sender].name = _name;
    buyerDetail[msg.sender].age = _age;
    buyerDetail[msg.sender].cnic = _cnic;
    buyerDetail[msg.sender].city = _city;
    buyerDetail[msg.sender].email = _email;
}

    function updateSeller(string memory _name, uint _age, string memory _city,
    uint _cnic, string memory _email) public {


    Property_Seller[msg.sender].name = _name;
    Property_Seller[msg.sender].age = _age;
    Property_Seller[msg.sender].cnic = _cnic;
    Property_Seller[msg.sender].city = _city;
    Property_Seller[msg.sender].email = _email;
}


    function _LandVerification(uint _address) public view returns (bool) {
    if(LandVerification[_address])

{return true;}

}


    function verifyLand(uint _landId) public OnlyLandInspector {
    LandVerification[_landId] = true;
}


    function isSeller(address _address) public view returns (bool) {
    if(_IsSeller[_address])

{return true;}

}

    function isBuyer(address _address) public view returns (bool) {
    if(_IsBuyer[_address])

{return true;}

}

    function getArea(uint i) public view returns (uint) {
return LandDetails[i].area;
}

    function getPrice(uint i) public view returns (uint) {
return LandDetails[i].landprice;
}


    function getCity(uint i) public view returns (string memory) {
return LandDetails[i].city;
}



    function TransferOwnership (uint _landID) public payable {

require(_IsBuyer[msg.sender] && LandVerification[_landID],"either your buyer or and is not verified");

require(LandDetails[_landID].landprice==msg.value, "Please pay complete price");

    payable(LandOwner[_landID]).transfer(msg.value);
    LandOwner[_landID] = msg.sender;

}

}
