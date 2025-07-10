import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:order_app/cubit/cubit.dart';

Widget defaultButton({
  required VoidCallback function,
  bool isDisabled = false,
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required String text,
}) => Container(
  width: width,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(color: Colors.white),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);

Widget defaultFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPrssed,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: (s) {
    onSubmit!(s);
  },
  onChanged: (s) {
    onChange!(s);
  },
  onTap: () {
    onTap!();
  },
  // validator: (s) {
  //   validate(s);
  //   return null;
  // },
  validator: (value) => validate(value),
  enabled: isClickable,
  decoration: InputDecoration(
    labelStyle: TextStyle(color: secondryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
    ),
    labelText: label,
    prefixIcon: Icon(prefix),
    suffix:
        suffix != null
            ? IconButton(
              onPressed: () {
                OrdersCubit.get(context).changePasswordVisibility();
                isPassword = !isPassword;
                suffixPrssed!();
              },
              icon: Icon(suffix),
            )
            : null,
    border: OutlineInputBorder(),
  ),
);

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 20.0),
  child: Container(
    width: double.infinity,
    height: 2.0,
    color: Colors.grey[300],
  ),
);

Future<dynamic> navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

int selectedMeal = 0;
List<String> selectedMealIds = [];

const Color primaryColor = Colors.deepOrange;

const Color secondryColor = Colors.blue;
