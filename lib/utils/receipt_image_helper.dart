import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

const Uuid receiptImageUuid = Uuid();

Future<String?> copyReceiptToLocalFolder(String sourcePath) async {
  try {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      return null;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final receiptsDirectory = Directory(
      p.join(documentsDirectory.path, 'receipts'),
    );

    if (!await receiptsDirectory.exists()) {
      await receiptsDirectory.create(recursive: true);
    }

    final extension = p.extension(sourcePath);
    final fileName = '${receiptImageUuid.v4()}$extension';
    final destinationPath = p.join(receiptsDirectory.path, fileName);
    final copiedFile = await sourceFile.copy(destinationPath);
    return copiedFile.path;
  } catch (_) {
    return null;
  }
}

Future<bool> receiptImageExists(String? path) async {
  if (path == null || path.isEmpty) {
    return false;
  }

  try {
    return File(path).exists();
  } catch (_) {
    return false;
  }
}
