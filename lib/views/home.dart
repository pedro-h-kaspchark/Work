import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/services/authService.dart';
import 'package:fluttertest/services/firebaseService.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _dateOfIssueController = TextEditingController();
  final _deadlineController = TextEditingController();
  Firebaseservice _firebaseservice = Firebaseservice();

  void _openModalForm({String? docId}) async {
    if (docId == null) {
      _nameController.clear();
      _valueController.clear();
      _dateOfIssueController.clear();
      _deadlineController.clear();
    } else {
      DocumentSnapshot document = await _firebaseservice.getTicket(docId);
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      _nameController.text = data["name"];
      _valueController.text = data["value"];
      _dateOfIssueController.text = data["dateOfIssue"];
      _deadlineController.text = data["deadline"];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            docId == null ? "Adicionar Tarefa" : "Editar Tarefa",
            style: TextStyle(fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _valueController,
                  decoration: InputDecoration(
                    labelText: "Valor",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dateOfIssueController,
                  decoration: InputDecoration(
                    labelText: "Data de Emissão",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _deadlineController,
                  decoration: InputDecoration(
                    labelText: "Prazo",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (docId == null) {
                  _firebaseservice.addTicket(
                    _nameController.text,
                    _valueController.text,
                    _dateOfIssueController.text,
                    _deadlineController.text,
                  );
                } else {
                  _firebaseservice.updateTask(
                    docId,
                    _nameController.text,
                    _valueController.text,
                    _dateOfIssueController.text,
                    _deadlineController.text,
                  );
                }

                _nameController.clear();
                _valueController.clear();
                _dateOfIssueController.clear();
                _deadlineController.clear();

                Navigator.of(context).pop();
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Tela Inicial',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              accountName: Text(
                widget.user.displayName ?? "Não informado",
                style: TextStyle(fontSize: 24),
              ),
              accountEmail: Text(widget.user.email ?? "Não informado"),
            ),
            ListTile(
              title: Text(
                'Sair',
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                AuthService().logoutUser();
              },
              leading: Icon(
                Icons.exit_to_app,
                size: 28,
              ),
            ),
            Divider(
              thickness: 2,
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseservice.getCarsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List taskList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = taskList[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String docId = document.id;
                  String taskName = data["name"];
                  String taskValue = data["value"];

                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: ListTile(
                      title: Text(taskName),
                      subtitle: Text("Valor: $taskValue"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // Alterna a cor de fundo dos itens com base no índice
                      tileColor: index % 2 == 0
                          ? Colors.grey[200] // cor para itens pares
                          : Colors.grey[350], // cor para itens ímpares
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _openModalForm(docId: docId);
                            },
                            icon: Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () {
                              _firebaseservice.deleteTask(docId);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openModalForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
