// lib/features/customer/address/screens/add_edit_address_screen.dart
import 'package:app_frontend_customer/features/customer/address/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hugeicons/hugeicons.dart';
import '../bloc/address_bloc.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  String _selectedAddressType = 'home';
  bool _isDefault = false;
  String? _token;
  bool _isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _loadTokenAndInitialize();
  }

  Future<void> _loadTokenAndInitialize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token');
    });

    if (widget.address != null) {
      _fullNameController.text = widget.address!.fullName;
      _mobileController.text = widget.address!.mobileNumber;
      _pincodeController.text = widget.address!.pincode;
      _addressLine1Controller.text = widget.address!.addressLine1;
      _addressLine2Controller.text = widget.address!.addressLine2 ?? '';
      _landmarkController.text = widget.address!.landmark ?? '';
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _countryController.text = widget.address!.country;
      _selectedAddressType = widget.address!.addressType;
      _isDefault = widget.address!.isDefault;
    } else {
      _countryController.text = 'India';
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _pincodeController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _token != null && !_isSubmitting) {
      setState(() => _isSubmitting = true);

      final address = AddressModel(
        id: widget.address?.id,
        fullName: _fullNameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        pincode: _pincodeController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2:
            _addressLine2Controller.text.trim().isEmpty
                ? null
                : _addressLine2Controller.text.trim(),
        landmark:
            _landmarkController.text.trim().isEmpty
                ? null
                : _landmarkController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        addressType: _selectedAddressType,
        isDefault: _isDefault,
      );

      if (widget.address == null) {
        context.read<AddressBloc>().add(
          AddAddress(token: _token!, address: address),
        );
      } else {
        context.read<AddressBloc>().add(
          UpdateAddress(token: _token!, address: address),
        );
      }

      // Show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.address == null
                      ? 'Address added successfully!'
                      : 'Address updated successfully!',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'Add New Address' : 'Edit Address',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, size: 20),
          ),
        ),
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressAdded || state is AddressUpdated) {
            // Already handled in submit
          } else if (state is AddressError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.error)),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section with Animation
                    _buildHeaderSection(),
                    const SizedBox(height: 24),

                    // Personal Information Section
                    _buildPersonalInfoSection(),
                    const SizedBox(height: 24),

                    // Address Details Section
                    _buildAddressDetailsSection(),
                    const SizedBox(height: 24),

                    // Address Type Section
                    _buildAddressTypeSection(),
                    const SizedBox(height: 20),

                    // Default Address Toggle
                    _buildDefaultAddressToggle(),
                    const SizedBox(height: 32),

                    // Submit Button
                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade50,
            Colors.amber.shade100.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              widget.address == null
                  ? Icons.add_location_alt
                  : Icons.edit_location_alt,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.address == null ? 'New Address' : 'Update Address',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.address == null
                      ? 'Fill in the details to add a new address'
                      : 'Modify the details of your address',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Personal Information', Icons.person_outline),
        const SizedBox(height: 16),
        AppTextField(
          controller: _fullNameController,
          hintText: 'Full Name',
          hugeIcon: HugeIcons.strokeRoundedUser,
          validator:
              (value) =>
                  value?.isEmpty == true ? 'Please enter full name' : null,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mobileController,
          hintText: 'Mobile Number',
          hugeIcon: HugeIcons.strokeRoundedCall,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty == true) return 'Please enter mobile number';
            if (value!.length < 10)
              return 'Enter a valid 10-digit mobile number';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Address Details', Icons.location_on_outlined),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _pincodeController,
                hintText: 'Pincode',
                hugeIcon: HugeIcons.strokeRoundedLocation03,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Please enter pincode' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _addressLine1Controller,
          hintText: 'Address Line 1',
          hugeIcon: HugeIcons.strokeRoundedHome01,
          validator:
              (value) => value?.isEmpty == true ? 'Please enter address' : null,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _addressLine2Controller,
          hintText: 'Address Line 2 (Optional)',
          hugeIcon: HugeIcons.strokeRoundedHome02,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _landmarkController,
          hintText: 'Landmark (Optional)',
          hugeIcon: HugeIcons.strokeRoundedFlag02,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _cityController,
                hintText: 'City',
                hugeIcon: HugeIcons.strokeRoundedCity01,
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Please enter city' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _stateController,
                hintText: 'State',
                hugeIcon: HugeIcons.strokeRoundedMapPin,
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Please enter state' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _countryController,
          hintText: 'Country',
          hugeIcon: HugeIcons.strokeRoundedGlobal,
          validator:
              (value) => value?.isEmpty == true ? 'Please enter country' : null,
        ),
      ],
    );
  }

  Widget _buildAddressTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Address Type', Icons.label_outline),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildAnimatedAddressTypeChip(
              'home',
              HugeIcons.strokeRoundedHome01,
              'Home',
            ),
            const SizedBox(width: 12),
            _buildAnimatedAddressTypeChip(
              'work',
              HugeIcons.strokeRoundedBriefcase01,
              'Work',
            ),
            const SizedBox(width: 12),
            _buildAnimatedAddressTypeChip(
              'other',
              HugeIcons.strokeRoundedMoreHorizontalCircle01,
              'Other',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedAddressTypeChip(
    String type,
    List<List<dynamic>> icon,
    String label,
  ) {
    final isSelected = _selectedAddressType == type;

    return Expanded(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: isSelected ? 1.0 : value,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedAddressType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient:
                      isSelected
                          ? LinearGradient(
                            colors: [Colors.amber, Colors.amber.shade600],
                          )
                          : null,
                  color: isSelected ? null : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.amber : Colors.grey.shade300,
                    width: isSelected ? 0 : 1,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                          : null,
                ),
                child: Column(
                  children: [
                    HugeIcon(
                      icon: icon,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 24,
                      strokeWidth: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultAddressToggle() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: [
            Checkbox(
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value ?? false;
                });
              },
              activeColor: Colors.amber,
              checkColor: Colors.black,
            ),
            const Expanded(
              child: Text(
                'Set as default address',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            if (_isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
            disabledBackgroundColor: Colors.amber.shade200,
          ),
          child:
              _isSubmitting
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.address == null ? Icons.add : Icons.update,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.address == null
                            ? 'Add Address'
                            : 'Update Address',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.amber.shade700),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Make sure AppTextField is properly defined
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final List<List<dynamic>> hugeIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconButton? sufixIcon;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hugeIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.sufixIcon,
    this.onFieldSubmitted,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 14,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.amber,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 12),
          child: HugeIcon(
            icon: hugeIcon,
            color: Colors.amber,
            size: 22.0,
            strokeWidth: 1,
          ),
        ),
        suffixIcon: sufixIcon,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}
