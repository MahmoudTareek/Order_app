import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_app/addmeal/addmeal.dart';
import 'package:order_app/cubit/cubit.dart';
import 'package:order_app/cubit/states.dart';
import 'package:order_app/editmeal/edit_meal_screen.dart';
import 'package:order_app/shared/components/components.dart';
import 'package:order_app/shared/sharedprefrence.dart';

class SelectedMealsScreen extends StatefulWidget {
  final List<String> selectedMealIds;
  const SelectedMealsScreen({super.key, required this.selectedMealIds});

  @override
  State<SelectedMealsScreen> createState() => _SelectedMealsScreenState();
}

class _SelectedMealsScreenState extends State<SelectedMealsScreen> {
  @override
  void initState() {
    super.initState();
    var cubit = OrdersCubit.get(context);
    // OrdersCubit.get(context).getSelectedData(widget.selectedMealIds);
    OrdersCubit.get(context).getSelectedUserMeals();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        var cubit = OrdersCubit.get(context);
        // print(selectedMealIds);
        if (state is OrdersSelectedMealLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Selected Meals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Selected Meals',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body:
              widget.selectedMealIds == null
                  ? Text('No Meals Selected')
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: cubit.selectedUserMeals.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 130,
                                        width: 130,
                                        child: Image(
                                          image: NetworkImage(
                                            '${cubit.selectedUserMeals?[index].imageUrl.toString()}',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${cubit.selectedUserMeals?[index].name.toString()}',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Text(
                                              '${cubit.selectedUserMeals?[index].description.toString()}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 35.0),
                                            Row(
                                              children: [
                                                Text(
                                                  'EGP ',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  '${cubit.selectedUserMeals?[index].price.toString()}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
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
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              if (cubit.numOfSelectedMeal ==
                                                  1) {
                                                Navigator.pop(context);
                                              }
                                              cubit.numOfSelectedMeal =
                                                  --selectedMeal;
                                              cubit.updateUserOfSelectedMeals(
                                                uID: cubit.userID,
                                                number:
                                                    cubit.numOfSelectedMeal!,
                                              );
                                              selectedMealIds.removeWhere(
                                                (id) =>
                                                    id ==
                                                    cubit
                                                        .selectedUserMeals[index]
                                                        .id,
                                              );

                                              cubit.removeSelectedMeal(
                                                cubit
                                                    .selectedUserMeals[index]
                                                    .id,
                                                cubit.selectedUserMeals,
                                              );
                                              setState(() {
                                                OrdersCubit.get(
                                                  context,
                                                ).getSelectedUserMeals();
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LockableDefaultButton(
                          onPressed: () {},
                          text: 'order now',
                          radius: 30.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
        );
      },
    );
  }
}
