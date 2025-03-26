// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
// import 'package:provider/provider.dart';
//
// class SubCategoryServices extends StatefulWidget {
//   const SubCategoryServices({super.key});
//   static const String routeName = 'sub_category_services';
//
//   @override
//   State<SubCategoryServices> createState() => _SubCategoryServicesState();
// }
//
// class _SubCategoryServicesState extends State<SubCategoryServices> {
//   late String category;
//   late AddNewServiceProvider provider;
//   bool callOnce = true;
//
//   @override
//   void didChangeDependencies() {
//     final Map<String, dynamic>? queryParams =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
//     category = queryParams?['name'];
//     print(category);
//
//     Future.delayed(Duration.zero, () {
//       if (callOnce) {
//         provider = Provider.of(context, listen: false);
//         provider.getSubCategoryOrServices(category);
//         callOnce = false;
//       }
//     });
//
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category ?? ''),
//       ),
//       body: Consumer<AddNewServiceProvider>(
//         builder: (context, provider, _) {
//           if (provider.subCatgoryList.isNotEmpty) {
//             return ListView.builder(
//               itemCount: provider.subCatgoryList.length,
//               itemBuilder: (context, index) => InkWell(
//                 onTap: () {
//                   print(provider.subCatgoryList[index].title);
//                   provider.getSubCategoryOrServices(
//                       provider.subCatgoryList[index].textId ?? '');
//                 },
//                 child: Card(
//                   color: Colors.green.shade400,
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           provider.subCatgoryList[index].title ?? '',
//                           style: const TextStyle(fontSize: 24),
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: Html(
//                             data: provider.subCatgoryList[index].details ?? '',
//                             shrinkWrap: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return const Center(
//               child: Text('No Items'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
