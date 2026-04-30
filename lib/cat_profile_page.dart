import 'package:flutter/material.dart';
import 'dart:convert';
import 'cat_model.dart';
import 'database_helper.dart';

class CatProfilePage extends StatefulWidget {
  final Cat cat;
  const CatProfilePage({super.key, required this.cat});
  @override
  State<CatProfilePage> createState() => _CatProfilePageState();
}

class _CatProfilePageState extends State<CatProfilePage> {
  late List<dynamic> vaccines;
  late List<dynamic> appointments;

  @override
void initState() {
  super.initState();

  try {
    vaccines = widget.cat.vaccinesJson.isNotEmpty
        ? jsonDecode(widget.cat.vaccinesJson)
        : [];

    appointments = widget.cat.appointmentsJson.isNotEmpty
        ? jsonDecode(widget.cat.appointmentsJson)
        : [];
  } catch (e) {
    vaccines = [];
    appointments = [];
  }
}

  Future _updateDB() async {
    widget.cat.vaccinesJson = jsonEncode(vaccines);
    widget.cat.appointmentsJson = jsonEncode(appointments);
    await CatDatabase.instance.update(widget.cat);
  }

  void _editInfo() {
    final nameCtrl = TextEditingController(text: widget.cat.name);
    final ageCtrl = TextEditingController(text: widget.cat.age);
    final weightCtrl = TextEditingController(text: widget.cat.weight);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('แก้ไขข้อมูล'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'ชื่อ')),
            TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: 'อายุ')),
            TextField(controller: weightCtrl, decoration: const InputDecoration(labelText: 'น้ำหนัก')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                widget.cat.name = nameCtrl.text;
                widget.cat.age = ageCtrl.text;
                widget.cat.weight = weightCtrl.text;
              });
              await _updateDB();
              if (!mounted) return;
              Navigator.pop(dialogCtx);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _addDetail(bool isVaccine) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(isVaccine ? 'เพิ่มวัคซีน' : 'เพิ่มนัดหมอ'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'รายละเอียด...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                if (isVaccine) vaccines.add(ctrl.text);
                else appointments.add(ctrl.text);
              });
              await _updateDB();
              if (!mounted) return;
              Navigator.pop(dialogCtx);
            },
            child: const Text('เพิ่ม'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('โปรไฟล์: ${widget.cat.name} 🎀'), backgroundColor: Colors.pink[200]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              color: Colors.pink[50],
              child: Column(
                children: [
                  const CircleAvatar(radius: 50, child: Icon(Icons.pets, size: 50, color: Colors.pink)),
                  const SizedBox(height: 15),
                  Text(widget.cat.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink)),
                  Text('อายุ: ${widget.cat.age} | น้ำหนัก: ${widget.cat.weight} กก.'),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _editInfo, child: const Text('แก้ไขโปรไฟล์')),
                ],
              ),
            ),
            _buildList('💉 ประวัติวัคซีน', vaccines, () => _addDetail(true)),
            _buildList('📅 นัดหมายสัตวแพทย์', appointments, () => _addDetail(false)),
          ],
        ),
      ),
    );
  }

  Widget _buildList(String title, List<dynamic> items, VoidCallback onAdd) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
              IconButton(onPressed: onAdd, icon: const Icon(Icons.add_circle, color: Colors.pink)),
            ],
          ),
          ...items.map((e) => ListTile(
            leading: const Icon(Icons.favorite, size: 16, color: Colors.pink),
            title: Text(e.toString()),
            dense: true
          )).toList(),
        ],
      ),
    );
  }
}