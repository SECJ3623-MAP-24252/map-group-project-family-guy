import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final String name;
  final String dose;
  final String times;
  final VoidCallback onTap;
  final DismissDirectionCallback onDismissed;

  const MedicineCard({
    super.key,
    required this.name,
    required this.dose,
    required this.times,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(name + dose + times),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: onDismissed,
      child: Card(
        color: const Color(0xFFE3F2FD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: ListTile(
          leading: const Icon(Icons.medication_liquid, color: Colors.teal, size: 32),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dose: $dose'),
                Text('Times: $times'),
              ],
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.black54),
          onTap: onTap,
        ),
      ),
    );
  }
}
