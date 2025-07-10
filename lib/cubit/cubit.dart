import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_app/cubit/states.dart';
import 'package:order_app/models/meals_model.dart';
import 'package:order_app/modules/home/home_screen.dart';
import 'package:order_app/modules/login/login_screen.dart';
import 'package:order_app/modules/menu/menu_screen.dart';
import 'package:order_app/modules/yourmeals/yourmeals.dart';
import 'package:order_app/shared/components/components.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitialState());

  static OrdersCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Your Meals'),
  ];

  // List<String> screenName = ['Menu', 'Your Meals'];

  List<Widget> screens = [MenuScreen(), YourMealsScreen()];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 0) {
      MenuScreen();
    }
    if (index == 1) {
      YourMealsScreen();
    }
    emit(OrdersChangeBottomNavBarState());
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(OrdersChangeBottomNavBarState());
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(OrdersChangePasswordVisibilityState());
  }

  String? userID;

  void userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(OrdersLoadingLoginState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          emit(OrdersSuccessLoginState());

          userID = value.user!.uid;
          print('User ID: $userID');
          getUserRole(uID: value.user!.uid, context: context);
        })
        .catchError((error) {
          emit(OrdersErrorLoginState(error.toString()));
          Fluttertoast.showToast(
            msg: "Login Failed, Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
  }

  void userSignout({required context}) async {
    emit(OrdersLoadingSignoutState());
    await FirebaseAuth.instance
        .signOut()
        .then((value) {
          userID = null;
          emit(OrdersSuccessSignoutState());
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
          );
        })
        .catchError((error) {
          emit(OrdersErrorSignoutState(error.toString()));
        });
  }

  void getUserRole({required uID, required BuildContext context}) {
    emit(OrdersGetUserRoleLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .get()
        .then((value) {
          if (value.exists) {
            String role = value.data()!['role'];
            print(role);
            emit(OrdersGetUserRoleSuccessState());
            if (role == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (role == 'user') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => YourMealsScreen()),
              );
            } else {
              emit(OrdersGetUserRoleErrorState('Invalid user role'));
            }
          } else {
            emit(OrdersGetUserRoleErrorState('User not found'));
          }
        })
        .catchError((error) {
          emit(OrdersGetUserRoleErrorState(error.toString()));
        });
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

  Future<void> addMeal({
    required id,
    required name,
    required description,
    required price,
    required File? imageFile,
  }) async {
    String imageURL =
        'https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ=';
    if (imageFile != null) {
      emit(OrdersUpdateMealImageLoadingState());
      try {
        final ref = firebase_storage.FirebaseStorage.instance.ref().child(
          'meals/${Uri.file(imageFile.path).pathSegments.last}',
        );
        await ref.putFile(imageFile);
        imageURL = await ref.getDownloadURL();
      } catch (e) {
        emit(OrdersGetAllMealsErrorState(e.toString()));
        Fluttertoast.showToast(
          msg: "$name Not Added, Image Upload Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    }
    meals = MealsModel(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl:
          imageURL.isNotEmpty
              ? imageURL
              : 'https://via.placeholder.com/150.png?text=Meal+Image',
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
    String? imageUrl,
  }) {
    meals = MealsModel(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl ?? meals!.imageUrl,
    );
    emit(OrdersUpdateMealLoadingState());
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

  File? mealImage;
  var picker = ImagePicker();

  Future<void> getMealImage() async {
    emit(OrdersgetMealImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      mealImage = File(pickedFile.path);
      emit(OrdersgetMealImageSuccessState());
    } else {
      emit(OrdersgetMealImageErrorState('No image selected.'));
    }
  }

  void updateMealImage({
    required id,
    required name,
    required description,
    required price,
    File? imageFile,
  }) {
    emit(OrdersUpdateMealImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('meals/${Uri.file(mealImage!.path).pathSegments.last}')
        .putFile(mealImage!)
        .then((value) {
          value.ref
              .getDownloadURL()
              .then((value) {
                // meals!.imageUrl = value;
                updateMealData(
                  id: id,
                  name: name,
                  description: description,
                  price: price,
                  imageUrl: value,
                );
              })
              .catchError((error) {
                print('Error ${error.toString()}');
                emit(OrdersUpdateMealImageErrorState(error.toString()));
              });
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

  void getSelectedData(List ids) async {
    emit(OrdersSelectedMealLoadingState());
    selectedMeals.clear();
    try {
      List<Future> futures = [];

      for (var id in ids) {
        futures.add(
          FirebaseFirestore.instance.collection('meals').doc(id).get(),
        );
      }

      List responses = await Future.wait(futures);

      for (var doc in responses) {
        if (doc.exists) {
          selectedMeals.add(MealsModel.fromJson(doc.data()!));
        }
      }

      emit(OrdersSelectedMealSelectededSuccessState());
    } catch (error) {
      debugPrint(error.toString());
      emit(OrderSelectedMealSelectededErrorState(error.toString()));
    }
  }

  void addSelectedMeal(selectedMealId) {
    emit(OrdersSelectedMealToUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
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

  int? numOfSelectedMeal;

  void getNumOfUserOfSelectedMeals({required uID}) {
    emit(OrdersSelectedMealToUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .get()
        .then((value) {
          numOfSelectedMeal = value.data()!['numOfSelectedMeals'];
          emit(OrdersSelectedMealToUserSuccessState());
        })
        .catchError((error) {
          emit(OrderMealSelectedToUseredErrorState(error.toString()));
        });
  }

  void updateUserOfSelectedMeals({required uID, required number}) {
    numOfSelectedMeal = number;
    emit(OrdersSelectedMealToUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .update({'numOfSelectedMeals': number})
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
    selectedMeals.removeWhere((meal) => meal.id == id);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
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
    FirebaseFirestore.instance.collection('users').doc(userID).get().then((
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
