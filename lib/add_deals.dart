// import 'package:flutter/material.dart';
// import 'package:store_dashboard/controller/admin/admin_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SearchAndAddDealsPage extends StatefulWidget {
//   const SearchAndAddDealsPage({super.key});

//   @override
//   State<SearchAndAddDealsPage> createState() => _SearchAndAddDealsPageState();
// }

// class _SearchAndAddDealsPageState extends State<SearchAndAddDealsPage> {
//  TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     // First, listen to the current user's document to obtain your blocked list.
//     return StreamBuilder(
//       stream: Supabase.instance.client.from('products').asStream(),
//       builder: (context, AsyncSnapshot currentSnapshot) {
//         if (!currentSnapshot.hasData) {
//           return Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
                 

//         return Scaffold(
//           appBar: AppBar(
//             surfaceTintColor: Colors.white,
//             leading: SizedBox(), // Empty widget to balance the right action.
//             centerTitle: true,
//             title: Text(
//               'Add Deal',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(200, 9, 64, 126),
//               ),
//             ),
//           ),
//           body: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       _searchQuery = value.trim();
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Search',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: _searchQuery.isNotEmpty
//                     ? buildProductList(myBlockedList)
//                     : Center(child: Text('Start typing to search.')),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget buildProductList(List<dynamic> myBlockedList) {
//     final lowerCaseQuery = _searchQuery.toLowerCase();
//     return StreamBuilder(
//       stream: Supabase.instance.client.from('products').asStream(),
//       builder: (context, AsyncSnapshot snapshot) {
//         // Loading and error handling.
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(child: Text('No Product found.'));
//         }

//         // Filter the users.
//         final filterdProduct = snapshot.data!.docs.where((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           final title = data['title'].toString().toLowerCase();
//           bool matchesQuery = _searchQuery.startsWith('')
//               ? handler.contains(lowerCaseQuery.substring(1))
//               : title.contains(lowerCaseQuery) ||
//                   handler.contains(lowerCaseQuery);

//           // Exclude if this user has blocked the current user.
//           /*  List<dynamic> theirBlockedList = data['blockedUsers'] ?? [];
//           bool hasBlockedCurrent = theirBlockedList.contains(userId);*/

//           // Removed exclusion for users blocked by you:
//           // bool iBlockedUser = myBlockedList.contains(data['userId']);

//           // Now only filter out those who have blocked you.
//           return matchesQuery; //!hasBlockedCurrent;
//         }).toList();

//         if (filteredUsers.isEmpty) {
//           return Center(child: Text('No users found.'));
//         }

//         // Build a ListView with the filtered results.
//         return ListView.builder(
//           itemCount: filteredUsers.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot userDoc = filteredUsers[index];
//             final data = userDoc.data() as Map<String, dynamic>;
//             final username = data['username'].toString();

//             // Optional: Add an indicator if this user is blocked by you.
//             bool isBlocked = myBlockedList.contains(data['userId']);

//             return InkWell(
//               onTap: () {
//                 if (data['userId'] == userId) {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => ProfileXScreen()),
//                   );
//                 } else {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => ProfileMemberScreen(
//                         userMemberId: data['userId'],
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: (data['imageProfail'] == null ||
//                           data['imageProfail'].isEmpty)
//                       ? AssetImage('lib/assest/photo/user.jpg')
//                       : NetworkImage(data['imageProfail']) as ImageProvider,
//                 ),
//                 title: Text(username),
//                 subtitle: Row(
//                   children: [
//                     Text('@${data['handler']}'),
//                     if (isBlocked)
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           'Blocked',
//                           style: TextStyle(color: Colors.red, fontSize: 12),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }