import 'package:flutter/material.dart';

class StatsTile extends StatelessWidget {
  const StatsTile({
    required this.heading,
    required this.value,
    super.key,
  });

// para actualizar los datos
  final int value;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column( //para el numero y el nombre
        children: [
          Expanded(
            child: FittedBox(
              //numero
              fit: BoxFit.scaleDown,
              alignment: const Alignment(0, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith( //sirve para cambiar valores de un tema
                    fontSize: 50,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              //texto
              alignment: const Alignment(0, -1.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  heading,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
