import 'package:flutter/material.dart';

class SyncBadge extends StatelessWidget 
{
  const SyncBadge({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 12, color: Colors.white),
          SizedBox(width: 3),
          Text('Syncing', style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}
