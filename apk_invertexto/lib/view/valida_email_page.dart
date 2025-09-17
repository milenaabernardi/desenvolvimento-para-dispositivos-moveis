import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class ValidaEmailPage extends StatefulWidget {
  const ValidaEmailPage({super.key});

  @override
  State<ValidaEmailPage> createState() => _ValidaEmailPageState();
}

class _ValidaEmailPageState extends State<ValidaEmailPage> {
  String? campo;
  final apiService = InvertextoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Validador de Email"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: "Digite um email",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),
            Expanded(
              child: campo == null || campo!.isEmpty
                  ? const Center(
                      child: Text(
                        "Digite um email para validar",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : FutureBuilder<Map<String, dynamic>>(
                      future: apiService.validaEmail(campo!),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              return exibeErro(snapshot.error);
                            } else {
                              return exibeResultado(snapshot.data);
                            }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(Map<String, dynamic>? data) {
    if (data == null) {
      return const Text(
        "Nenhum resultado",
        style: TextStyle(color: Colors.white),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email: ${data['email']}",
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text("Formato válido: ${data['valid_format']}",
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text("Possui MX válido: ${data['valid_mx']}",
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text("Descartável: ${data['disposable']}",
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  Widget exibeErro(Object? erro) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        "Ocorreu um erro: $erro",
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }
}
