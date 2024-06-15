import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorsList extends StatefulWidget {
  const DoctorsList({Key? key}) : super(key: key);

  @override
  State<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  final TextEditingController _textController = TextEditingController();
  late String search;
  var _length = 0;

  @override
  void initState() {
    super.initState();
    search = '';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Find Doctors'),
        actions: <Widget>[
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Search Doctor',
                  hintStyle: GoogleFonts.lato(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  suffixIcon: _textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                              search = '';
                              _length = 0;
                            });
                          },
                        )
                      : const SizedBox(),
                ),
                onChanged: (String searchKey) {
                  setState(() {
                    search = searchKey;
                    _length = searchKey.length;
                  });
                },
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textInputAction: TextInputAction.search,
                autofocus: false,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: _length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _length = 1;
                        });
                      },
                      child: Text(
                        'Show All',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Image(image: AssetImage('assets/search-bg.png')),
                  ],
                ),
              )
            : DoctorsListView(
                searchKey: search,
              ),
      ),
    );
  }
}

class DoctorsListView extends StatelessWidget {
  final String searchKey;

  const DoctorsListView({Key? key, required this.searchKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: (searchKey.isEmpty)
          ? FirebaseFirestore.instance.collection('doctor').snapshots() // Ajuste aquí
          : FirebaseFirestore.instance
              .collection('doctor') // Ajuste aquí
              .where('name', isGreaterThanOrEqualTo: searchKey)
              .where('name', isLessThanOrEqualTo: searchKey + '\uf8ff')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No doctors found'));
        }

        // Debug print to check the number of doctors found
        debugPrint('Doctors found: ${snapshot.data!.docs.length}');

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: (data['profilePhoto'] != null && data['profilePhoto'].isNotEmpty)
                    ? NetworkImage(data['profilePhoto'])
                    : const AssetImage('assets/person.jpg') as ImageProvider,
              ),
              title: Text(data['name'] ?? 'No Name'),
              subtitle: Text(data['specialization'] ?? 'No Specialization'),
              trailing: Text(data['rating']?.toString() ?? 'No Rating'),
            );
          }).toList(),
        );
      },
    );
  }
}
