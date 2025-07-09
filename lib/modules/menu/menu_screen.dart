import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_app/addmeal/addmeal.dart';
import 'package:order_app/cubit/cubit.dart';
import 'package:order_app/cubit/states.dart';
import 'package:order_app/editmeal/edit_meal_screen.dart';
import 'package:order_app/shared/components/components.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        var cubit = OrdersCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Menu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () async {
              final result = await navigateTo(context, AddMealScreen());
              if (result == true) {
                OrdersCubit.get(context).getAllMeals();
              }
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
          body: Row(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: cubit.mealsList.length,
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
                                '${cubit.mealsList?[index].imageUrl.toString()}',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${cubit.mealsList?[index].name.toString()}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '${cubit.mealsList?[index].description.toString()}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 35.0),
                                Row(
                                  children: [
                                    Text(
                                      'EGP ',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      '${cubit.mealsList?[index].price.toString()}',
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
                                color: Colors.grey[400],
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () async {
                                  final result = await navigateTo(
                                    context,
                                    EditMealScreen(
                                      mealId: cubit.mealsList[index].id,
                                    ),
                                  );
                                  if (result == true) {
                                    OrdersCubit.get(context).getAllMeals();
                                  }
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
