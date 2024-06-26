import 'package:food_app/data/network/fcm.dart';
import 'package:food_app/data/network/firebase_auth.dart';
import 'package:food_app/data/network/firebase_store.dart';
import 'package:food_app/data/response/responses.dart';
import 'package:food_app/domain/model/models.dart';
import 'package:http/http.dart';

abstract class RemoteDataSource {
  Future<void> userCreate(UserRegister userRegister);
  Future<void> userRegister(UserRegister userRegister);
  Future<OtpCheckModel> otpCheck(String verificationId, String smsCode);
  Future<void> verifyPhoneNumber(VerifyPhoneNumberModel varifyPhoneNumberModel);
  Future<CustomerResponse> getUserData(String uid);
  Future<List<ItemResponse>> getPopularItems();
  Future<List<ItemResponse>> getItems();
  Future<String> sentOrderToFirebase(ClientAllOrders orders);
  Future<List<ClientAllOrdersResponse>> getOrdersFromFirebase();
  Future<void> deleteOrder(String id);
  Future<void> addNewMealItem(AddNewMealObject addNewMealObject);
  Future<void> deleteMeal(String id);
  Stream<String> getRealTimeOrderState(String id);
  Future<void> changingOrderState(ChangingOrderStateObject object);
  Stream<List<ClientAllOrdersResponse>> getRealtimeOrders();
  Future<void> addItemToFavoriteList(AddToFavoriteObject addToFavoriteObject);
  Future<void> removeItemFromFavoriteList(AddToFavoriteObject addToFavoriteObject);
  Future<bool> getIsStoreOpen();
  Future<void> changeIsStoreOpen();
  Future<void> saveToken(String token);
  Future<Response> sentPushNotification(String token, String notificationBody);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseStoreClient _firebaseStoreClient;
  final FirebaseAuthentication _firebaseAuthentication;
  final Fcm _fcm;
  RemoteDataSourceImpl(this._firebaseStoreClient, this._firebaseAuthentication, this._fcm);

  @override
  Future<void> userCreate(UserRegister userRegister) async {
    await _firebaseStoreClient.userCreate(userRegister);
  }

  @override
  Future<void> userRegister(UserRegister userRegister) async {
    await _firebaseAuthentication.userRegister(userRegister);
  }

  @override
  Future<OtpCheckModel> otpCheck(String verificationId, String smsCode) async {
    return await _firebaseAuthentication.otpCheck(verificationId, smsCode);
  }

  @override
  Future<void> verifyPhoneNumber(VerifyPhoneNumberModel varifyPhoneNumberModel) async {
    return await _firebaseAuthentication.verifyPhoneNumber(varifyPhoneNumberModel);
  }

  @override
  Future<CustomerResponse> getUserData(String uid) async {
    return await _firebaseStoreClient.getUserData(uid);
  }

  @override
  Future<List<ItemResponse>> getPopularItems() async {
    return await _firebaseStoreClient.getPopularItems();
  }

  @override
  Future<List<ItemResponse>> getItems() async {
    return await _firebaseStoreClient.getItems();
  }

  @override
  Future<String> sentOrderToFirebase(ClientAllOrders orders) async {
    return await _firebaseStoreClient.sentOrderToFirebase(orders);
  }

  @override
  Future<List<ClientAllOrdersResponse>> getOrdersFromFirebase() async {
    return await _firebaseStoreClient.getOrdersFromFirebase();
  }

  @override
  Future<void> deleteOrder(String id) async {
    return await _firebaseStoreClient.deleteOrder(id);
  }

  @override
  Future<void> addNewMealItem(AddNewMealObject addNewMealObject) async {
    return await _firebaseStoreClient.addNewMealItem(addNewMealObject);
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _firebaseStoreClient.deleteMeal(id);
  }

  @override
  Stream<String> getRealTimeOrderState(String id) {
    return _firebaseStoreClient.getRealTimeOrderState(id);
  }

  @override
  Future<void> changingOrderState(ChangingOrderStateObject object) async {
    return await _firebaseStoreClient.changingOrderState(object);
  }

  @override
  Stream<List<ClientAllOrdersResponse>> getRealtimeOrders() {
    return _firebaseStoreClient.getRealtimeOrders();
  }

  @override
  Future<void> addItemToFavoriteList(AddToFavoriteObject addToFavoriteObject) async {
    return await _firebaseStoreClient.addItemToFavoriteList(addToFavoriteObject);
  }

  @override
  Future<void> removeItemFromFavoriteList(AddToFavoriteObject addToFavoriteObject) async {
    return await _firebaseStoreClient.removeItemFromFavoriteList(addToFavoriteObject);
  }

  @override
  Future<bool> getIsStoreOpen() async {
    return await _firebaseStoreClient.getIsStoreOpen();
  }

  @override
  Future<void> changeIsStoreOpen() async {
    return await _firebaseStoreClient.changeIsStoreOpen();
  }

  @override
  Future<void> saveToken(String token) async {
    return await _firebaseStoreClient.saveToken(token);
  }

  @override
  Future<Response> sentPushNotification(String token, String notificationBody) async {
    return _fcm.sentPushNotification(token, notificationBody);
  }
}
