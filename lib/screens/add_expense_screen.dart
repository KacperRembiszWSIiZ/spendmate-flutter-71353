import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_categories.dart';
import '../utils/date_formatter.dart';
import '../utils/receipt_image_helper.dart';
import '../widgets/category_selector.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  String? _selectedCategoryId = appCategories.first.id;
  DateTime _selectedDate = DateTime.now();
  XFile? _selectedImage;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      locale: const Locale('pl', 'PL'),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _showReceiptImageSourcePicker() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: const Text('Zrób zdjęcie'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text('Wybierz z galerii'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null || !mounted) {
      return;
    }

    await _pickReceiptImage(source);
  }

  Future<void> _pickReceiptImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 82,
      );

      if (image != null && mounted) {
        setState(() => _selectedImage = image);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się wybrać zdjęcia.')),
      );
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final normalizedAmount = _amountController.text.replaceAll(',', '.');
      final amount = double.parse(normalizedAmount);
      final receiptPath = _selectedImage == null
          ? null
          : await copyReceiptToLocalFolder(_selectedImage!.path);

      final now = DateTime.now();
      final expense = Expense(
        id: _uuid.v4(),
        title: _titleController.text.trim(),
        amount: amount,
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        receiptImagePath: receiptPath,
        createdAt: now,
      );

      if (!mounted) {
        return;
      }

      await context.read<ExpenseProvider>().addExpense(expense);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się zapisać wydatku.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nowy wydatek')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: _isSaving ? null : _saveExpense,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: const Text('Zapisz wydatek'),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
            children: [
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nazwa wydatku',
                  prefixIcon: Icon(Icons.edit_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Podaj nazwę wydatku';
                  }
                  return null;
                },
              ),
              const SizedBox(height: space12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Kwota',
                  suffixText: 'PLN',
                  prefixIcon: Icon(Icons.payments_rounded),
                ),
                validator: (value) {
                  final normalized = value?.replaceAll(',', '.') ?? '';
                  final amount = double.tryParse(normalized);
                  if (amount == null || amount <= 0) {
                    return 'Podaj kwotę większą od 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: space16),
              _FormSection(
                title: 'Kategoria',
                child: CategorySelector(
                  selectedCategoryId: _selectedCategoryId,
                  onChanged: (categoryId) {
                    setState(() => _selectedCategoryId = categoryId);
                  },
                ),
              ),
              const SizedBox(height: space12),
              _PickerCard(
                icon: Icons.calendar_today_rounded,
                title: 'Data',
                subtitle: formatDate(_selectedDate),
                onTap: _pickDate,
              ),
              const SizedBox(height: space12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.image_rounded,
                            color: appPrimaryColor,
                          ),
                          const SizedBox(width: space12),
                          const Expanded(
                            child: Text(
                              'Zdjęcie paragonu',
                              style: appBodyStyle,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _showReceiptImageSourcePicker,
                            icon: const Icon(Icons.add_a_photo_rounded),
                            label: const Text('Dodaj'),
                          ),
                        ],
                      ),
                      if (_selectedImage != null) ...[
                        const SizedBox(height: space12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(radius16),
                          child: Image.file(
                            File(_selectedImage!.path),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 120,
                                child: Center(
                                  child: Text('Nie można wyświetlić zdjęcia.'),
                                ),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 6),
                        const Text(
                          'Opcjonalnie zrób zdjęcie paragonu albo wybierz je z galerii.',
                          style: appCaptionStyle,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: appSubheadingStyle.copyWith(fontSize: 20)),
            const SizedBox(height: space12),
            child,
          ],
        ),
      ),
    );
  }
}

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: cardRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: appPrimaryColor),
              const SizedBox(width: space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: appBodyStyle),
                    const SizedBox(height: 3),
                    Text(subtitle, style: appCaptionStyle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: appMutedTextColor),
            ],
          ),
        ),
      ),
    );
  }
}
