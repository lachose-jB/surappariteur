import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DocumentNews extends StatefulWidget {
  const DocumentNews({super.key});
  @override
  State<DocumentNews> createState() => _DocumentNewsState();
}

class _DocumentNewsState extends State<DocumentNews> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedLabel;
  String? selectedFilePath;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // List of allowed extensions without the dot
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      setState(() {
        selectedFilePath = filePath;
      });
    }
  }

  void doSomething() async {
    Timer(
      const Duration(seconds: 3),
      () {
        _btnController.success();
        Timer(
          const Duration(seconds: 2),
          () {
            _btnController.reset();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un document"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                items: const [
                  DropdownMenuItem(
                    value: "Pièce d’identité",
                    child: Text("Pièce d’identité"),
                  ),
                  DropdownMenuItem(
                    value: "Titre de séjour",
                    child: Text("Titre de séjour"),
                  ),
                  DropdownMenuItem(
                    value: "Relevé d'identité bancaire (RIB)",
                    child: Text("Relevé d'identité bancaire (RIB)"),
                  ),
                  DropdownMenuItem(
                    value: "Attestation  Sécurité sociale",
                    child: Text("Attestation  Sécurité sociale"),
                  ),
                  DropdownMenuItem(
                    value: "Contrat",
                    child: Text("Contrat"),
                  ),
                  DropdownMenuItem(
                    value: "Autre",
                    child: Text("Autre"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLabel = value;
                  });
                },
                value: selectedLabel,
                decoration: const InputDecoration(
                  labelText: 'Libellé du document',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Sélectionnez un libellé';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Ouvrir la galerie pour sélectionner un fichier
                  pickFile();
                },
                child: const Text("Sélectionner un fichier ..."),
              ),
              const SizedBox(height: 20),
              // Afficher le chemin du fichier sélectionné
              if (selectedFilePath != null)
                Text("Fichier sélectionné : $selectedFilePath"),
              const SizedBox(height: 16),
              RoundedLoadingButton(
                width: 120,
                controller: _btnController,
                onPressed: doSomething,
                child: const Text('Ajouter',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
