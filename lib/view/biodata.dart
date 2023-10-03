import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BiodataForm extends StatefulWidget {
  const BiodataForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BiodataFormState createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  String? _name;
  String? _placeOfBirth;
  DateTime? _dateOfBirth;
  String? _gender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _saveDataToFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final collectionReference = firestore.collection('biodata');

      final biodata = {
        'name': _name,
        'placeOfBirth': _placeOfBirth,
        'dateOfBirth': _dateOfBirth,
        'gender': _gender,
      };

      await collectionReference.add(biodata);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan ke Firestore')),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Text(
                  'From Biodata',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tempat Lahir',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan tempat lahir';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _placeOfBirth = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan tanggal lahir';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateOfBirth = pickedDate;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                  text: _dateOfBirth != null
                      ? "${_dateOfBirth!.day}-${_dateOfBirth!.month}-${_dateOfBirth!.year}"
                      : "",
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontSize: 16.0),
              ),
              Row(
                children: <Widget>[
                  Radio<String>(
                    value: 'Laki-laki',
                    groupValue: _gender,
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Laki-laki'),
                  Radio<String>(
                    value: 'Perempuan',
                    groupValue: _gender,
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Perempuan'),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveDataToFirestore();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
