import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PvNew extends StatefulWidget {
  const PvNew({Key? key}) : super(key: key);

  @override
  State<PvNew> createState() => _PvNewState();
}

class _PvNewState extends State<PvNew> {
  TextEditingController centreEnseignementController = TextEditingController();
  TextEditingController promotionClasseController = TextEditingController();
  TextEditingController codeEnseignementController = TextEditingController();
  TextEditingController dateExamenController = TextEditingController();
  TextEditingController dureeExamenController = TextEditingController();
  TextEditingController salleAmphiController = TextEditingController();
  TextEditingController incidentsDetailsController = TextEditingController();

  String _selectedType = "Control";
  String _selectedIncident = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire PV"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16.0),
              TextFormField(
                controller: centreEnseignementController,
                decoration: InputDecoration(
                  labelText: 'Centre Enseignement',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: promotionClasseController,
                decoration: InputDecoration(
                  labelText: 'Promotion Classe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                items: ["Control", "Control Final", "Examen Terminal"]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                    .toList(),
              ),

              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Personnes chargées de la surveillance:"),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: dateExamenController,
                    decoration: InputDecoration(
                      labelText: 'Date de l\'examen',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: dureeExamenController,
                    decoration: InputDecoration(
                      labelText: 'Durée',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: salleAmphiController,
                decoration: InputDecoration(
                  labelText: 'Salle/Amphi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text("Incidents au cours de l'épreuve:"),
              Row(
                children: [
                  Radio(
                    value: "OUI",
                    groupValue: _selectedIncident,
                    onChanged: (value) {
                      setState(() {
                        _selectedIncident = value.toString();
                      });
                    },
                  ),
                  const Text("OUI"),
                  Radio(
                    value: "NON",
                    groupValue: _selectedIncident,
                    onChanged: (value) {
                      setState(() {
                        _selectedIncident = value.toString();
                      });
                    },
                  ),
                  const Text("NON"),
                ],
              ),
              TextFormField(
                controller: incidentsDetailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Si oui, lesquels',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text("Soumettre"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Vérifiez si les champs sont vides
    if (_selectedIncident.isEmpty ||
        centreEnseignementController.text.isEmpty ||
        promotionClasseController.text.isEmpty ||
        codeEnseignementController.text.isEmpty ||
        dateExamenController.text.isEmpty ||
        dureeExamenController.text.isEmpty ||
        salleAmphiController.text.isEmpty ||
        (_selectedIncident == "OUI" && incidentsDetailsController.text.isEmpty)) {
      // Affichez un toast en rouge avec les champs vides
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs en rouge'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3), // Durée d'affichage du SnackBar
        ),
      );
    } else {
      // Tous les champs sont remplis, soumettez le formulaire
      // ... soumission du formulaire ...
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulaire soumis avec succès'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}