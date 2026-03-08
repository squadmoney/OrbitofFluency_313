import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../models/collection.dart';
import '../premka.dart';
import '../providers/collections_provider.dart';
import '../providers/stats_provider.dart';

// ---------------------------------------------------------------------------
// Export format enum
// ---------------------------------------------------------------------------

enum ExportFormat { pdf, markdown }

// ---------------------------------------------------------------------------
// Export service — stateless, static methods
// ---------------------------------------------------------------------------

class ExportService {
  static final _dateFormat = DateFormat('MMMM d, yyyy');

  // --- PDF generation ---

  static Future<Uint8List> generatePdf({
    required List<CardCollection> collections,
    required int mastered,
    required int dayStreak,
    required int totalCards,
  }) async {
    final regular = pw.Font.helvetica();
    final bold = pw.Font.helveticaBold();
    final dateStr = _dateFormat.format(DateTime.now());

    final titleStyle = pw.TextStyle(font: bold, fontSize: 24);
    final headingStyle = pw.TextStyle(font: bold, fontSize: 16);
    final subheadingStyle = pw.TextStyle(font: bold, fontSize: 11);
    final bodyStyle = pw.TextStyle(font: regular, fontSize: 10);
    final captionStyle = pw.TextStyle(
      font: regular,
      fontSize: 10,
      color: PdfColors.grey600,
    );

    final pdf = pw.Document(
      title: 'Orbit of Fluency - Progress Report',
      author: 'Orbit of Fluency',
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Text('Orbit of Fluency', style: titleStyle),
          pw.SizedBox(height: 4),
          pw.Text('Progress Report — $dateStr', style: captionStyle),
          pw.SizedBox(height: 20),

          // Summary stats
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _statBox('Mastered', mastered.toString(), regular, bold),
              _statBox('Day Streak', dayStreak.toString(), regular, bold),
              _statBox('Total Cards', totalCards.toString(), regular, bold),
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Divider(),
          pw.SizedBox(height: 16),

          // Collections
          pw.Text('Collections', style: headingStyle),
          pw.SizedBox(height: 12),

          ...collections.map((collection) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    // Name only — no emoji (Helvetica can't render emoji)
                    pw.Text(collection.name, style: subheadingStyle),
                    pw.Spacer(),
                    pw.Text(
                      '${collection.cards.length} cards',
                      style: captionStyle,
                    ),
                  ]),
                  pw.SizedBox(height: 8),
                  if (collection.cards.isNotEmpty)
                    pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey300),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(2),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey100,
                          ),
                          children: [
                            _tableCell('Word', subheadingStyle),
                            _tableCell('Description', subheadingStyle),
                          ],
                        ),
                        ...collection.cards.map((card) => pw.TableRow(
                              children: [
                                _tableCell(card.word, bodyStyle),
                                _tableCell(
                                    card.description ?? '-', bodyStyle),
                              ],
                            )),
                      ],
                    ),
                  pw.SizedBox(height: 16),
                ],
              )),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
              font: regular,
              fontSize: 9,
              color: PdfColors.grey500,
            ),
          ),
        ),
      ),
    );

    return pdf.save();
  }

  // --- Markdown generation ---

  static String generateMarkdown({
    required List<CardCollection> collections,
    required int mastered,
    required int dayStreak,
    required int totalCards,
  }) {
    final dateStr = _dateFormat.format(DateTime.now());
    final buf = StringBuffer();

    buf.writeln('# Orbit of Fluency — Progress Report');
    buf.writeln();
    buf.writeln('_${dateStr}_');
    buf.writeln();

    buf.writeln('## Summary');
    buf.writeln();
    buf.writeln('| Mastered | Day Streak | Total Cards |');
    buf.writeln('|----------|------------|-------------|');
    buf.writeln('| $mastered | $dayStreak | $totalCards |');
    buf.writeln();

    buf.writeln('## Collections');
    buf.writeln();

    for (final c in collections) {
      buf.writeln('### ${c.emoji} ${c.name} (${c.cards.length} cards)');
      buf.writeln();
      if (c.cards.isEmpty) {
        buf.writeln('_No cards yet._');
      } else {
        buf.writeln('| Word | Description |');
        buf.writeln('|------|-------------|');
        for (final card in c.cards) {
          buf.writeln('| ${card.word} | ${card.description ?? '-'} |');
        }
      }
      buf.writeln();
    }

    buf.writeln('---');
    buf.writeln('_Generated by Orbit of Fluency_');
    return buf.toString();
  }

  // --- PDF helpers ---

  static pw.Widget _statBox(
    String label,
    String value,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Container(
      width: 140,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(font: bold, fontSize: 20),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            label,
            style: pw.TextStyle(
              font: regular,
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _tableCell(String text, pw.TextStyle style) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(text, style: style, maxLines: 3),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared export handler — used from Settings and Statistics screens
// ---------------------------------------------------------------------------

Future<void> handleExportProgress(BuildContext context, WidgetRef ref) async {
  final isPremium = ref.read(premProvider);

  if (!isPremium) {
    showPremiumGate(
      context,
      'Export progress is a Premium feature.',
    );
    return;
  }

  // Show format picker
  final format = await showCupertinoModalPopup<ExportFormat>(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: const Text('Export Progress'),
      message: const Text('Choose export format'),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(ExportFormat.pdf),
          child: const Text('PDF Report'),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(ExportFormat.markdown),
          child: const Text('Markdown File'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () => Navigator.of(ctx).pop(),
        child: const Text('Cancel'),
      ),
    ),
  );

  if (format == null || !context.mounted) return;

  // Gather data
  debugPrint('[Export] format=$format, gathering data...');
  final collections = ref.read(collectionsProvider).collections;
  debugPrint('[Export] collections count=${collections.length}');
  final totalCards =
      collections.fold<int>(0, (sum, c) => sum + c.cards.length);
  debugPrint('[Export] totalCards=$totalCards');
  final stats = ref.read(statsProvider);
  debugPrint('[Export] stats=$stats, mastered=${stats.masteredCount}, streak=${stats.dayStreak}');
  final mastered = stats.masteredCount;
  final dayStreak = stats.dayStreak;

  // Save context-dependent objects BEFORE async gaps
  final rootNavigator = Navigator.of(context, rootNavigator: true);
  final box = context.findRenderObject() as RenderBox?;
  final shareOrigin =
      box != null ? box.localToGlobal(Offset.zero) & box.size : Rect.zero;

  showCupertinoDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CupertinoAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(),
          SizedBox(height: 12),
          Text('Generating report...'),
        ],
      ),
    ),
  );

  try {
    if (format == ExportFormat.pdf) {
      final pdfBytes = await ExportService.generatePdf(
        collections: collections,
        mastered: mastered,
        dayStreak: dayStreak,
        totalCards: totalCards,
      );
      rootNavigator.pop();
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'orbit_of_fluency_progress.pdf',
      );
    } else {
      debugPrint('[Export MD] generating markdown...');
      final markdown = ExportService.generateMarkdown(
        collections: collections,
        mastered: mastered,
        dayStreak: dayStreak,
        totalCards: totalCards,
      );
      debugPrint('[Export MD] markdown generated, length=${markdown.length}');
      rootNavigator.pop();
      debugPrint('[Export MD] dialog dismissed, getting temp dir...');
      final tempDir = await getTemporaryDirectory();
      debugPrint('[Export MD] tempDir=${tempDir.path}');
      final file =
          File('${tempDir.path}/orbit_of_fluency_progress.md');
      debugPrint('[Export MD] writing file: ${file.path}');
      await file.writeAsString(markdown);
      debugPrint('[Export MD] file written, sharing...');
      await Share.shareXFiles(
        [XFile(file.path)],
        sharePositionOrigin: shareOrigin,
      );
      debugPrint('[Export MD] share complete');
    }
  } catch (e, stackTrace) {
    debugPrint('[Export] ERROR: $e');
    debugPrint('[Export] STACK: $stackTrace');
    rootNavigator.pop();

    if (context.mounted) {
      showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Export Failed'),
          content: const Text(
            'There was a problem generating the report. Please try again.',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () =>
                  Navigator.of(ctx, rootNavigator: true).pop(),
            ),
          ],
        ),
      );
    }
  }
}
