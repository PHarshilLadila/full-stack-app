import 'package:app_frontend_customer/features/customer/address/service/address_service.dart';
import 'package:app_frontend_customer/features/customer/cart/bloc/cart_event.dart';
import 'package:app_frontend_customer/features/customer/checkout/model/checkout_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_frontend_customer/features/customer/address/bloc/address_bloc.dart';
import 'package:app_frontend_customer/features/customer/address/model/address_model.dart';
import 'package:app_frontend_customer/features/customer/cart/bloc/cart_bloc.dart';
import 'package:app_frontend_customer/features/customer/cart/bloc/cart_state.dart';
import 'package:app_frontend_customer/features/customer/cart/model/cart_model.dart';
import 'package:app_frontend_customer/features/customer/checkout/bloc/checkout_bloc.dart';
import 'package:app_frontend_customer/features/customer/checkout/bloc/checkout_event.dart';
import 'package:app_frontend_customer/features/customer/checkout/bloc/checkout_state.dart';
import 'package:app_frontend_customer/features/customer/checkout/service/checkout_service.dart';
import 'package:app_frontend_customer/features/customer/home/service/product_details_service.dart';
import 'package:app_frontend_customer/utils/common/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final bool isDirectOrder;
  final String? directProductId;
  final int? directQuantity;
  final DirectProductInfo? directProductInfo;

  const CheckoutScreen({
    Key? key,
    this.isDirectOrder = false,
    this.directProductId,
    this.directQuantity,
    this.directProductInfo,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedAddressId;
  String _selectedPaymentMethod = 'cod';
  CartSummary? _cartSummary;
  String _token = '';
  bool _isLoading = true;
  DirectProductInfo? _directProductInfo;
  bool _isLoadingProduct = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().stream.listen((state) {
        if (state is CartLoaded && mounted) {
          setState(() {
            _cartSummary = state.cartSummary;
          });
        }
      });
    });
  }

  Future<void> _initializeScreen() async {
    _token = await getTokenFromPrefs();

    if (widget.isDirectOrder) {
      // For direct order, fetch product details if not provided
      if (widget.directProductInfo != null) {
        setState(() {
          _directProductInfo = widget.directProductInfo;
        });
      } else if (widget.directProductId != null) {
        await _fetchProductDetails();
      }
    } else {
      if (_token.isNotEmpty) {
        context.read<CartBloc>().add(LoadCart()); // AA LINE ADD KARO
      }
      _loadCartData();
    }

    if (mounted && _token.isNotEmpty) {
      context.read<AddressBloc>().add(LoadAddresses(token: _token));
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoadingProduct = true;
    });

    try {
      final productService = ProductDetailsService();
      final product = await productService.getProductDetails(
        widget.directProductId!,
      );

      if (product != null && mounted) {
        setState(() {
          _directProductInfo = DirectProductInfo(
            productId: product.id,
            productName: product.productName,
            productImage: product.mainBannerImage,
            price: product.price,
            discountPrice: product.discountPrice,
            quantity: widget.directQuantity ?? 1,
            finalPrice: product.discountedPrice,
            sellerName: product.sellerName,
          );
        });
      }
    } catch (e) {
      print('Error fetching product: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProduct = false;
        });
      }
    }
  }

  void _loadCartData() {
    final cartState = context.read<CartBloc>().state;

    // Debug print - JOVA MATE
    print('CartBloc State: ${cartState.runtimeType}');

    if (cartState is CartLoaded) {
      setState(() {
        _cartSummary = cartState.cartSummary;
      });
    } else if (cartState is CartError) {
      print('Cart Error: ${cartState.message}');
    } else if (cartState is CartInitial) {
      // Cart initial che, load karo
      context.read<CartBloc>().add(LoadCart());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CheckoutBloc, CheckoutState>(
            listener: _handleCheckoutState,
          ),
        ],
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, addressState) {
            if (_isLoading || addressState is AddressLoading) {
              return const CustomLoader(loadingPageName: 'Loading Addresses');
            }
            if (_isLoadingProduct) {
              return const CustomLoader(
                loadingPageName: 'Loading Product Details',
              );
            }
            return _buildBody(context, addressState);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'Checkout',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, AddressState addressState) {
    if (addressState is AddressesLoaded && addressState.addresses.isEmpty) {
      return _buildNoAddressState();
    }

    if (addressState is AddressesLoaded) {
      if (_selectedAddressId == null && addressState.addresses.isNotEmpty) {
        final defaultAddress = addressState.addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => addressState.addresses.first,
        );
        _selectedAddressId = defaultAddress.id;
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressSection(addressState.addresses),
            const SizedBox(height: 20),
            _buildOrderSummarySection(),
            const SizedBox(height: 20),
            _buildPaymentMethodSection(),
            const SizedBox(height: 30),
            _buildPlaceOrderButton(),
            const SizedBox(height: 30),
          ],
        ),
      );
    }

    if (addressState is AddressError) {
      return _buildErrorState(addressState.error);
    }

    return const CustomLoader(loadingPageName: 'Loading Addresses');
  }

  Widget _buildAddressSection(List<AddressModel> addresses) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Delivery Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ...addresses.map((address) => _buildAddressTile(address)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton.icon(
              onPressed: () => _navigateToAddAddress(),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add New Address'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF6B6B),
                side: const BorderSide(color: Color(0xFFFF6B6B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTile(AddressModel address) {
    final isSelected = _selectedAddressId == address.id;

    return RadioListTile<String>(
      value: address.id!,
      groupValue: _selectedAddressId,
      onChanged: (value) {
        setState(() {
          _selectedAddressId = value;
        });
      },
      title: Row(
        children: [
          Expanded(
            child: Text(
              address.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (address.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Default',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '${address.addressLine1}, ${address.addressLine2}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          Text(
            '${address.city}, ${address.state} - ${address.pincode}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            'Phone: ${address.mobileNumber}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
      activeColor: const Color(0xFFFF6B6B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildOrderSummarySection() {
    if (widget.isDirectOrder) {
      if (_directProductInfo == null) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDirectOrderItem(),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Total MRP',
                    '₹${(_directProductInfo!.price * _directProductInfo!.quantity).toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  if (_directProductInfo!.discountPrice > 0)
                    _buildSummaryRow(
                      'Discount',
                      '-₹${((_directProductInfo!.price - _directProductInfo!.finalPrice) * _directProductInfo!.quantity).toStringAsFixed(0)}',
                      valueColor: Colors.green,
                    ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Delivery Charges',
                    'FREE',
                    valueColor: Colors.green,
                  ),
                  const Divider(height: 24, thickness: 1),
                  _buildSummaryRow(
                    'Total Amount',
                    '₹${(_directProductInfo!.finalPrice * _directProductInfo!.quantity).toStringAsFixed(0)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_cartSummary == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final savings = _cartSummary!.discountAmount;
    final total = _cartSummary!.finalAmount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildOrderItemList(),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Total MRP',
                  '₹${_cartSummary!.totalAmount.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Discount',
                  '-₹${savings.toStringAsFixed(0)}',
                  valueColor: Colors.green,
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Delivery Charges',
                  'FREE',
                  valueColor: Colors.green,
                ),
                const Divider(height: 24, thickness: 1),
                _buildSummaryRow(
                  'Total Amount',
                  '₹${total.toStringAsFixed(0)}',
                  isTotal: true,
                ),
                const SizedBox(height: 8),
                Text(
                  'You save ₹${savings.toStringAsFixed(0)} on this order',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectOrderItem() {
    final item = _directProductInfo!;
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.productImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image_not_supported, size: 40),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Seller: ${item.sellerName}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '₹${item.finalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                  if (item.discountPrice > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Qty: ${item.quantity}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cartSummary!.items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _cartSummary!.items[index];
        return Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.productImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 30);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item.quantity}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Text(
              '₹${item.finalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF6B6B),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isTotal ? Colors.black : Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          RadioListTile<String>(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.currency_rupee,
                    size: 20,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Cash on Delivery (COD)'),
              ],
            ),
            subtitle: const Text('Pay when you receive the order'),
            value: 'cod',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
            activeColor: const Color(0xFFFF6B6B),
          ),
          RadioListTile<String>(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.credit_card,
                    size: 20,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Online Payment'),
              ],
            ),
            subtitle: const Text('Credit/Debit Card, UPI, NetBanking'),
            value: 'online',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
            activeColor: const Color(0xFFFF6B6B),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state is CheckoutLoading ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child:
                state is CheckoutLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        );
      },
    );
  }

  void _placeOrder() {
    if (_selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<CheckoutBloc>().add(
      CreateOrder(
        addressId: _selectedAddressId!,
        paymentMethod: _selectedPaymentMethod,
        isDirectOrder: widget.isDirectOrder,
        directProductId: widget.directProductId,
        directQuantity: widget.directQuantity,
      ),
    );
  }

  void _handleCheckoutState(BuildContext context, CheckoutState state) {
    if (state is CheckoutOrderCreated) {
      if (state.orderData.clientSecret != null) {
        _showPaymentDialog(state.orderData);
      }
    } else if (state is CheckoutSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    } else if (state is CheckoutError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (state is CheckoutPaymentConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment confirmed! Order placed successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }
  }

  void _showPaymentDialog(OrderData orderData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Complete Payment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.payment, size: 50, color: Color(0xFFFF6B6B)),
                const SizedBox(height: 16),
                Text(
                  'Order Total: ₹${orderData.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Please complete the payment to confirm your order'),
                const SizedBox(height: 8),
                const Text(
                  'Demo: Simulating payment...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<CheckoutBloc>().add(ResetCheckout());
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<CheckoutBloc>().add(
                    ConfirmPayment(
                      orderId: orderData.orderId,
                      paymentIntentId: orderData.paymentIntentId ?? '',
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Pay Now'),
              ),
            ],
          ),
    );
  }

  void _navigateToAddAddress() async {
    final token = await getTokenFromPrefs();
    if (mounted && token.isNotEmpty) {
      context.read<AddressBloc>().add(LoadAddresses(token: token));
    }
  }

  Widget _buildNoAddressState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Address Found',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Please add a delivery address to continue',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _navigateToAddAddress,
            icon: const Icon(Icons.add_location_rounded),
            label: const Text('Add New Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Failed to load addresses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final token = await getTokenFromPrefs();
              if (mounted && token.isNotEmpty) {
                context.read<AddressBloc>().add(LoadAddresses(token: token));
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<String> getTokenFromPrefs() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("auth_token") ?? '';
  }
}
