import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isSearching = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    saveUserData();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
      searchQuery = "";
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    String userId = _auth.currentUser!.uid;

    if (searchQuery.isNotEmpty) {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .where('content', isGreaterThanOrEqualTo: searchQuery)
          .where('content', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .orderBy('content')
          .snapshots();
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> saveUserData() async {
    String userId = _auth.currentUser!.uid;
    String email = _auth.currentUser!.email!;

    await _firestore.collection('users').doc(userId).set({
      'email': email,
    }, SetOptions(merge: true));
  }

  Future<void> addNote() async {
    if (_noteController.text.isNotEmpty) {
      String userId = _auth.currentUser!.uid;
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('notes')
            .add({
          'content': _noteController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _noteController.clear();
        print('Note added successfully');
      } catch (e) {
        print('Error adding note: $e');
      }
    }
  }

  Future<void> deleteNoteAtIndex(String noteId) async {
    String userId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
    print('Note deleted: $noteId');
  }

  void showDeleteConfirmationDialog(String noteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text(
              'Are you sure you want to delete this note? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteNoteAtIndex(noteId);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('Notes')
            : TextField(
                controller: _searchController,
                onChanged: updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          isSearching
              ? IconButton(
                  onPressed: stopSearch,
                  icon: Icon(Icons.clear),
                )
              : IconButton(
                  onPressed: startSearch,
                  icon: Icon(Icons.search),
                ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getNotesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No notes found.'));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot note = snapshot.data!.docs[index];
                    String noteId = note.id;
                    String content = note['content'];

                    return Card(
                      child: ListTile(
                        title: Text(
                          content,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          note['timestamp'] != null
                              ? (note['timestamp'] as Timestamp)
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                              : '',
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteConfirmationDialog(noteId),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add New Note'),
                content: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(hintText: 'Enter your note'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addNote();
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.note_add),
      ),
    );
  }
}
