import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_app/cubit/cubit.dart';
import 'package:order_app/cubit/states.dart';
import 'package:order_app/modules/menu/menu_screen.dart';
import 'package:order_app/shared/components/components.dart';

class EditMealScreen extends StatelessWidget {
  final String? mealId;
  const EditMealScreen({Key? key, this.mealId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    bool isUpdated = false;

    return BlocProvider(
      create: (context) => OrdersCubit()..getMealData(mealId),
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          print(state);
        },
        builder: (context, state) {
          var cubit = OrdersCubit.get(context);
          var mealImage = OrdersCubit.get(context).mealImage;
          TextEditingController mealNameController = TextEditingController(
            text: cubit.meals?.name.toString(),
          );
          TextEditingController mealDescriptionController =
              TextEditingController(text: cubit.meals?.description.toString());
          TextEditingController mealPriceController = TextEditingController(
            text: cubit.meals?.price.toString(),
          );
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, isUpdated);
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text(
                '${cubit.meals?.name.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image(
                          image:
                              mealImage != null
                                  ? FileImage(mealImage)
                                  : NetworkImage(
                                    '${cubit.meals?.imageUrl.toString()}',
                                  ),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        IconButton(
                          onPressed: () {
                            OrdersCubit.get(context).getMealImage();
                          },
                          icon: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: defaultFormField(
                        controller: mealNameController,
                        type: TextInputType.text,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Meal name must not be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: Icons.food_bank,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: defaultFormField(
                        controller: mealDescriptionController,
                        type: TextInputType.text,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Meal description must not be empty';
                          }
                          return null;
                        },
                        label: 'Description',
                        prefix: Icons.description,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: defaultFormField(
                        controller: mealPriceController,
                        type: TextInputType.number,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Meal price must not be empty';
                          }
                          return null;
                        },
                        label: 'Price',
                        prefix: Icons.money,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.updateMealData(
                                    id: mealId,
                                    name: mealNameController.text,
                                    description: mealDescriptionController.text,
                                    price: mealPriceController.text,
                                  );
                                  isUpdated = true;
                                }
                              },
                              text: 'update',
                              radius: 50.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: defaultButton(
                              function: () {
                                showFancyDeleteDialog(
                                  context: context,
                                  onConfirm: () {
                                    cubit.deleteMeal(mealId);
                                    // Navigator.pop(context, true);
                                  },
                                );
                              },
                              text: 'delete',
                              radius: 50.0,
                              background: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showFancyDeleteDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Delete Meal?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Are you sure you want to delete this meal?\nThis action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onConfirm();
                            Navigator.pop(context);
                            Navigator.pop(context, true);

                            print("HHHHHHHHHHHHHHEEEEEEEEEEEEEe");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
