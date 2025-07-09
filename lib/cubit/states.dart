abstract class OrdersState {}

class OrdersInitialState extends OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersChangeBottomNavBarState extends OrdersState {}

class OrdersSuccessLoginState extends OrdersState {}

class OrdersErrorLoginState extends OrdersState {
  final String error;

  OrdersErrorLoginState(this.error);
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
