// import 'package:order_meal/modules/web_view/web_view_screen.dart';
// import 'package:order_meal/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required Function() function,
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
    labelText: label,
    prefixIcon: Icon(prefix),
    suffix:
        suffix != null
            ? IconButton(
              onPressed: () {
                suffixPrssed!();
              },
              icon: Icon(suffix),
            )
            : null,
    border: OutlineInputBorder(),
  ),
);

// Widget buildTaskItem(Map model, context) => Dismissible(
//   key: Key(model['id'].toString()),
//   child: Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Row(
//       children: [
//         CircleAvatar(
//           radius: 40.0,
//           backgroundColor: Colors.blue,
//           child: Text(
//             '${model['time']}',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         SizedBox(width: 20.0),
//         Expanded(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '${model['title']}',
//                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//               ),
//               Text('${model['date']}', style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ),
//         SizedBox(width: 20.0),
//         IconButton(
//           onPressed: () {
//             AppCubit.get(context).updateData(status: 'done', id: model['id']);
//           },
//           icon: Icon(Icons.check_box, color: Colors.green),
//         ),
//         IconButton(
//           onPressed: () {
//             AppCubit.get(
//               context,
//             ).updateData(status: 'archive', id: model['id']);
//           },
//           icon: Icon(Icons.archive, color: Colors.black45),
//         ),
//       ],
//     ),
//   ),
//   onDismissed: (direction) {
//     AppCubit.get(context).deleteData(id: model['id']);
//   },
// );

// Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
//   condition: tasks.length > 0,
//   builder:
//       (context) => ListView.separated(
//         itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
//         separatorBuilder: (context, index) => myDivider(),
//         itemCount: tasks.length,
//       ),
//   fallback:
//       (context) => Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.menu, size: 100.0, color: Colors.grey),
//             SizedBox(height: 10.0),
//             Text(
//               'No Tasks Yet, Please Add Some Tasks',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
// );

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 20.0),
  child: Container(
    width: double.infinity,
    height: 2.0,
    color: Colors.grey[300],
  ),
);

// Widget buildArticleItem(article, context) => InkWell(
//   onTap: () {
//     navigateTo(context, WebViewScreen(article['url']));
//   },
//   child: Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Row(
//       children: [
//         Container(
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             image: DecorationImage(
//               image: NetworkImage(
//                 '${article['urlToImage']}',
//               ), // Replace with your image URL
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         SizedBox(width: 20),
//         Expanded(
//           child: Container(
//             height: 120,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     '${article['title']}',
//                     style: Theme.of(context).textTheme.bodyLarge,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '${article['publishedAt']}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );

// Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
//   condition: list.length > 0,
//   builder:
//       (context) => ListView.separated(
//         physics: BouncingScrollPhysics(),
//         itemBuilder: (context, index) => buildArticleItem(list[index], context),
//         separatorBuilder: (context, index) => myDivider(),
//         itemCount: 10,
//       ),
//   fallback:
//       (context) =>
//           isSearch
//               ? Container()
//               : Center(
//                 child: CircularProgressIndicator(color: Colors.deepOrange),
//               ),
// );

Future<dynamic> navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
