import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite_example_app/presentation/screens/compose_view.dart';

import '../../data/db/db_helper.dart';
import '../../data/models/person_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper _dbHelper;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    _dbHelper = DBHelper('db.sqlite');
    _dbHelper.open();
    super.initState();
  }

  @override
  void dispose() {
    _dbHelper.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orangeAccent.shade200,
        title: const Text('Home'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: NeverScrollableScrollPhysics()),
          child: Column(
            children: [
              ComposeView(
                onCompose: ((firstName, lastName) {
                  _dbHelper.create(firstName, lastName);
                  log('$firstName $lastName');
                }),
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: _dbHelper.exposeStream(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final people = snapshot.data as List<Person>;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: people.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final person = people[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 3),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: Colors.grey.shade200,
                            title: Text(
                              person.fullName.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text('ID: ${person.id.toString()}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                _dbHelper.delete(person);
                              },
                            ),
                            onTap: () async {
                              final editedData =
                                  await showUpdateDialog(context, person);
                              if (editedData != null) {
                                _dbHelper.update(editedData);
                              }
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No data'),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Update dialog
  Future<Person> showUpdateDialog(BuildContext context, Person person) {
    _firstNameController.text = person.firstName;
    _lastNameController.text = person.lastName;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Enter your updated values here',
              style: TextStyle(fontSize: 15),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red)),
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Last Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red)),
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Last Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.green.shade200,
                      child: const Text('Update'),
                      onPressed: () {
                        final editedData = Person(
                          id: person.id,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                        );
                        Navigator.of(context).pop(editedData);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey.shade200,
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value is Person) {
        return value;
      } else {
        return person;
      }
    });
  }
}
