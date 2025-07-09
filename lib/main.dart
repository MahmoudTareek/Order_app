// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_app/addmeal/addmeal.dart';
import 'package:order_app/cubit/cubit.dart';
import 'package:order_app/firebase_options.dart';
import 'package:order_app/modules/login/login_screen.dart';
import 'package:order_app/modules/menu/menu_screen.dart';
import 'package:order_app/modules/yourmeals/yourmeals.dart';
import 'package:order_app/shared/sharedprefrence.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit()..getAllMeals(),
        ),
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit()..getRandomMeal(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: YourMealsScreen(),
      ),
    );
  }
}
