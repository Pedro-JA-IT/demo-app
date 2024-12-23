import 'package:flutter/material.dart';

class test extends StatelessWidget {
  const test({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.amber[500],
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Tooltip(
            message: 'list of options',
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.amber,
                )),
          ),

          //Icon(Icons.list, color: Colors.amber, size: 30  ),

          title: const Text("ZEE Shop", style: TextStyle(color: Colors.amber)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.amber,
              ),
              tooltip: "tap to search for a product",
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Shopping cart',
            ),
          ],
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.white),
          currentIndex: 0,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.white,
          onTap: (index) {},
        ),
        body: Container(
            color: Colors.amber[600],
            child: ListView(children: [
              Container(
                  height: 400,
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  // height: 300,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNjRKoppiOcJ4t45wGpP00H_IEzp3V49ossXd5MlllIj8E1hGLJUy6tjpJQKN4WC2AO40&usqp=CAU'),
                        Container(
                          height: 20,
                        ),
                        const Text(
                          "ButterFly Knife",
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                        const Text(
                          "Price:   25 USD",
                          style: TextStyle(color: Colors.amber),
                        ),
                        MaterialButton(
                          onPressed: () {
                            print("purchased");
                          },
                          child: Container(
                              width: 85,
                              margin: EdgeInsets.all(15),
                              color: Colors.amber,
                              child: const Row(children: [
                                Text("Purchase", style: TextStyle()),
                                Icon(
                                  Icons.shopify_outlined,
                                  color: Colors.black, // )],
                                ),
                              ])),
                        )
                      ])),
              //=============second item =================
              Container(
                  height: 400,
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  // height: 300,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                            height: 220,
                            'https://www.nutravita.co.uk/cdn/shop/products/01ResistanceBandsMarketing.png?v=1654070997&width=1000'),
                        Container(
                          height: 20,
                        ),
                        const Text(
                          "Resistance band",
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                        const Text(
                          "Price:   10 USD",
                          style: TextStyle(color: Colors.amber),
                        ),
                        MaterialButton(
                          onPressed: () {
                            print("purchased");
                          },
                          child: Container(
                              width: 85,
                              margin: EdgeInsets.all(15),
                              color: Colors.amber,
                              child: const Row(children: [
                                Text("Purchase", style: TextStyle()),
                                Icon(
                                  Icons.shopify_outlined,
                                  color: Colors.black, // )],
                                ),
                              ])),
                        )
                      ])),
              Container(
                  height: 400,
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  // height: 300,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                            height: 220,
                            width: 250,
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNEuTkVsdlbpxlvzypSYfu3l6kxzhSPGUvGQ&s'),
                        Container(
                          height: 20,
                        ),
                        const Text(
                          "Jacket",
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                        const Text(
                          "Price:   40 USD",
                          style: TextStyle(color: Colors.amber),
                        ),
                        MaterialButton(
                          onPressed: () {
                            print("purchased");
                          },
                          child: Container(
                              width: 85,
                              margin: EdgeInsets.all(15),
                              color: Colors.amber,
                              child: const Row(children: [
                                Text("Purchase", style: TextStyle()),
                                Icon(
                                  Icons.shopify_outlined,
                                  color: Colors.black, // )],
                                ),
                              ])),
                        )
                      ]))
            ])));
  }
}
