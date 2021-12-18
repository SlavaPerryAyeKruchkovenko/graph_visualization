import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogForm extends StatefulWidget {
  const DialogForm({
    Key? key,
  }) : super(key: key);
  @override
  State<DialogForm> createState() => _DialogForm();
}

class _DialogForm extends State<DialogForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController valueOfEdge = TextEditingController();
  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      this.dispose();
    } else {
      debugPrint('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        color: Colors.purple.withOpacity(0.6),
        width: 400,
        height: 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                "Input value of Edge",
                style: TextStyle(
                    fontSize: 24, color: Colors.white.withOpacity(0.8)),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Theme(
                    data: ThemeData(
                      primarySwatch: Colors.cyan,
                    ),
                    child: TextFormField(
                      controller: valueOfEdge,
                      decoration: InputDecoration(
                        labelText: "Enter num",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 3,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'value is empty';
                        }
                        if (int.tryParse(value) == null) {
                          return "this isn't num";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final FormState? form = _formKey.currentState;
                        form!.validate();
                      },
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      strutStyle: const StrutStyle(fontSize: 16),
                      cursorColor: Colors.pink,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      alignment: Alignment.center,
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.pink.withOpacity(0.5);
                          }
                          if (states.contains(MaterialState.focused)) {
                            return Colors.red;
                          }
                          return Colors.pink; // Use the component's default.
                        },
                      ),
                    ),
                    onPressed: validateAndSave,
                    child: const Text("Continue")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
