// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
//
// class SihilluatteView extends StatefulWidget {
//   final Map<dynamic, dynamic>? data;
//   final void Function(List<Map<String, dynamic>>)? onDataReceived;
//
//   const SihilluatteView({
//     super.key,
//     this.data,
//     this.onDataReceived,
//   });
//
//   @override
//   SihilluatteViewState createState() => SihilluatteViewState();
// }
//
// class SihilluatteViewState extends State<SihilluatteView> {
//   List<Map<String, dynamic>> images = [];
//   String selectedArea = '';
//   List<Map<String, dynamic>> interactions = [];
//   List<String> unmarkedAreas = [];
//   bool isSaved = false;
//
//   void _removeLastInteraction(String path) {
//     setState(() {
//       final markedList = interactions
//           .where((interaction) => interaction['imagePath'] == path)
//           .toList();
//
//       if (markedList.isNotEmpty) {
//         interactions.removeLast();
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Context-dependent initialization
//     _initializeData();
//   }
//   void _initializeData() {
//     setState(() {
//       images = _parseImageData(widget.data!['data']);
//     });
//   }
//
//   List<Map<String, dynamic>> _parseImageData(List<dynamic> data) {
//     return data.map((imageData) {
//       final frontImage = imageData['frontImage'] as Map<String, dynamic>;
//       final backImage = imageData['backImage'] as Map<String, dynamic>;
//       final frontRegions = frontImage['regions'] as List<dynamic>;
//       final backRegions = backImage['regions'] as List<dynamic>;
//
//       return {
//         'frontImagePath': frontImage['image'] as String,
//         'backImagePath': backImage['image'] as String,
//         'frontPolygons': frontRegions.map((region) {
//           final regionMap = region as Map<String, dynamic>;
//           return PolygonArea(
//             id: regionMap['region'] as String,
//             points: (regionMap['shape'] as List<dynamic>).map((point) {
//               final coords = (point as String)
//                   .split(',')
//                   .map((coord) => double.parse(coord.trim()))
//                   .toList();
//               return Offset(coords[0], coords[1]);
//             }).toList(),
//             color: Theme.of(context).colorScheme.primary,
//             operations: (regionMap['operations'] as List<dynamic>)
//                 .map((operation) => operation as Map<String, dynamic>)
//                 .toList(),
//           );
//         }).toList(),
//         'backPolygons': backRegions.map((region) {
//           final regionMap = region as Map<String, dynamic>;
//           return PolygonArea(
//             id: regionMap['region'] as String,
//             points: (regionMap['shape'] as List<dynamic>).map((point) {
//               final coords = (point as String)
//                   .split(',')
//                   .map((coord) => double.parse(coord.trim()))
//                   .toList();
//               return Offset(coords[0], coords[1]);
//             }).toList(),
//             color: Theme.of(context).colorScheme.primary,
//             operations: (regionMap['operations'] as List<dynamic>)
//                 .map((operation) => operation as Map<String, dynamic>)
//                 .toList(),
//           );
//         }).toList(),
//       };
//     }).toList();
//   }
//
//   void _selectArea(
//       String areaId, int imageIndex, Offset localPosition, bool isFrontImage) {
//     setState(() {
//       selectedArea = areaId;
//     });
//
//     double x = localPosition.dx;
//     double y = localPosition.dy;
//     String pos = "${x.toInt()},${y.toInt()}";
//     final imageData = images[imageIndex];
//     final frontPolygons = imageData['frontPolygons'] as List<PolygonArea>;
//     final backPolygons = imageData['backPolygons'] as List<PolygonArea>;
//     final polygons = [...frontPolygons, ...backPolygons];
//     final selectedPolygon = polygons.firstWhere((area) => area.id == areaId);
//     String imagePath = isFrontImage ? "frontImage" : "backImage";
//     var interaction = {
//       'areaId': areaId,
//       'imageIndex': imageIndex,
//       'imagePath': imagePath,
//       'clickPosition': pos,
//       'markedOperations': [],
//     };
//
//     _selectOperationsAndIssues(interaction, selectedPolygon);
//   }
//
//   void _selectOperationsAndIssues(
//       Map<String, dynamic> interaction, PolygonArea polygon) {
//     RxList<String> selectedOperations = <String>[].obs;
//     RxMap<String, List<Map<String, dynamic>>> selectedIssues =
//         <String, List<Map<String, dynamic>>>{}.obs;
//
//     Rx<String?> selectedOperationName = Rx<String?>(null);
//     RxBool allowNextOperationSelection = true.obs;
//     Get.dialog(
//       AlertDialog(
//         title: const Text(
//           'Select Operations and Issues',
//           style: TextStyle(fontSize: 28.0),
//         ),
//         content: SizedBox(
//           width: Get.width,
//           height: Get.height,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Scrollbar(
//                   thumbVisibility: true,
//                   child: ListView(
//                     children: polygon.operations.map((operation) {
//                       String operationName = operation['operationName'] ?? '';
//                       RxBool isOperationChecked =
//                           selectedOperations
//                               .contains(operationName)
//                               .obs;
//
//                       return Obx(() {
//                         return CheckboxListTile(
//                           title: Text(
//                             operationName,
//                             style: const TextStyle(fontSize: 25.0),
//                           ),
//                           value: isOperationChecked.value,
//                           onChanged: allowNextOperationSelection.value ||
//                               isOperationChecked.value
//                               ? (bool? newValue) {
//                             if (newValue != null) {
//                               isOperationChecked.value = newValue;
//                               if (!newValue) {
//                                 allowNextOperationSelection.value = true;
//                                 selectedOperations.remove(operationName);
//                                 selectedIssues.remove(operationName);
//                               } else {
//                                 selectedOperations.add(operationName);
//                                 selectedIssues[operationName] = [];
//                                 selectedOperationName.value = operationName;
//                                 allowNextOperationSelection.value = false;
//                               }
//                             }
//                           }
//                               : null,
//                           controlAffinity: ListTileControlAffinity.leading,
//                         );
//                       });
//                     }).toList(),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Scrollbar(
//                   thumbVisibility: true,
//                   child: Obx(() {
//                     if (selectedOperationName.value != null) {
//                       var operation = polygon.operations.firstWhere((op) =>
//                       op['operationName'] == selectedOperationName.value);
//                       List<Map<String, dynamic>> issues = List<Map<
//                           String,
//                           dynamic>>.from(
//                           operation['issues'] as List<dynamic>);
//
//                       return ListView(
//                         children: [
//                           Wrap(
//                             spacing: 8.0,
//                             runSpacing: 4.0,
//                             children: issues.map((issue) {
//                               RxBool isIssueChecked = (selectedIssues[
//                               selectedOperationName.value!]
//                                   ?.contains(issue) ??
//                                   false)
//                                   .obs;
//
//                               return Obx(() {
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: ChoiceChip(
//                                     label: Text(
//                                       issue['catalogItemDescription'],
//                                       style: const TextStyle(fontSize: 25.0),
//                                     ),
//                                     selected: isIssueChecked.value,
//                                     onSelected: (bool selected) {
//                                       isIssueChecked.value = selected;
//                                       if (selected) {
//                                         selectedIssues[selectedOperationName
//                                             .value!]
//                                             ?.add(issue);
//                                       } else {
//                                         selectedIssues[selectedOperationName
//                                             .value!]
//                                             ?.remove(issue);
//                                       }
//
//                                       if (selectedIssues[
//                                       selectedOperationName.value!]!
//                                           .isNotEmpty) {
//                                         allowNextOperationSelection.value =
//                                         true;
//                                       } else {
//                                         allowNextOperationSelection.value =
//                                         false;
//                                       }
//                                     },
//                                   ),
//                                 );
//                               });
//                             }).toList(),
//                           ),
//                         ],
//                       );
//                     } else {
//                       return const Center(
//                         child: Text(
//                           'Select an operation to view issues',
//                           style: TextStyle(fontSize: 25.0),
//                         ),
//                       );
//                     }
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (selectedOperations.isEmpty ||
//                   selectedIssues.values.any((issues) => issues.isEmpty)) {
//                 Get.snackbar(
//                   'Error',
//                   'Please select at least one issue for each selected operation.',
//                   backgroundColor: Get.theme.colorScheme.primary,
//                   colorText: Colors.white,
//                 );
//                 return;
//               }
//
//               for (var operationName in selectedOperations) {
//                 var markedOperation = {
//                   'operationName': operationName,
//                   'issues': selectedIssues[operationName],
//                 };
//                 interaction['markedOperations'] ??= [];
//                 interaction['markedOperations']
//                     .removeWhere((op) => op['operationName'] == operationName);
//                 interaction['markedOperations'].add(markedOperation);
//               }
//
//               _saveInteraction(interaction);
//
//               _updateUnmarkedAreas();
//
//               Get.back();
//             },
//             child: const Text(
//               'Save',
//               style: TextStyle(fontSize: 23.0),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               _updateUnmarkedAreas(); // Close dialog
//             },
//             child: const Text(
//               'Cancel',
//               style: TextStyle(fontSize: 23.0),
//             ),
//           ),
//         ],
//       ),
//     );
//
//   }
//
//   void _saveInteraction(Map<String, dynamic> interaction) {
//     setState(() {
//
//       interactions.add(interaction);
//       if (widget.onDataReceived != null) {
//         widget.onDataReceived!(interactions);
//       }
//       _updateUnmarkedAreas();
//     });
//   }
//
//   void _updateUnmarkedAreas() {
//     setState(() {
//       unmarkedAreas.clear();
//
//       for (var imageData in images) {
//         final frontPolygons = imageData['frontPolygons'] as List<PolygonArea>;
//         final backPolygons = imageData['backPolygons'] as List<PolygonArea>;
//         final polygons = [...frontPolygons, ...backPolygons];
//
//         for (var polygon in polygons) {
//           final areaId = polygon.id;
//           final isMarked = interactions
//               .any((interaction) => interaction['areaId'] == areaId);
//           if (!isMarked) {
//             unmarkedAreas.add(areaId);
//           }
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (images.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return Expanded(
//       child: PageView.builder(
//         itemCount: images.length,
//         itemBuilder: (context, index) {
//           final image = images[index];
//           final frontImagePath = image['frontImagePath'] as String;
//           final backImagePath = image['backImagePath'] as String;
//           final frontPolygons = image['frontPolygons'] as List<PolygonArea>;
//           final backPolygons = image['backPolygons'] as List<PolygonArea>;
//
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//
//               Expanded(
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         SvgPicture.network(frontImagePath,width: 300,height: 400,),
//                         Positioned.fill(
//                           child: LayoutBuilder(
//                             builder: (context, constraints) {
//                               return GestureDetector(
//                                 onTapUp: (details) {
//                                   for (var area in frontPolygons) {
//                                     final localPosition = details.localPosition;
//                                     if (_isPointInPolygon(
//                                         localPosition, area.points)) {
//                                       _selectArea(
//                                           area.id, index, localPosition, true);
//                                       break;
//                                     }
//                                   }
//                                 },
//                                 child: CustomPaint(
//
//                                   painter: PolygonPainter(
//                                       frontPolygons, interactions, true, index),
//                                   size: const Size(300,
//                                       400),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: FilledButton(
//                         onPressed: () {
//                           setState(() {
//                             _removeLastInteraction('frontImage');
//                           });
//                         },
//                         child: const Text('Undo'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Expanded(
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         SvgPicture.network(backImagePath,width: 300,height: 400,),
//                         Positioned.fill(
//                           child: LayoutBuilder(
//                             builder: (context, constraints) {
//                               return GestureDetector(
//                                 onTapUp: (details) {
//                                   for (var area in backPolygons) {
//                                     final localPosition = details.localPosition;
//                                     if (_isPointInPolygon(
//                                         localPosition, area.points)) {
//                                       _selectArea(
//                                           area.id, index, localPosition, false);
//                                       break;
//                                     }
//                                   }
//                                 },
//                                 child: CustomPaint(
//                                   painter: PolygonPainter(
//                                       backPolygons, interactions, false, index),
//                                   size: const Size(300,
//                                       400),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: FilledButton(
//                         onPressed: () {
//                           setState(() {
//                           _removeLastInteraction('backImage');
//                             }
//                           );
//                         },
//                         child: const Text('Undo'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   bool _isPointInPolygon(Offset point, List<Offset> polygonPoints) {
//
//     bool isInside = false;
//     int n = polygonPoints.length;
//
//     for (int i = 0, j = n - 1; i < n; j = i++) {
//       if (((polygonPoints[i].dy > point.dy) !=
//           (polygonPoints[j].dy > point.dy)) &&
//           (point.dx <
//               (polygonPoints[j].dx - polygonPoints[i].dx) *
//                   (point.dy - polygonPoints[i].dy) /
//                   (polygonPoints[j].dy - polygonPoints[i].dy) +
//                   polygonPoints[i].dx)) {
//         isInside = !isInside;
//       }
//     }
//
//     return isInside;
//   }
// }
//
// class PolygonArea {
//   final String id;
//   final List<Offset> points;
//   final Color color;
//   final List<Map<String, dynamic>> operations;
//
//   PolygonArea({
//     required this.id,
//     required this.points,
//     required this.color,
//     required this.operations,
//   });
// }
//
// class PolygonPainter extends CustomPainter {
//   final List<PolygonArea> polygons;
//   final List<Map<String, dynamic>> interactions;
//   final bool isFrontImage;
//   final int imageIndex;
//
//   PolygonPainter(
//       this.polygons, this.interactions, this.isFrontImage, this.imageIndex);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 2.0;
//
//     for (var polygon in polygons) {
//       paint.color = polygon.color.withOpacity(0.5);
//       final path = Path()..addPolygon(polygon.points, true);
//       canvas.drawPath(path, paint);
//     }
//
//     for (var interaction in interactions) {
//       if (interaction['imageIndex'] == imageIndex &&
//           ((isFrontImage && interaction['imagePath'] == "frontImage") ||
//               (!isFrontImage && interaction['imagePath'] == "backImage"))) {
//         final clickPosition = interaction['clickPosition'];
//         final pos = clickPosition.split(',');
//         double x = double.parse(pos[0]);
//         double y = double.parse(pos[1]);
//
//         // Draw a red dot
//         canvas.drawCircle(Offset(x, y), 10.0, Paint()..color = Colors.red.withOpacity(0.4));
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
