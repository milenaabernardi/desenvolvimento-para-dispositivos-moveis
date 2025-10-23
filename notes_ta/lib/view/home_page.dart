import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_ta/service/notes_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotesService notesService = NotesService();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID, String? note}) {
    textController.text = note ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                notesService.create(textController.text);
              } else {
                notesService.update(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Adicionar" : "Salvar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notas")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notesService.read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = noteList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => openNoteBox(docID: docID, note: noteText),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => notesService.delete(docID),
                        icon: const Icon(Icons.delete), 
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text("Sem notas...");
          }
        },
      ),
    );
  }
}