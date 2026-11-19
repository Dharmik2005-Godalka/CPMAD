import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';

class CheckoutScreen extends StatefulWidget 
{
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> 
{
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  final Map<String, IconData> _paymentMethods = const 
  {
    'Cash on Delivery': Icons.payments,
    'UPI': Icons.account_balance_wallet,
    'Credit / Debit Card': Icons.credit_card,
  };
  String _payment = 'Cash on Delivery';

  @override
  void dispose() 
  {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async 
  {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    final total = cart.total;
    final itemCount = cart.totalQuantity;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 56),
        title: const Text('Order placed!'),
        content: Text(
          'Thank you, ${_nameController.text.trim()}.\n'
          '$itemCount items  •  ${formatPrice(total)}\n'
          'Payment: $_payment',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    cart.clear();
    // Go back to the product list
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) 
  {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildTitle('Delivery address'),
          buildAddressForm(),
          const SizedBox(height: 20),
          buildTitle('Order summary'),
          buildOrderSummary(cart),
          const SizedBox(height: 20),
          buildTitle('Payment method'),
          buildPaymentOptions(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: cart.isEmpty ? null : _placeOrder,
              child: Text('Place order  •  ${formatPrice(cart.total)}'),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(String text) 
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Address 
  Widget buildAddressForm() 
  {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          buildField(
            controller: _nameController,
            label: 'Full name',
            icon: Icons.person,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
          ),

          buildField(
            controller: _phoneController,
            label: 'Phone number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (v) => (v == null || v.length != 10)
                ? 'Enter a valid 10-digit phone number'
                : null,
          ),

          buildField(
            controller: _addressController,
            label: 'Address',
            icon: Icons.home,
            maxLines: 2,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter your address' : null,
          ),

          buildField(
            controller: _cityController,
            label: 'City',
            icon: Icons.location_city,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter your city' : null,
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
  }) 
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Order 
  Widget buildOrderSummary(CartProvider cart) 
  {
    final taxPercent = (CartProvider.taxRate * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ...cart.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.title} × ${item.quantity}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(formatPrice(item.subtotal)),
                  ],
                ),
              ),
            ),
            const Divider(),
            buildRow('Subtotal', formatPrice(cart.subtotal)),
            buildRow('Tax ($taxPercent%)', formatPrice(cart.tax)),
            buildRow('Total', formatPrice(cart.total), bold: true),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value, {bool bold = false}) 
  {
    final style = TextStyle(
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  // Payment 
  Widget buildPaymentOptions() 
  {
    return Column(
      children: _paymentMethods.entries.map((entry) 
      {
        final selected = _payment == entry.key;

        return Card(
          color: selected ? Colors.teal.shade50 : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selected ? Colors.teal : Colors.grey.shade300,
            ),
          ),
          child: ListTile(
            leading: Icon(entry.value),
            title: Text(entry.key),
            trailing: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Colors.teal : Colors.grey,
            ),
            onTap: () => setState(() => _payment = entry.key),
          ),
        );
      }).toList(),
    );
  }
}
