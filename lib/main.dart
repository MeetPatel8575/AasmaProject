import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StudentInfoPage(),
    );
  }
}

class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({Key? key}) : super(key: key);

  @override
  _StudentInfoPageState createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  List<Map<String, String>> educationEntries = [
    {
      'institution': '',
      'degree': '',
      'start_date': '',
      'end_date': '',
      'percentage': '',
    },
    {
      'institution': '',
      'degree': '',
      'start_date': '',
      'end_date': '',
      'percentage': '',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void addEducationEntry() {
    setState(() {
      educationEntries.add({
        'institution': '',
        'degree': '',
        'start_date': '',
        'end_date': '',
        'percentage': '',
      });
    });
  }

  void removeEducationEntry(int index) {
    setState(() {
      educationEntries.removeAt(index);
    });
  }

  Future<void> downloadPDF() async {
    final output = await getExternalStorageDirectory();
    if (output == null) {
      return;
    }

    final pdf = await generatePdf();
    final file = File('${output.path}/student_information.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  Future<void> sharePDF() async {
    final output = await getExternalStorageDirectory();
    if (output == null) {
      return;
    }

    final pdf = await generatePdf();
    final file = File('${output.path}/student_information.pdf');
    await file.writeAsBytes(await pdf.save());

    // Share the PDF
    Share.shareFiles([file.path], text: 'Student Information PDF');
  }

  Future<pw.Document> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(level: 1, child: pw.Text('Student Information')),
          pw.Paragraph(text: 'Name: ${nameController.text}'),
          pw.Paragraph(text: 'Date of Birth: ${dobController.text}'),
          pw.Header(level: 2, child: pw.Text('Educational History')),
          pw.Table.fromTextArray(
            context: context,
            headerDecoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.zero,
              color: PdfColors.grey300,
            ),
            headerHeight: 30,
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerLeft,
            },
            headers: [
              'Institution',
              'Degree',
              'Start Date',
              'End Date',
              'Percentage',
            ],
            data: [
              for (var entry in educationEntries)
                [
                  entry['institution'],
                  entry['degree'],
                  entry['start_date'],
                  entry['end_date'],
                  entry['percentage'],
                ],
            ],
          ),
        ],
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                onTap: () async {
                  DateTime selectedDate = DateTime(2023);
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      dobController.text =
                          DateFormat('dd-MM-yyyy').format(picked);
                    });
                  }
                },
              ),
              const SizedBox(height: 36),
              const Text(
                'Educational History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Institution')),
                    DataColumn(label: Text('Degree')),
                    DataColumn(label: Text('Start Date')),
                    DataColumn(label: Text('End Date')),
                    DataColumn(label: Text('Percentage')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    for (var i = 0; i < educationEntries.length; i++)
                      DataRow(
                        cells: [
                          DataCell(
                            TextField(
                              controller: TextEditingController(
                                  text: educationEntries[i]['institution']),
                              onChanged: (value) =>
                                  educationEntries[i]['institution'] = value,
                            ),
                          ),
                          DataCell(
                            TextField(
                              controller: TextEditingController(
                                  text: educationEntries[i]['degree']),
                              onChanged: (value) =>
                                  educationEntries[i]['degree'] = value,
                            ),
                          ),
                          DataCell(
                            TextField(
                              controller: TextEditingController(
                                  text: educationEntries[i]['start_date']),
                              onTap: () async {
                                DateTime selectedDate = DateTime(2023);
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    educationEntries[i]['start_date'] =
                                        DateFormat('dd-MM-yyyy').format(picked);
                                  });
                                }
                              },
                            ),
                          ),
                          DataCell(
                            TextField(
                              controller: TextEditingController(
                                  text: educationEntries[i]['end_date']),
                              onTap: () async {
                                DateTime selectedDate = DateTime(2023);
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    educationEntries[i]['end_date'] =
                                        DateFormat('dd-MM-yyyy').format(picked);
                                  });
                                }
                              },
                            ),
                          ),
                          DataCell(
                            TextField(
                              controller: TextEditingController(
                                  text: educationEntries[i]['percentage']),
                              onChanged: (value) =>
                                  educationEntries[i]['percentage'] = value,
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => removeEducationEntry(i),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: addEducationEntry,
                child: const Text('Add Education Details'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: educationEntries.isNotEmpty
                        ? () => downloadPDF()
                        : null,
                    child: const Text('Download PDF'),
                  ),
                  ElevatedButton(
                    onPressed:
                        educationEntries.isNotEmpty ? () => sharePDF() : null,
                    child: const Text('Share PDF'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
