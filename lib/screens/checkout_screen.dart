// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../models/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'card';
  bool _useExistingAddress = true;
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order summary
              _buildSection(
                context,
                'Order Summary',
                Column(
                  children: cartProvider.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.name} x${item.quantity}',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text('\$${item.total.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Delivery address
              _buildSection(
                context,
                'Delivery Address',
                Column(
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use saved address'),
                      value: _useExistingAddress,
                      onChanged: (value) {
                        setState(() => _useExistingAddress = value ?? true);
                      },
                    ),
                    if (!_useExistingAddress)
                      TextField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter delivery address',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment method
              _buildSection(
                context,
                'Payment Method',
                Column(
                  children: [
                    _buildPaymentOption(
                      'Credit/Debit Card',
                      'card',
                      Icons.credit_card,
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      'Wallet',
                      'wallet',
                      Icons.account_balance_wallet,
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      'Pay on Delivery',
                      'cod',
                      Icons.local_shipping,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Promo code
              _buildSection(
                context,
                'Promo Code',
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Price breakdown
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildPriceRow(context, 'Subtotal',
                        '\$${cartProvider.totalPrice.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildPriceRow(
                        context, 'Shipping', 'Free', isPositive: true),
                    const SizedBox(height: 8),
                    _buildPriceRow(context, 'Discount', '\$0.00'),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    _buildPriceRow(
                      context,
                      'Total',
                      '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Place order button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Process order
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully!')),
                    );
                    cartProvider.clear();
                    Navigator.of(context).pushReplacementNamed('/orders');
                  },
                  child: const Text('Place Order'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    Widget child,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildPaymentOption(String label, String value, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPayment == value
                ? const Color(0xFF6366F1)
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _selectedPayment == value ? Colors.indigo[50] : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon,
                color: _selectedPayment == value
                    ? const Color(0xFF6366F1)
                    : Colors.grey[600]),
            const SizedBox(width: 12),
            Text(label),
            const Spacer(),
            Radio<String>(
              value: value,
              groupValue: _selectedPayment,
              onChanged: (newValue) {
                setState(() => _selectedPayment = newValue ?? 'card');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value, {
    bool isPositive = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isPositive ? Colors.green : Colors.black,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}