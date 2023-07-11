import 'package:ayni_treasures/Controller/shoppingcartitem_controller.dart';
import 'package:ayni_treasures/Entity/user_entity.dart';
import 'package:ayni_treasures/Model/user_model.dart';
import 'package:flutter/rendering.dart';
import '../Entity/product_entity.dart';
import '../Controller/product_controller.dart';
import 'package:flutter/material.dart';
import '../Entity/shoppingcartitem_entity.dart';
import 'components/math_calculations.dart';
import 'styles.dart';
import 'components/custom_components.dart';
import 'components/bottom_navbar.dart';
import 'components/singleton_envVar.dart';
import 'components/custom_futurebuilder.dart';

//textfield formatter
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

//Opciones del radio
//List<String> options = ['Option 1','Option 2'];

class _ProductDetailPageState extends State<ProductDetailPage> {
  //Obtiene el id preciso del singleton
  String idCurrentProduct = appData.productselectedid;
  //Controla que imagen ha sido seleccionada para ser vista
  int selectedImage = 0;
  //Comprueba si el usuario quiere seguir leyendo o no
  bool isReadMore = false;
  //Opcion actual del radio
  String selectedRadioValue = 'kilos';

  //Mascara con regex usando dependencia para el formateo del input de la cantidad
  MaskTextInputFormatter maskFormatterQuantityKilos = MaskTextInputFormatter(
    mask: '##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  MaskTextInputFormatter maskFormatterQuantityGramos = MaskTextInputFormatter(
    mask: '##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  //Variable del total
  String totalValue = '0.';

  //Actualizar el valor del input y el total de cantidad ingresada
  String quantityInputValue = '';

  void updateInputQuantityAndTotal(String val, String price) {
    setState(() {
      quantityInputValue = val;
      //Actualiza el campo total
      totalValue =
          calculateTotal(quantityInputValue, selectedRadioValue, price);
    });
  }

  //Calcula el total, de acuerdo a la cantidad seleccionada
  String calculateTotal(
      String? quantity, String selectedMeasure, String price) {
    if (quantity == '' || quantity == null) {
      return '0.';
    } else {
      final doubleQuantity = double.parse(quantity);
      double total;
      switch (selectedMeasure) {
        case 'kilos':
          //multiplica el precio por la cantidad seleccionada
          total = doubleQuantity *
              (double.parse(MathCalculations().convertToKilos(price)));
          return MathCalculations().roundedValueTwoDecimals(total);
        case 'gramos':
          total = doubleQuantity *
              (double.parse(MathCalculations().convertTo50Grams(price)));
          return MathCalculations().roundedValueTwoDecimals(total);
        default:
          return 'error en switch';
      }
    }
  }

  void addToCart(
      {required String idproduct,
      required String productname,
      required String productprice,
      required String mainimage,
      required String selectedmeasure,
      required String totalquantity,
      required String discount,
      required String totalprice,
      required String totalwithdiscount}) async {
    if (totalValue != '') {
      // final ShoppingCartItem cartItem = ShoppingCartItem(
      //   iduser: appData.currentUserId!,
      //   idproduct: idproduct,
      //   idcartitem: idcartitem,
      //   productname: productname,
      //   productprice: productprice,
      //   mainimage: mainimage,
      //   selectedmeasure: selectedmeasure,
      //   totalquantity: totalquantity,
      //   discount: discount,
      //   totalprice: totalprice,
      //   totalwithdiscount: totalwithdiscount);
      // appData.cartItems.add(cartItem);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomFutureBuilder<dynamic>(
              future: () => ShoppingCartItemController().postShoppingCartItem(
                  iduser: appData.currentUserId!,
                  idproduct: idproduct,
                  productname: productname,
                  productprice: productprice,
                  mainimage: mainimage,
                  selectedmeasure: selectedmeasure,
                  totalquantity: totalquantity,
                  discount: discount,
                  totalprice: totalprice,
                  totalwithdiscount: totalwithdiscount),
              builder: (context, cartItem) {
                final ShoppingCartItem cartItemEntity = cartItem["body"];
                //Se guarda la id del usuario de manera
                return CustomComponents.makeSimpleDialogWithButtons(
                    context: context,
                    title: 'Aviso',
                    content:
                        '${cartItemEntity.productname}(${cartItemEntity.totalquantity} ${cartItemEntity.selectedmeasure == 'kilos' ? 'kg.' : 'X 50gr.'}) agregado al carrito',
                    callbackFn: () => {
                          CustomComponents.callbackNav(
                              context: context, route: '/cart')
                        },
                    mainBtnContent: 'Ir a la Jaba');
              },
              loadingWidget: const CircularProgressIndicator(),
            );
          },
          barrierDismissible: false
      );
      // //Se envia a la pagina de inicio despues de 3 segundos
      // Timer(const Duration(seconds: 5),()=>{
      //   Navigator.of(context).pushNamed(route)
      // });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    //actualiza con el estado del texto del input
    //quantityController.addListener(updateInputQuantity);
  }

  //Llama al controlador del producto individual seleccionado
  Future<Product> getChosenProduct(String idProduct) async {
    return await ProductController().getProductById(idProduct);
  }

  //Construye todo el contenido
  Widget buildProduct(BuildContext context, Product product) {
    List<String> imgUrls = [
      product.mainimage,
      product.addimage1,
      product.addimage2
    ];

    return ListView(
      children: [
        const SizedBox(height: 16),
        buildMainImage(product.fullname, imgUrls[selectedImage], product.price),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(imgUrls.length,
                (index) => buildSmallPicture(imgUrls[index], index))
          ],
        ),
        const SizedBox(height: 4),
        buildDescription(product),
        const SizedBox(height: 4),
        buildPriceAndTotalInfo(product),
        const SizedBox(height: 4),
        buildNutritionalInfo(product),
      ],
    );
  }

  Padding buildNutritionalInfo(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        color: customWhite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.makeText(
                  headingType: 'H4',
                  data: 'Valor nutricional y calórico',
                  color: customPrimary,
                  textAlign: TextAlign.center),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomComponents.makeText(
                headingType: 'P2',
                data: product.etimology,
                color: customDarkGray,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                CustomComponents.makeText(
                  headingType: 'H6',
                  data: 'Origen:',
                  color: customPrimary,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  width: 4,
                ),
                CustomComponents.makeText(
                  headingType: 'PR2',
                  data: product.origin,
                  color: customDarkGray,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Row(
              children: [
                CustomComponents.makeText(
                  headingType: 'H6',
                  data: 'Porción:',
                  color: customPrimary,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  width: 4,
                ),
                CustomComponents.makeText(
                  headingType: 'PR2',
                  data: '100 gr.',
                  color: customDarkGray,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            //detail: product.carbs,label: 'Carbs. X porción'
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLittleDetails(detail: product.carbs, label: 'Carbs'),
                buildLittleDetails(
                    detail: product.proteins, label: 'Proteínas'),
                buildLittleDetails(detail: product.kcal, label: 'Kcal'),
                buildLittleDetails(detail: product.fats, label: 'Grasas'),
              ],
            )
            //     //El numero maximo de lineas depende de la eleccion del usuario
            //     maxLines: isReadMore ? null : 2,
            //     textOverflowType: isReadMore
            //         ? TextOverflow.visible
            //         : TextOverflow.ellipsis),
            // const SizedBox(height: 8),
            // //Boton leer más
            // buttonReadMore()
          ]),
        ),
      ),
    );
  }

  SizedBox buildLittleDetails({required String detail, required String label}) {
    return SizedBox(
      height: 80,
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomComponents.makeText(
            headingType: 'H5',
            data: '${double.parse(detail)}',
            color: customBlack,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 4,
          ),
          CustomComponents.makeText(
            headingType: 'H6',
            data: label,
            color: customPrimary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Padding buildPriceAndTotalInfo(Product product) {
    //totalValue=selectedRadioValue=='kilos'? MathCalculations().convertToKilos(product.price):product.price;
    String priceKilosConverted = MathCalculations().roundedValueTwoDecimals(
        double.parse(MathCalculations().convertToKilos(product.price)));
    String formattedKilos =
        MathCalculations().roundedValueTwoDecimalsFormatting(product.price);
    String priceGramosConverted = MathCalculations().roundedValueTwoDecimals(
        double.parse(MathCalculations().convertTo50Grams(product.price)));
    String formattedGramos =
        MathCalculations().roundedValueTwoDecimalsFormatting(product.price);
    final price = selectedRadioValue == 'kilos'
        ? '$priceKilosConverted$formattedKilos'
        : '$priceGramosConverted$formattedGramos';
    final measure = selectedRadioValue == 'kilos' ? 'x Kg.' : 'x 50gr.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        color: customWhite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomComponents.makeText(
                    headingType: 'H4',
                    data: 'Precios',
                    color: customPrimary,
                    textAlign: TextAlign.center),
                Material(
                  color: customSecondary,
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: CustomComponents.makeText(
                          headingType: 'P1',
                          data: 'S/. $price $measure',
                          color: customBackground)),
                )
              ],
            ),
            //Row radio medidas
            buildRadioField(),
            //const SizedBox(height: 4),
            //input cantidad
            buildQuatityInputRow(product.price),
            const SizedBox(height: 4),
            //fila del total
            buildTotalRow(),
            const SizedBox(height: 4),
            //Cart button
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomComponents.makeButtonWithIcon(
                btnColor: customSecondary,
                callback: () {addToCart(idproduct: product.idproduct, 
                productname: product.fullname, 
                productprice: product.price, 
                mainimage: product.mainimage, 
                selectedmeasure: selectedRadioValue, 
                totalquantity: quantityInputValue, 
                discount: product.descount, 
                totalprice: totalValue, 
                totalwithdiscount:MathCalculations().getDiscountedPrice(totalPrice: totalValue, discount: product.descount)
                );},
                content: 'Agregar a la Jaba',
                iconParam: const Icon(
                  Icons.shopping_basket_outlined,
                  color: customBackground,
                ),
                size: 'Big',
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  //Construye la fila del total
  Padding buildTotalRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: customPrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomComponents.makeText(
                headingType: 'P1',
                data: 'Total:',
                color: customDarkGray,
                textAlign: TextAlign.start),
            CustomComponents.makeText(
                headingType: 'H4',
                data:
                    'S/. $totalValue${MathCalculations().roundedValueTwoDecimalsFormatting(totalValue)}',
                color: customBlack,
                textAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }

  //Construye una fila con el input de cantidad
  Padding buildQuatityInputRow(String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.makeText(
              headingType: 'P1',
              data: 'Cantidad:',
              color: customDarkGray,
              textAlign: TextAlign.start),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                //Ancho de acuerdo a la seleccion del usuario
                width: selectedRadioValue == 'kilos' ? 50 : 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: customInputGray),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  onChanged: (value) {
                    updateInputQuantityAndTotal(value, price);
                  },
                  //controller: quantityController,
                  //formateo con dependencia
                  inputFormatters: [
                    selectedRadioValue == 'kilos'
                        ? maskFormatterQuantityKilos
                        : maskFormatterQuantityGramos,
                  ],
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      hintText: selectedRadioValue == 'kilos' ? '00' : '00',
                      border: InputBorder.none),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              CustomComponents.makeText(
                  headingType: 'P1',
                  data: selectedRadioValue == 'kilos' ? 'Kg.' : 'x 50gr.',
                  color: customPrimary)
            ],
          ),
        ],
      ),
    );
  }

  //Construye el campo de radio, esta vinculado a la funcion 'buildRowRadio'
  Padding buildRadioField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.makeText(
              headingType: 'P1',
              data: 'Medida:',
              color: customDarkGray,
              textAlign: TextAlign.start),
          buildRowRadio(),
        ],
      ),
    );
  }

  //Construye un radio que funcionciona como un redio tile pero se puede meter dentro de otro row
  Row buildRowRadio() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedRadioValue = 'kilos';
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio(
                activeColor: customSecondary,
                value: 'kilos',
                groupValue: selectedRadioValue,
                onChanged: (value) {
                  setState(() {
                    selectedRadioValue = value.toString();
                  });
                },
              ),
              CustomComponents.makeText(
                  headingType: 'PR2', data: 'Kilos', color: customPrimary),
            ],
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () {
            setState(() {
              selectedRadioValue = 'gramos';
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio(
                activeColor: customSecondary,
                value: 'gramos',
                groupValue: selectedRadioValue,
                onChanged: (value) {
                  setState(() {
                    selectedRadioValue = value.toString();
                  });
                },
              ),
              CustomComponents.makeText(
                  headingType: 'PR2', data: 'Gramos', color: customPrimary),
            ],
          ),
        ),
      ],
    );
  }

  //Construye la sección descripción
  Padding buildDescription(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        color: customWhite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.makeText(
                  headingType: 'H4',
                  data: 'Descripción',
                  color: customPrimary,
                  textAlign: TextAlign.center),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomComponents.makeText(
                headingType: 'PR2',
                data: product.description,
                color: customDarkGray,
                textAlign: TextAlign.start,
                //El numero maximo de lineas depende de la eleccion del usuario
                maxLines: isReadMore ? null : 2,
                textOverflowType:
                    isReadMore ? TextOverflow.visible : TextOverflow.ellipsis),
            const SizedBox(height: 8),
            //Boton leer más
            buttonReadMore()
          ]),
        ),
      ),
    );
  }

  //Boton 'leer más', usa una variable global booleana y setstate
  ElevatedButton buttonReadMore() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        side: const BorderSide(width: 2, color: customSecondary),
        backgroundColor: customWhite,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
      onPressed: () => setState(() => isReadMore = !isReadMore),
      child: CustomComponents.makeText(
          headingType: 'H6',
          data: isReadMore ? 'Esconder texto' : 'Seguir leyendo',
          color: customSecondary),
    );
  }

  //Construye imagen pequeña
  GestureDetector buildSmallPicture(String url, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(right: 4),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: customWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: selectedImage == index
                  ? customSecondary
                  : Colors.transparent),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: customDarkGray,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  //Construye a imagen principal
  Container buildMainImage(String nameProduct, String imgUrl, String price) {
    final priceConverted = MathCalculations().roundedValueTwoDecimals(
        double.parse(MathCalculations().convertToKilos(price)));
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Container(
        //constraints: const BoxConstraints.expand(),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: customBlack,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomComponents.makeText(
                      headingType: 'H2',
                      data: nameProduct,
                      color: customBackground,
                      textAlign: TextAlign.start),
                  Material(
                    color: customSecondary,
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: CustomComponents.makeText(
                            headingType: 'PR2',
                            data:
                                'S/. $priceConverted${MathCalculations().roundedValueTwoDecimalsFormatting(priceConverted)} x Kg.',
                            color: customBackground)),
                  )
                ],
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final argumentsProductSelectedSubcategory =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      backgroundColor: customBackground,
      extendBodyBehindAppBar: false,
      drawer: const Drawer(),
      appBar: CustomComponents.makeSimpleAppbar(
          context: context,
          title: argumentsProductSelectedSubcategory,
          color: customPrimary,
          colorLeadingIcon: customBackground),
      body: CustomFutureBuilder(
        future: () => getChosenProduct(idCurrentProduct),
        builder: (context, product) => buildProduct(context, product!),
        loadingWidget: const CircularProgressIndicator(
          color: customPrimary,
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
