import 'package:flutter/material.dart';

class MyVehiclesListScreen extends StatelessWidget {
  const MyVehiclesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes véhicules')),
      body: const Center(
        child: Text('TODO: lister les véhicules de l’utilisateur'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/vehicles/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}


