import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:order_app/addmeal/addmeal.dart';
import 'package:order_app/cubit/cubit.dart';
import 'package:order_app/cubit/states.dart';
import 'package:order_app/editmeal/edit_meal_screen.dart';
import 'package:order_app/selectedmeals/selected_meals_screen.dart';
import 'package:order_app/shared/components/components.dart';

class YourMealsScreen extends StatelessWidget {
  const YourMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrdersCubit.get(
      context,
    ).getNumOfUserOfSelectedMeals(uID: OrdersCubit.get(context).userID);
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        if (state is OrdersRandomMealLoadingState) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
        int randomsMeal = 5;
        var cubit = OrdersCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.logout, color: secondryColor),
              onPressed: () {
                cubit.userSignout(context: context);
              },
            ),
            title: const Text(
              'Your Meals',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: secondryColor),
                    onPressed: () async {
                      navigateTo(
                        context,
                        SelectedMealsScreen(selectedMealIds: selectedMealIds),
                      );
                    },
                  ),
                  if (selectedMealIds.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${selectedMealIds.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: Row(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: randomsMeal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 130,
                            width: 130,
                            child: Image(
                              image: NetworkImage(
                                '${cubit.randomMeals?[index].imageUrl.toString()}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${cubit.randomMeals?[index].name.toString()}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '${cubit.randomMeals?[index].description.toString()}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                Row(
                                  children: [
                                    Text(
                                      'EGP ',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      '${cubit.randomMeals?[index].price.toString()}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              top: 50.0,
                            ),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white),
                                onPressed: () async {
                                  if (cubit.numOfSelectedMeal! < 3) {
                                    if (selectedMealIds.contains(
                                      cubit.randomMeals[index].id,
                                    )) {
                                      Fluttertoast.showToast(
                                        msg: "You already selected this Meal!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.yellow[700],
                                        textColor: Colors.black,
                                        fontSize: 16.0,
                                      );
                                      return;
                                    } else {
                                      cubit.numOfSelectedMeal = ++selectedMeal;
                                      cubit.updateUserOfSelectedMeals(
                                        uID: cubit.userID,
                                        number: cubit.numOfSelectedMeal!,
                                      );
                                      selectedMealIds.add(
                                        cubit.randomMeals[index].id,
                                      );
                                      cubit.addSelectedMeal(
                                        cubit.randomMeals[index].id,
                                      );
                                    }
                                  } else if (selectedMealIds.length == 3) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "You can choose 3 Meals only! Remove one meal from your cart to add another.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.yellow[700],
                                      textColor: Colors.black,
                                      fontSize: 16.0,
                                    );
                                  }
                                  // print(
                                  //   "HHHHEEEEEEEEEEEEERRRRRRRRRRRREEEEEEEEEEE",
                                  // );
                                  // print(cubit.randomMeals[index].id);
                                  // final result = await navigateTo(
                                  //   context,
                                  //   SelectedMealsScreen(
                                  //     mealId: cubit.randomMeals[index].id,
                                  //   ),
                                  // );
                                  // if (result == true) {
                                  //   OrdersCubit.get(context).getAllMeals();
                                  // }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
