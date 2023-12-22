import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kayla/screen/userstudentdetails.dart';
import 'package:kayla/util/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.uid});
  final String uid;
  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController SearchEditingController = TextEditingController();
int _minValue = 18;
int _maxValue = 50;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusNode currentfocus = FocusScope.of(context);
        if (!currentfocus.hasPrimaryFocus) {
          currentfocus.unfocus();
        }
      },
      child: Scaffold(
        body: Column(children: [
          Container(
            width: size.width,
            height: (size.height / 2) / 2 - 80,
            color: const Color(0XFF188F79),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 20),
                  child: SizedBox(
                    width: size.width / 1.4,
                    child: TextFormField(
                      controller: SearchEditingController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          label: Text("Search"),
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () => alertLogout(context),
                          icon: const Icon(
                            Icons.logout_outlined,
                            size: 30,
                            color: Colors.white,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Selected Range: ${_minValue.toStringAsFixed(0)} - ${_maxValue.toStringAsFixed(0)}'),
              RangeSlider(
                activeColor: const Color(0XFF188F79),
                values: RangeValues(_minValue.toDouble(), _maxValue.toDouble()),
                onChanged: (RangeValues values) {
                  setState(() {
                    _minValue = values.start.toInt();
                    _maxValue = values.end.toInt();
                  });
                },
                min: 0,
                max: 50,
                divisions: 50,
                labels: RangeLabels(
                  _minValue.round().toString(),
                  _maxValue.round().toString(),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(widget.uid)
                .collection('studentdatacollection')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else {
                var documents = snapshot.data!.docs;
                var filteredDocuments = documents
                    .where((document) =>
                        document['name'].toLowerCase().contains(
                            SearchEditingController.text.toLowerCase()) &&
                        document['age'] >= _minValue &&
                        document['age'] <= _maxValue)
                    .toList();

                return Expanded(
                  child: filteredDocuments.isNotEmpty
                      ? ListView.separated(
                          itemCount: filteredDocuments.length,
                          itemBuilder: (context, index) {
                            var documentData = filteredDocuments[index].data()
                                as Map<String, dynamic>;
                            var studentName = documentData['name'];
                            var studentAge = documentData['age'];
                            var studentImage = documentData['imageurl'];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(studentImage),
                              ),
                              title: Text(studentName),
                              subtitle: Text('Age: $studentAge'),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 7),
                        )
                      : const Center(
                          child: Text("Students Details not found"),
                        ),
                );
              }
            },
          )
        ]),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0XFF188F79),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StudentDetailsPage(),
              ));
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Student'),
          ),
        ),
      ),
    );
  }
}
