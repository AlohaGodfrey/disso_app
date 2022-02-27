import 'dart:io';

import '../models/invoice.dart';
import '../models/timesheet_model.dart';
import '../helpers/pdf_service.dart';

void generatePDF(List<TimesheetItem> timesheetData) async {
  final date = DateTime.now();
  final dueDate = date.add(Duration(days: 7));

  final tableData = timesheetData.map((item) {
    // final total = item.unitPrice * (1 + item.vat);

    // return [
    //   item.description,
    //   DateFormat('EEEEEEE d/M/y').format(item.date),
    //   '${item.hours}',
    //   '£ ${item.payRate.toStringAsFixed(2)}',
    //   '${item.vat * 100} %',
    //   '£ ${item.amount}',
    // ];

    return InvoiceItem(
        description: item.siteName,
        date: item.date,
        amount: item.hoursWorked * item.payRate,
        hours: item.hoursWorked,
        payRate: item.payRate);
  }).toList();

  final invoice = Invoice(
      //define supplier
      supplier: const Supplier(
        name: 'Corporate Construction',
        address: 'Drowner Street 9, London, England',
        paymentInfo: '86688568 00-00-00',
      ),
      //define customer
      customer: const Customer(
        name: 'Worker 1',
        address: 'Evil Street 70, High Wycombe, England',
      ),
      //defnine invoice info
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'Operative Invoice detailing job details and categories',
        number: '${DateTime.now().year}-9999',
      ),
      items: tableData
      // items: [
      //   InvoiceItem(
      //     description: 'Coffee',
      //     date: DateTime.now(),
      //     vat: 0.19,
      //     amount: 5.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Water',
      //     date: DateTime.now(),
      //     vat: 0.19,
      //     amount: 0.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Orange',
      //     date: DateTime.now(),
      //     vat: 0.19,
      //     amount: 2.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Apple',
      //     date: DateTime.now(),
      //     vat: 0.19,
      //     amount: 3.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Mango',
      //     date: DateTime.now(),
      //     vat: 0.19,
      //     amount: 1.59,
      //   ),
      //   InvoiceItem(
      //     description: 'Blue Berries',
      //     date: DateTime.now(),
      //     vat: 0.19,
      //     amount: 0.99,
      //   ),
      //   InvoiceItem(
      //     description: 'Lemon',
      //     date: DateTime.now(),
      //     vat: 0.19,
      //     amount: 1.29,
      //   ),
      // ],
      );

  final pdfFile = await PdfInvoiceApi.generate(invoice);

  PdfApi.openFile(pdfFile);
}
