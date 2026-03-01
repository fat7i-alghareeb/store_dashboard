// import 'package:flutter/material.dart';
// import 'package:store_dashboard/add_deals.dart';
// import 'package:store_dashboard/controller/admin/admin_bloc.dart';

// class DealsManagerScreen extends StatefulWidget {
//   const DealsManagerScreen({super.key});

//   @override
//   State<DealsManagerScreen> createState() => _DealsManagerScreenState();
// }

// class _DealsManagerScreenState extends State<DealsManagerScreen> {
 

  

//   void _goToAddDealsPage() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder:(context) => SearchAndAddDealsPage(), ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AdminBloc.fetchDeals(),
//       builder: (context, snapshot) {
//         if(!snapshot.hasData){
//           return Center(child: CircularProgressIndicator());
//         }

//         return ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             ElevatedButton.icon(
//               icon: const Icon(Icons.add),
//               label: const Text('Go to Add Deals'),
//               onPressed: _goToAddDealsPage,
//             ),
//             const SizedBox(height: 20),
//             const Text("Deals List", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             ...snapshot.data!.asMap().entries.map((entry) {
//               final index = entry.key;
//               final product = entry.value;
//               return Card(
//                 child: ListTile(
//                   leading:CircleAvatar(
//                     child: Image.network(product['image_url']),
//                   ),
//                   title: Text(product['title']),
//                   subtitle: Text('${product['category']} - \$${product['price']}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.orange),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {}
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//         );
//       }
//     );
//   }
// }