import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_services.dart';

class HomePage extends StatefulWidget 
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  final TextEditingController txtname = TextEditingController();
  final TextEditingController txtcity = TextEditingController();
  final TextEditingController txtsalary = TextEditingController();

  String? selectedUserId;

  Future<void> saveUser() async 
  {
    if (txtname.text.trim().isEmpty ||
        txtcity.text.trim().isEmpty ||
        txtsalary.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final int? salary = int.tryParse(txtsalary.text.trim());

    if (salary == null) 
    {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid salary')));
      return;
    }

    final bool isNew = selectedUserId == null;
    try 
    {
      if (selectedUserId == null) 
      {
        await FirebaseServices.addUser(
          txtname.text.trim(),
          txtcity.text.trim(),
          salary,
        );
      } 
      else 
      {
        await FirebaseServices.updateUser(
          selectedUserId!,
          txtname.text.trim(),
          txtcity.text.trim(),
          salary,
        );
      }

      if (!mounted) return;

      setState(() 
      {
        selectedUserId = null;
      });

      txtname.clear();
      txtcity.clear();
      txtsalary.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNew
                ? 'User saved successfully'
                : 'User updated successfully',
          ),
        ),
      );
    } 
    catch (e) 
    {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void editUser(String id, Map<String, dynamic> data) 
  {
    setState(() 
    {
      selectedUserId = id;
      txtname.text = data['name']?.toString() ?? '';
      txtcity.text = data['city']?.toString() ?? '';
      txtsalary.text = data['salary']?.toString() ?? '';
    });
  }

  void clearForm() 
  {
    setState(() 
    {
      selectedUserId = null;
    });

    txtname.clear();
    txtcity.clear();
    txtsalary.clear();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: txtname,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),

                TextField(
                  controller: txtcity,
                  decoration: const InputDecoration(labelText: 'City'),
                ),

                TextField(
                  controller: txtsalary,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Salary'),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: saveUser,
                      child: Text(
                        selectedUserId == null ? 'Add User' : 'Update User',
                      ),
                    ),
                    if (selectedUserId != null) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: clearForm,
                        child: const Text('Cancel'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseServices.readUsers(),
              builder: (context, snapshot) 
              {
                if (snapshot.hasError) 
                {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) 
                {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) 
                {
                  return const Center(child: Text('No users found'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) 
                  {
                    final data = document.data()! as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['name'] ?? 'No name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(data['city'] ?? 'No city'),
                          Text('${data['salary'] ?? 'No salary'}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () 
                            {
                              editUser(document.id, data);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async 
                            {
                              try 
                              {
                                await FirebaseServices.deleteUser(document.id);

                                if (!mounted) return;

                                if (selectedUserId == document.id) 
                                {
                                  clearForm();
                                }
                              } 
                              catch (e) 
                              {
                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Delete failed: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() 
  {
    txtname.dispose();
    txtcity.dispose();
    txtsalary.dispose();
    super.dispose();
  }
}
