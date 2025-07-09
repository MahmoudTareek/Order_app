import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_app/cubit/states.dart';
import 'package:order_app/models/meals_model.dart';
import 'package:order_app/modules/home/home_screen.dart';
import 'package:order_app/modules/menu/menu_screen.dart';
import 'package:order_app/modules/yourmeals/yourmeals.dart';
import 'package:order_app/modules/settings/settings_screen.dart';
import 'package:order_app/shared/components/components.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitialState());

  static OrdersCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Your Meals'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  List<Widget> screens = [MenuScreen(), YourMealsScreen(), SettingsScreen()];

  // List<String> titles = ['Menu', 'Your Meals', 'Settings'];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) {
      YourMealsScreen();
    }
    if (index == 2) {
      SettingsScreen();
    }
    emit(OrdersChangeBottomNavBarState());
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(OrdersChangeBottomNavBarState());
  }

  void checkMailAndPassword(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      emit(OrdersSuccessLoginState());
    } else {
      emit(OrdersSuccessLoginState());
      //  navigateTo(context, HomeScreen());
    }
  }

  MealsModel? meals;

  void getMealData(id) {
    emit(OrdersGetMealLoadingState());
    FirebaseFirestore.instance
        .collection('meals')
        .doc(id)
        .get()
        .then((value) {
          meals = MealsModel.fromJson(value.data()!);
          emit(OrdersGetMealDataSuccessState());
        })
        .catchError((error) {
          debugPrint(error.toString());

          emit(OrdersGetMealDataErrorState(error.toString()));
        });
  }

  List<MealsModel> mealsList = [];

  void getAllMeals() async {
    mealsList.clear();
    emit(OrdersGetMealLoadingState());
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('meals').get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      mealsList.add(MealsModel.fromMap(data));
    }
    if (mealsList.isNotEmpty) {
      emit(OrdersGetAllMealsSuccessState());
    } else {
      emit(OrdersGetAllMealsErrorState('No meals found'));
    }
  }

  void addMeal({
    required id,
    required name,
    required description,
    required price,
    required imageUrl,
  }) {
    meals = MealsModel(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );
    FirebaseFirestore.instance
        .collection('meals')
        .doc(id)
        .set(meals!.toJson())
        .then((value) {
          emit(OrdersGetAllMealsSuccessState());
          Fluttertoast.showToast(
            msg: "$name Added Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        })
        .catchError((error) {
          emit(OrdersGetAllMealsErrorState(error.toString()));
          Fluttertoast.showToast(
            msg: "$name Not Added, Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
  }

  void updateMealData({
    required id,
    required name,
    required description,
    required price,
  }) {
    meals = MealsModel(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl:
          'https://takrecipe.com/wp-content/uploads/2022/10/beef-steak-recipe.jpg',
    );
    FirebaseFirestore.instance
        .collection('meals')
        .doc(id)
        .update(meals!.toJson())
        .then((value) {
          emit(OrdersUpdateMealSuccessState());
          Fluttertoast.showToast(
            msg: "$name Updated Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        })
        .catchError((error) {
          emit(OrdersUpdateMealErrorState(error));
          Fluttertoast.showToast(
            msg: "$name Not Updated, Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
  }

  void deleteMeal(id) {
    FirebaseFirestore.instance
        .collection('meals')
        .doc(id)
        .delete()
        .then((value) {
          emit(OrdersDeleteMealSuccessState());
        })
        .catchError((error) {
          emit(OrdersDeleteMealErrorState(error));
        });
  }

  File? mealImage;
  var picker = ImagePicker();
  Future<void> getMealImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      mealImage = File(pickedFile.path);
      emit(OrdersMealPcikedSuccessState());
    } else {
      print('No image selected.');
      emit(OrdersMealPcikedSuccessState());
    }
  }

  List<MealsModel> randomMeals = [];

  void getRandomMeal() {
    randomMeals.clear();
    emit(OrdersRandomMealLoadingState());

    FirebaseFirestore.instance
        .collection('meals')
        .get()
        .then((snapshot) {
          List<MealsModel> allMeals =
              snapshot.docs
                  .map((doc) => MealsModel.fromJson(doc.data()))
                  .toList();

          allMeals.shuffle();

          randomMeals = allMeals.take(5).toList();

          emit(OrdersRandomMealSelectededSuccessState());
        })
        .catchError((error) {
          debugPrint(error.toString());
          emit(OrderRandomMealSelectededErrorState(error.toString()));
        });
  }

  List<MealsModel> selectedMeals = [];

  void getSelectedData(List ids) {
    emit(OrdersSelectedMealLoadingState());
    for (int i = 0; i < ids.length; i++) {
      FirebaseFirestore.instance
          .collection('meals')
          .doc(ids[i])
          .get()
          .then((value) {
            meals = MealsModel.fromJson(value.data()!);
            selectedMeals.add(meals!);
            emit(OrdersSelectedMealSelectededSuccessState());
          })
          .catchError((error) {
            debugPrint(error.toString());

            emit(OrderSelectedMealSelectededErrorState(error.toString()));
          });
    }
  }

  void addSelectedMeal(selectedMealId) {
    emit(OrdersSelectedMealToUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc('2')
        .update({
          'selectedMealIds': FieldValue.arrayUnion([selectedMealId]),
        })
        .then((value) {
          emit(OrdersSelectedMealToUserSuccessState());
        })
        .catchError((error) {
          emit(OrderMealSelectedToUseredErrorState(error.toString()));
        });
  }

  List<MealsModel> selectedUserMeals = [];

  void removeSelectedMeal(String id, List selectedUserMeals) {
    emit(OrdersRemoveSelectedMealLoadingState());
    print(id);
    selectedUserMeals.remove(id);
    print(selectedUserMeals);
    FirebaseFirestore.instance
        .collection('users')
        .doc('2')
        .update({
          'selectedMealIds': FieldValue.arrayRemove([id]),
        })
        .then((value) {
          emit(OrdersRemoveSelectedMealSuccessState());
        })
        .catchError((error) {
          emit(OrderRemoveMealSelectededErrorState(error.toString()));
        });
  }

  void getSelectedUserMeals() async {
    selectedUserMeals.clear();
    emit(OrdersSelectedMealLoadingState());
    FirebaseFirestore.instance.collection('users').doc('2').get().then((
      DocumentSnapshot doc,
    ) {
      List<dynamic> mealIds = doc['selectedMealIds'];

      for (var mealId in mealIds) {
        FirebaseFirestore.instance
            .collection('meals')
            .doc(mealId)
            .get()
            .then((mealDoc) {
              selectedUserMeals.add(MealsModel.fromJson(mealDoc.data()!));
              emit(OrdersSelectedMealSelectededSuccessState());
            })
            .catchError((error) {
              emit(OrderSelectedMealSelectededErrorState(error.toString()));
            });
      }
    });
  }
}
