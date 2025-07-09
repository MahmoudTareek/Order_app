import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_app/cubit/cubit.dart';
import 'package:order_app/cubit/states.dart';
import 'package:order_app/shared/components/components.dart';

class AddMealScreen extends StatelessWidget {
  AddMealScreen({super.key, this.mealId});

  final String? mealId;
  TextEditingController mealNameController = TextEditingController();
  TextEditingController mealDescriptionController = TextEditingController();
  TextEditingController mealPriceController = TextEditingController();
  TextEditingController mealIdController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    bool isAdded = false;
    return BlocProvider(
      create: (context) => OrdersCubit()..getMealData(mealId),
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          print(state);
        },
        builder: (context, state) {
          var cubit = OrdersCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, isAdded);
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text(
                'Add Meal',
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
                    // Image(
                    //   image: NetworkImage(
                    //     '${cubit.meals?.imageUrl.toString()}',
                    //   ),
                    //   height: 200,
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    // ),
                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: defaultFormField(
                        controller: mealIdController,
                        type: TextInputType.number,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Meal ID must not be empty';
                          }
                          return null;
                        },
                        label: 'ID',
                        prefix: Icons.info_outlined,
                      ),
                    ),
                    const SizedBox(height: 10.0),
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
                    const SizedBox(height: 10.0),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => pickImage(context),
                        icon: Icon(Icons.image),
                        label: Text('Pick Meal Image'),
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
                                  cubit.addMeal(
                                    id: mealIdController.text,
                                    name: mealNameController.text,
                                    description: mealDescriptionController.text,
                                    price: mealPriceController.text,
                                    imageUrl:
                                        selectedImage != null
                                            ? selectedImage!.path
                                            : 'https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ=',
                                  );
                                  isAdded = true;
                                }
                              },
                              text: 'add meal',
                              radius: 50.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: defaultButton(
                              function: () {
                                Navigator.pop(context, true);
                              },
                              text: 'cancel',
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

  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      (context as Element).markNeedsBuild();
    }
  }
}
