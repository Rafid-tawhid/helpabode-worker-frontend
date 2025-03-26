// import 'package:flutter/material.dart';
// import 'package:help_abode_worker_app_ver_2/models/new_requested_pricing_attribute_model.dart';
//
// class NewRequestedPricingData extends StatelessWidget {
//   final PlanArrayReq dataList;
//
//
//   NewRequestedPricingData({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<AttributesReq> dataPricing=[];
//     dataList.attributes!.forEach((e){
//       if(e.isPricing=='Yes'){
//         dataPricing.add(e);
//       }
//     });
//     return DraggableScrollableSheet(
//
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Price Configuration",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 Divider(),
//                 // Attributes List
//                 Expanded(
//                   child: ListView.builder(
//                     controller: scrollController,
//                     itemCount: dataPricing.length,
//                     itemBuilder: (context, index) {
//                       final attribute = dataPricing[index];
//                       return Card(
//                         elevation: 2,
//                         color: Colors.white,
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Attribute Title
//                               Row(
//                                 children: [
//                                   Icon(Icons.category, color: Colors.green),
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       attribute.title ?? '',
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               // Options
//                               ...attribute.options!.map((option) =>
//                                   Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.check_circle, color: Colors.blueAccent, size: 18),
//                                       SizedBox(width: 8),
//                                       Expanded(
//                                         child: Text(
//                                           option.optionLabel ?? '',
//                                           style: TextStyle(fontSize: 14),
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         "\$${option.price}",
//                                         style: TextStyle(fontSize: 14, color: Colors.green),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         "${option.estTime} mins",
//                                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
