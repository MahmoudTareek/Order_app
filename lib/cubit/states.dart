abstract class OrdersState {}

class OrdersInitialState extends OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersChangeBottomNavBarState extends OrdersState {}

class OrdersChangePasswordVisibilityState extends OrdersState {}

class OrdersSuccessLoginState extends OrdersState {}

class OrdersLoadingLoginState extends OrdersState {}

class OrdersErrorLoginState extends OrdersState {
  final String error;

  OrdersErrorLoginState(this.error);
}

class OrdersSuccessSignoutState extends OrdersState {}

class OrdersLoadingSignoutState extends OrdersState {}

class OrdersErrorSignoutState extends OrdersState {
  final String error;

  OrdersErrorSignoutState(this.error);
}

class OrdersUpdatenumOfSelectedMealsSucessState extends OrdersState {}

class OrdersUpdatenumOfSelectedMealsLoadingState extends OrdersState {}

class OrdersUpdatenumOfSelectedMealsErrorState extends OrdersState {
  final String error;

  OrdersUpdatenumOfSelectedMealsErrorState(this.error);
}

class OrdersGetUserRoleLoadingState extends OrdersState {}

class OrdersGetUserRoleSuccessState extends OrdersState {}

class OrdersGetUserRoleErrorState extends OrdersState {
  final String error;

  OrdersGetUserRoleErrorState(this.error);
}

class OrdersGetAllMealsSuccessState extends OrdersState {}

class OrdersGetAllMealsErrorState extends OrdersState {
  final String error;

  OrdersGetAllMealsErrorState(this.error);
}

class OrdersGetMealDataSuccessState extends OrdersState {}

class OrdersGetMealDataErrorState extends OrdersState {
  final String error;

  OrdersGetMealDataErrorState(this.error);
}

class OrdersGetMealLoadingState extends OrdersState {}

class OrdersUpdateMealLoadingState extends OrdersState {}

class OrdersUpdateMealSuccessState extends OrdersState {}

class OrdersUpdateMealErrorState extends OrdersState {
  final String error;

  OrdersUpdateMealErrorState(this.error);
}

class OrdersDeleteMealSuccessState extends OrdersState {}

class OrdersDeleteMealErrorState extends OrdersState {
  final String error;

  OrdersDeleteMealErrorState(this.error);
}

class OrdersMealPcikedSuccessState extends OrdersState {}

class OrdersMealPcikedErrorState extends OrdersState {
  final String error;

  OrdersMealPcikedErrorState(this.error);
}

class OrdersRandomMealSelectededSuccessState extends OrdersState {}

class OrdersRandomMealLoadingState extends OrdersState {}

class OrderRandomMealSelectededErrorState extends OrdersState {
  final String error;

  OrderRandomMealSelectededErrorState(this.error);
}

class OrdersSelectedMealSelectededSuccessState extends OrdersState {}

class OrdersSelectedMealLoadingState extends OrdersState {}

class OrderSelectedMealSelectededErrorState extends OrdersState {
  final String error;

  OrderSelectedMealSelectededErrorState(this.error);
}

class OrdersRemoveSelectedMealSuccessState extends OrdersState {}

class OrdersRemoveSelectedMealLoadingState extends OrdersState {}

class OrderRemoveMealSelectededErrorState extends OrdersState {
  final String error;

  OrderRemoveMealSelectededErrorState(this.error);
}

class OrdersSelectedMealToUserSuccessState extends OrdersState {}

class OrdersSelectedMealToUserLoadingState extends OrdersState {}

class OrderMealSelectedToUseredErrorState extends OrdersState {
  final String error;

  OrderMealSelectedToUseredErrorState(this.error);
}

class OrdersUpdateMealImageSuccessState extends OrdersState {}

class OrdersUpdateMealImageLoadingState extends OrdersState {}

class OrdersUpdateMealImageErrorState extends OrdersState {
  final String error;

  OrdersUpdateMealImageErrorState(this.error);
}

class OrdersgetMealImageSuccessState extends OrdersState {}

class OrdersgetMealImageLoadingState extends OrdersState {}

class OrdersgetMealImageErrorState extends OrdersState {
  final String error;

  OrdersgetMealImageErrorState(this.error);
}
