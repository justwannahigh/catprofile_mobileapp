import 'package:flutter/material.dart';
import 'dart:convert';
import 'cat_model.dart';
import 'database_helper.dart';
import 'cat_profile_page.dart';

class CatListPage extends StatefulWidget {
  const CatListPage({super.key});
  @override
  State<CatListPage> createState() => _CatListPageState();
}

class _CatListPageState extends State<CatListPage> {
  List<Cat> cats = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshCats();
  }

  Future refreshCats() async {
    setState(() => isLoading = true);
    cats = await CatDatabase.instance.readAllCats();
    setState(() => isLoading = false);
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final weightCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.pink[50],
        title: const Text('เพิ่มสมาชิกใหม่', style: TextStyle(color: Colors.pink)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'ชื่อน้องแมว')),
            TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: 'อายุ')),
            TextField(controller: weightCtrl, decoration: const InputDecoration(labelText: 'น้ำหนัก (กก.)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await CatDatabase.instance.create(Cat(
                  name: nameCtrl.text,
                  age: ageCtrl.text,
                  weight: weightCtrl.text,
                  vaccinesJson: jsonEncode([]),
                  appointmentsJson: jsonEncode([]),
                ));
                refreshCats();
                if (!mounted) return;
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cats Database', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink[300],
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : cats.isEmpty 
              ? const Center(child: Text('ไม่มีข้อมูลน้องแมว'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cats.length,
                  itemBuilder: (ctx, i) => Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.pets, color: Colors.pink)),
                      title: Text(cats[i].name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                      subtitle: Text('อายุ: ${cats[i].age} | น้ำหนัก: ${cats[i].weight} กก.'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await CatDatabase.instance.delete(cats[i].id!);
                          refreshCats();
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (ctx) => CatProfilePage(cat: cats[i])));
                        refreshCats();
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.pink[300],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}