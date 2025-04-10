import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_frontend/views/BazarProductsReview.dart';
import 'package:provider/provider.dart';
import '../Models/ProductModel.dart';
import '../Providers/BazarProvider.dart';
import '../widgets/customizeTextFormField.dart';
import '../widgets/Dimensions.dart';

class BazarVariations extends StatefulWidget {
  static String id = "bazarVariations";
  const BazarVariations({super.key});

  @override
  State<BazarVariations> createState() => _BazarVariationsState();
}

class _BazarVariationsState extends State<BazarVariations> {
  int currentIndex = 0;
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, TextEditingController> _offerControllers = {};

  bool _isLoading = true;
  List<String> _productIds = [];

  @override
  void dispose() {
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (var controller in _offerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;
    if (_isLoading) {
      _productIds = args;
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    final provider = Provider.of<BazarProvider>(context, listen: false);
    await provider.productVariation(_productIds);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BazarProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.myProducts.isEmpty
            ? const Center(child: Text("No products found."))
            : _buildContent(provider),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 85 * SizeConfig.verticalBlock,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF223F4A), Color(0xFF5095B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,
            color: Colors.white, size: SizeConfig.textRatio * 15),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Join Bazar',
        style: GoogleFonts.rubik(
            color: Colors.white, fontSize: 20 * SizeConfig.textRatio),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
    );
  }

  Widget _buildContent(BazarProvider provider) {
    final product = provider.myProducts[currentIndex];
    _offerControllers[product.id] ??=
        TextEditingController(text: provider.getOffer(product.id));

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            20 * SizeConfig.verticalBlock,
        left: 16 * SizeConfig.horizontalBlock,
        right: 16 * SizeConfig.horizontalBlock,
        top: 20 * SizeConfig.verticalBlock,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductCard(product),
          const SizedBox(height: 20),
          Text("Offer", style: GoogleFonts.roboto(fontSize: 18)),
          MyTextFormField(
            controller: _offerControllers[product.id!]!,
            hintName: "EX: 50%",
            onChanged: (value) => provider.setOffer(product.id!, value),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Variations", style: GoogleFonts.roboto(fontSize: 20)),
              Text("Quantity", style: GoogleFonts.roboto(fontSize: 20)),
            ],
          ),
          ..._buildVariations(provider, product),
          const SizedBox(height: 20),
          _buildNavigation(provider),
        ],
      ),
    );
  }

  Widget _buildProductCard(productModel product) {
    return Container(
      padding: EdgeInsets.all(12 * SizeConfig.horizontalBlock),
      decoration: BoxDecoration(
        border: Border.all(color: SizeConfig.iconColor),
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5 * SizeConfig.textRatio)),
            child: Image.network(
              product.imageURL ?? '',
              width: 100 * SizeConfig.horizontalBlock,
              height: 100 * SizeConfig.verticalBlock,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name ?? '',
                    style: GoogleFonts.roboto(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(product.category ?? '',
                    style: const TextStyle(color: Colors.grey)),
                Text("${product.price ?? 0} EGP",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildVariations(BazarProvider provider, productModel product) {
    final variations = product.variationsWithIds ?? {};

    return variations.entries.map((entry) {
      final variationId = entry.key;
      final variationAttributes = entry.value.join(" | ");
      final isSelected = provider.productSelections[variationId] ?? false;

      _quantityControllers[variationId] ??=
          TextEditingController(text: provider.getQuantity(variationId));

      if (_quantityControllers[variationId]!.text !=
          provider.getQuantity(variationId)) {
        _quantityControllers[variationId]!.text =
            provider.getQuantity(variationId);
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => provider.displayQuantity(variationId)),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0x50E9E9E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? SizeConfig.iconColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(variationAttributes),
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (isSelected)
              SizedBox(
                width: 130 * SizeConfig.horizontalBlock,
                height: 65 * SizeConfig.verticalBlock,
                child: MyTextFormField(
                  controller: _quantityControllers[variationId],
                  hintName: "Quantity",
                  autofocus: false,
                  width: 119 * SizeConfig.horizontalBlock,
                  type: TextInputType.number,
                  onChanged: (value) => provider.setQuantity(variationId, value),
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildNavigation(BazarProvider provider) {
    final total = provider.myProducts.length;
    final product = provider.myProducts[currentIndex];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentIndex > 0)
              _buildNavButton("Back", Icons.arrow_back, Colors.white,
                  SizeConfig.iconColor, () => setState(() => currentIndex--)),
            if (currentIndex < total - 1)
              _buildNavButton("Next", Icons.arrow_forward, Colors.white,
                  SizeConfig.iconColor, () {
                    if (_isPageValid(provider, product)) {
                      setState(() => currentIndex++);
                    }
                  }),
            if (currentIndex == total - 1)
              _buildNavButton("Finish", Icons.check, Colors.white,
                  SizeConfig.iconColor, () {
                    if (_isPageValid(provider, product)) {
                      Navigator.pushNamed(context, BazarReview.id);
                    }
                  }),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            total,
                (i) => Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == currentIndex ? SizeConfig.iconColor : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(String label, IconData icon, Color textColor,
      Color backgroundColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 50 * SizeConfig.verticalBlock,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: backgroundColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: GoogleFonts.rubik(color: textColor)),
              const SizedBox(width: 8),
              Icon(icon, color: textColor),
            ],
          ),
        ),
      ),
    );
  }

  bool _isPageValid(BazarProvider provider, productModel product) {
    final offer = provider.getOffer(product.id);
    final variations = product.variationsWithIds ?? {};

    final hasAtLeastOneQuantity = variations.keys.any((id) {
      final qty = provider.getQuantity(id);
      return qty.isNotEmpty && int.tryParse(qty) != null && int.parse(qty) > 0;
    });

    if (offer.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an offer for this product.")),
      );
      return false;
    }

    if (!hasAtLeastOneQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please add quantity to at least one variation.")),
      );
      return false;
    }

    return true;
  }
}
