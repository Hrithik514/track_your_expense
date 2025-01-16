import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox<Map>('groupsBox'); // Open the Hive box before running the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Track your Expense'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController EventNameController = TextEditingController();
  final TextEditingController memberController = TextEditingController();
  List<String> members = [];

  final Box<Map> groupsBox = Hive.box<Map>('groupsBox'); // Access the Hive box

  void _addEventDialog() {
    final TextEditingController eventNameController = TextEditingController();
    String? selectedGroupName;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Event'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Event Name Input
                  TextField(
                    controller: eventNameController,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Group Name Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedGroupName,
                    items: groupsBox.keys.map((groupName) {
                      return DropdownMenuItem<String>(
                        value: groupName,
                        child: Text(groupName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroupName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Group',
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    String eventName = eventNameController.text.trim();
                    if (eventName.isNotEmpty && selectedGroupName != null) {
                      // Save the event data to Hive
                      final eventsBox = Hive.box<Map>('eventsBox');
                      eventsBox.add({
                        'eventName': eventName,
                        'groupName': selectedGroupName,
                      });

                      // Refresh UI
                      setState(() {
                        eventNameController.clear();
                      });

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _navigateToCreateEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEditGroupsPage()),
    );
  }

  void _navigateToAddEventPage() {
    _addEventDialog();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5.0,
        shadowColor: Colors.black54,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: _navigateToCreateEditPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Create Group',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: OutlinedButton(
              onPressed: _navigateToAddEventPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Add Event',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}

class CreateEditGroupsPage extends StatefulWidget {
  const CreateEditGroupsPage({super.key});

  @override
  _CreateEditGroupsPageState createState() => _CreateEditGroupsPageState();
}

class _CreateEditGroupsPageState extends State<CreateEditGroupsPage> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController memberController = TextEditingController();
  List<String> members = [];
  late Box<Map> groupsBox;

  @override
  void initState() {
    super.initState();
    groupsBox = Hive.box<Map>('groupsBox'); // Initialize the Hive box
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: groupNameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: memberController,
                          decoration: const InputDecoration(
                            labelText: 'Add Members',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          String memberName = memberController.text.trim();
                          if (memberName.isNotEmpty) {
                            setState(() {
                              members.add(memberName);
                              memberController.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text('Add',style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight:FontWeight.bold
                        ),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: members.map((member) {
                      return Chip(
                        label: Text(member),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            members.remove(member);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    String groupName = groupNameController.text.trim();
                    // Create a copy of the members list
                    List<String> membersName = List.from(members);
                    if (groupName.isNotEmpty && membersName.isNotEmpty) {
                      groupsBox.put(groupName, {'members': membersName});

                      // Print the group name and members to the console
                      print('Group Name: $groupName');
                      print('Group Members: $membersName');

                      setState(() {
                        groupNameController.clear();
                        members.clear();
                      });

                      Navigator.pop(context);

                      // Trigger setState to refresh the main widget
                      this.setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text('Save',style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight:FontWeight.bold
                  ),),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditGroupDialog(String currentGroupName, List<String> currentMembers) {
    final TextEditingController groupNameController = TextEditingController(text: currentGroupName);
    final TextEditingController memberController = TextEditingController();
    List<String> members = List<String>.from(currentMembers); // Clone members list

    print("**************************************");
    print(groupNameController);
    print(memberController);
    print(members);
    print("**************************************");

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit Group Name
                  TextField(
                    controller: groupNameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Add New Member
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: memberController,
                          decoration: const InputDecoration(
                            labelText: 'Add Member',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          String newMember = memberController.text.trim();
                          if (newMember.isNotEmpty) {
                            setState(() {
                              members.add(newMember); // Add new member
                              memberController.clear(); // Clear input field
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text('Add',style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight:FontWeight.bold
                        ),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // List Existing Members with Delete Option
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: members.map((member) {
                      return Chip(
                        label: Text(member),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            members.remove(member); // Remove member
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                // Save Button
                ElevatedButton(
                  onPressed: () {
                    String updatedGroupName = groupNameController.text.trim();
                    if (updatedGroupName.isNotEmpty && members.isNotEmpty) {
                      // Update Hive storage
                      setState(() {
                        if (updatedGroupName != currentGroupName) {
                          // Remove old group if name has changed
                          groupsBox.delete(currentGroupName);
                        }
                        // Save updated group data with members in a map
                        groupsBox.put(updatedGroupName, {'members': members});
                      });
                      Navigator.pop(context); // Close dialog
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text('Save',style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight:FontWeight.bold
                  ),),
                ),
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog without changes
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create/Edit Groups',
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Custom back icon
          onPressed: () {
            Navigator.pop(context); // Action when back arrow is pressed
          },
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showCreateGroupDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: groupsBox.listenable(),
              builder: (context, Box<Map> box, _) {
                // Get all keys, sorted by the order in which they were modified
                final groupKeys = box.keys.toList();

                return ListView.builder(
                  itemCount: groupKeys.length,
                  itemBuilder: (context, index) {
                    final groupName = groupKeys[index];
                    final members = box.get(groupName)?['members'] ?? [];

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(groupName.toString(),style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight:FontWeight.bold
                        ),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Fetch group details from Hive
                                final groupData = groupsBox.get(groupName);
                                final existingMembers = List<String>.from(groupData?['members'] ?? []);

                                // Open the dialog with current group data
                                _showEditGroupDialog(groupName, existingMembers);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                              child: const Text('View/Edit',style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight:FontWeight.bold
                              ),),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  groupsBox.delete(groupName);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
