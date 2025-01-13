import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silluatte/sihilluatte.dart';


import 'main_view/api_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> markedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sihilluatte View"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: ApiService.fetchImageData() ,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No data available');
                } else {
                  // return SihilluatteView(
                  //   data: snapshot.data!,
                  //   onDataReceived: (data) {
                  //
                  //       markedList = data;
                  //
                  //   },
                  // );
                  return SihilluatteView(
                    data: snapshot.data!,
                    onDataReceived: (data) {
                      markedList = data;
                    },
                  );
                }
              },
            ),
            FilledButton(
              onPressed: () {
                if (markedList.isNotEmpty) {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Marked List'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: markedList.length,
                          itemBuilder: (context, index) {
                            final interaction = markedList[index];
                            return ListTile(
                              title: Text('Area ID: ${interaction['areaId']}'),
                              subtitle: Text('Operations: ${interaction['markedOperations']} coordination: ${interaction['clickPosition']}'),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'No marked list available.',
                    backgroundColor: Get.theme.colorScheme.primary,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text("Submit"),
            ),

          ],
        ),
      ),
    );
  }
}
