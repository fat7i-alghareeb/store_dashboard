// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// class ImagePicker extends StatefulWidget {
//   final Function(File?) onImageSelected;
//   ImagePicker({required this.onImageSelected});
//   @override
//   _ImagePickerState createState() => _ImagePickerState();
// }

// class _ImagePickerState extends State<ImagePicker> {
//   File? _imageFile;

//   void _pickImage() async {
//   final result = await FilePicker.platform.pickFiles(type: FileType.image,);
//   if (result != null && result.files.single.path != null) {
//     final file = File(result.files.single.path!);

//     setState(() {
//       _imageFile = file;
//     });

//     widget.onImageSelected(file); // you can also pass `fileName` if needed
//   }
// }

// void _deleteImage() {
//   setState(() {
//     _imageFile = null;
//   });
//   widget.onImageSelected(null); // Clear selection
// }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         children: [
//           Container(
//             width: 350,
//             height: 250,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey.shade100,
//             ),
//             child: _imageFile == null
//                 ? Center(
//                     child: ElevatedButton(
//                       onPressed: _pickImage,
//                       child: Text('Pick Image'),
//                     ),
//                   )
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.file(
//                       _imageFile!,
//                       fit: BoxFit.fill,
//                       width: 350,
//                       height: 250,
//                     ),
//                   ),
//           ),
//           if (_imageFile != null)
//             Positioned(
//               top: 8,
//               right: 8,
//               child: CircleAvatar(
//                 backgroundColor: Colors.black54,
//                 child: IconButton(
//                   icon: Icon(Icons.delete, color: Colors.white),
//                   onPressed: _deleteImage,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
