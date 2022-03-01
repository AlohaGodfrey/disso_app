import '../models/invoice.dart';
import '../models/timesheet_model.dart';
import '../helpers/pdf_service.dart';

void generatePDF(List<TimesheetItem> timesheetData) async {
  final date = DateTime.now();
  final dueDate = date.add(const Duration(days: 7));

  //collects user timesheet Data
  final tableData = timesheetData.map((item) {
    return InvoiceItem(
        description: item.siteName,
        date: item.date,
        amount: item.hoursWorked * item.payRate,
        hours: item.hoursWorked,
        payRate: item.payRate);
  }).toList();

  //invoice class is split in between three subclasses,
  //supplier customer, supplier, Invoide info.
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
      items: tableData);

  //generates a new invoice
  final pdfFile = await PdfInvoiceApi.generate(invoice);

  //opens the invoice
  PdfApi.openFile(pdfFile);
}
