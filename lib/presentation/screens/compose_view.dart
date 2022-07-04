import 'package:flutter/material.dart';

typedef OnCompose = void Function(String firstName, String lastName);

class ComposeView extends StatefulWidget {
  final OnCompose onCompose;
  const ComposeView({Key key, this.onCompose}) : super(key: key);

  @override
  State<ComposeView> createState() => _ComposeViewState();
}

class _ComposeViewState extends State<ComposeView> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                hintText: 'First Name',
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
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              validator: (val) {
                if (val.isEmpty) {
                  return 'First Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: lastNameController,
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
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Last Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.orange.shade200,
                onPressed: () {
                  if (_formKey.currentState.validate() &&
                      firstNameController.text.isNotEmpty &&
                      lastNameController.text.isNotEmpty) {
                    final firstName = firstNameController.text.trim();
                    final lastName = lastNameController.text.trim();
                    widget.onCompose(firstName, lastName);
                    firstNameController.clear();
                    lastNameController.clear();
                  }
                },
                child: const Text(
                  'Save',
                  textScaleFactor: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
