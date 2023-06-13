abstract class BaseStates {}

class BaseInitialState extends BaseStates {}

// change index

class BaseChangeIndexState extends BaseStates {}

// get user data

class BaseGetUserDataLoadingState extends BaseStates {}

class BaseGetUserDataSuccessState extends BaseStates {}

class BaseGetUserDataErrorState extends BaseStates {
  final String error;

  BaseGetUserDataErrorState(this.error);
}

// get popular items

class BaseGetPopularItemsLoadingState extends BaseStates {}

class BaseGetPopularItemsSuccessState extends BaseStates {}

class BaseGetPopularItemsErrorState extends BaseStates {
  final String error;

  BaseGetPopularItemsErrorState(this.error);
}

// get  items

class BaseGetItemsLoadingState extends BaseStates {}

class BaseGetItemsSuccessState extends BaseStates {}

class BaseGetItemsErrorState extends BaseStates {
  final String error;

  BaseGetItemsErrorState(this.error);
}

// order item state

// add item

class BaseAddOrderToCartSuccessState extends BaseStates {}

class BaseAddOrderToCartErrorState extends BaseStates {
  final String error;

  BaseAddOrderToCartErrorState(this.error);
}

// remove order

class BaseRemoveOrderSuccessState extends BaseStates {}

// sent order to firebase

class SentOrderToFirebaseLoadingState extends BaseStates {}

class SentOrderToFirebaseSuccessState extends BaseStates {}

class SentOrderToFirebaseErrorState extends BaseStates {
  final String error;

  SentOrderToFirebaseErrorState(this.error);
}

// remove meal

class BaseRemoveMealSuccessState extends BaseStates {}

// get meals by category

class GetMealsByCategoryState extends BaseStates {}

// search item

class SearchItemState extends BaseStates {}

// get real time order state

class GetRealTimeOrderStateLiveState extends BaseStates {}

class GetRealTimeOrderStateLoadingState extends BaseStates {}

class GetRealTimeOrderStateSuccessState extends BaseStates {}

class GetRealTimeOrderStateErrorState extends BaseStates {
  final String error;

  GetRealTimeOrderStateErrorState(this.error);
}

class OrderDoneState extends BaseStates {}