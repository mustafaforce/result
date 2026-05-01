import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/seat.dart';
import '../../domain/usecases/create_seat.dart';
import '../../domain/usecases/update_seat.dart';

class SeatFormPage extends StatefulWidget {
  const SeatFormPage({
    super.key,
    required this.createSeat,
    required this.updateSeat,
  });

  final CreateSeat createSeat;
  final UpdateSeat updateSeat;

  @override
  State<SeatFormPage> createState() => _SeatFormPageState();
}

class _SeatFormPageState extends State<SeatFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _hallController = TextEditingController();
  final _seatNumberController = TextEditingController();
  final _locationController = TextEditingController();
  final _feeController = TextEditingController();
  final _capacityController = TextEditingController(text: '2');
  final _descriptionController = TextEditingController();

  bool _isAvailable = true;
  bool _isSaving = false;
  String? _editId;
  String? _ownerId;
  bool _argsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsLoaded) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Seat) {
      _editId = args.id;
      _ownerId = args.ownerId;
      _titleController.text = args.title;
      _hallController.text = args.hallName;
      _seatNumberController.text = args.seatNumber ?? '';
      _locationController.text = args.location ?? '';
      _capacityController.text = args.capacity.toString();
      _feeController.text = args.monthlyFee?.toStringAsFixed(0) ?? '';
      _descriptionController.text = args.description ?? '';
      _isAvailable = args.isAvailable;
    }
    _argsLoaded = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hallController.dispose();
    _seatNumberController.dispose();
    _locationController.dispose();
    _feeController.dispose();
    _capacityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      final seat = Seat(
        id: _editId ?? '',
        ownerId: _ownerId ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        hallName: _hallController.text.trim(),
        seatNumber: _seatNumberController.text.trim().isNotEmpty
            ? _seatNumberController.text.trim()
            : null,
        location: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
        monthlyFee: double.tryParse(_feeController.text.trim()),
        capacity: int.tryParse(_capacityController.text.trim()) ?? 2,
        isAvailable: _isAvailable,
      );

      if (_editId != null) {
        await widget.updateSeat(seat);
      } else {
        await widget.createSeat(seat);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save seat')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Seat' : 'Add Seat'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _hallController,
                decoration: const InputDecoration(
                  labelText: 'Hall / Mess Name',
                  prefixIcon: Icon(Icons.location_city_rounded),
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter hall name' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _seatNumberController,
                decoration: const InputDecoration(
                  labelText: 'Seat Number (optional)',
                  prefixIcon: Icon(Icons.numbers_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (optional)',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Fee (BDT)',
                  prefixIcon: Icon(Icons.wallet_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capacity (persons)',
                  prefixIcon: Icon(Icons.group_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Available',
                    style: GoogleFonts.manrope(
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _isAvailable,
                    onChanged: (v) => setState(() => _isAvailable = v),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: Text(_isSaving ? 'SAVING...' : 'SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
