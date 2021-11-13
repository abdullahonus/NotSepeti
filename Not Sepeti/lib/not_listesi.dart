// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';

import 'kategori_islemleri.dart';
import 'models/kategori.dart';
import 'models/notlar.dart';
import 'not_detay.dart';
import 'utils/database_helper.dart';

class NotListesi extends StatefulWidget {
  @override
  State<NotListesi> createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Kategori> tumKategoriler = <Kategori>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Color(0xff501E4B),
        shadowColor: Colors.black,
        elevation: 20,
        title: const Text(
          "Not Sepeti",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton(
            shape:
                RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
            color: Color(0xff501E4B),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(
                      Icons.import_contacts,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Kategoriler",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _kategorilerSayfasinaGit(context);
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Color(0xff501E4B),
            onPressed: () {
              kategoriEkleDialog(context);
            },
            heroTag: "KategoriEkle",
            tooltip: "Kategori Ekle",
            child: const Icon(
              Icons.import_contacts,
              color: Colors.white,
            ),
            mini: true,
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff501E4B),
            tooltip: "Not Ekle",
            heroTag: "NotEkle",
            onPressed: () => tumKategoriler.length <= 0
                ? _detaySayfasinaGit(context)
                : _scaffoldKey.currentState!.showSnackBar(
                    const SnackBar(
                      content: Text("Kategori Boş!!! Önce Kategori Ekleyiniz."),
                      duration: Duration(seconds: 5),
                    ),
                  ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String? yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Kategori Ekle",
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: Color(0xff501E4B)),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      yeniKategoriAdi = yeniDeger!;
                    },
                    decoration: const InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    // ignore: missing_return
                    validator: (girilenKategoriAdi) {
                      if (girilenKategoriAdi!.length < 1) {
                        return "En az 1 karakter giriniz";
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  OutlineButton(
                    borderSide: BorderSide(color: Color(0xff501E4B)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Color(0xff501E4B),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  OutlineButton(
                    borderSide: BorderSide(color: Color(0xff501E4B)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi!))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            _scaffoldKey.currentState!.showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.black,
                                content: Text("Kategori Eklendi"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Color(0xff501E4B),
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                          color: Color(0xff501E4B),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotDetay(
                  baslik: "Yeni Not",
                  duzenlenecekNot: null,
                ))).then((value) {
      setState(() {});
    });
  }

  void _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Kategoriler()));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late List<Not> tumNotlar;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    tumNotlar = <Not>[];
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleBaslik = Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Montserrat',
        );

    return FutureBuilder(
      future: databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          tumNotlar = snapShot.data!;
          sleep(Duration(milliseconds: 500));
          return ListView.builder(
              itemCount: tumNotlar.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  iconColor: Color(0xff501E4B),
                  collapsedIconColor: Colors.black,
                  leading:
                      _oncelikIconuAta(tumNotlar[index].notOncelik!.toInt()),
                  title: Text(
                    tumNotlar[index].notBaslik.toString(),
                    style: textStyleBaslik,
                  ),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Kategori",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tumNotlar[index].kategoriBaslik.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff501E4B)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Oluşturulma Tarihi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  databaseHelper.dateFormat(DateTime.parse(
                                      tumNotlar[index].notTarih.toString())),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff501E4B)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    "İçerik",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 15),
                                child: Text(
                                  tumNotlar[index].notIcerik.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.blueGrey),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              OutlineButton(
                                  borderSide:
                                      BorderSide(color: Color(0xff501E4B)),
                                  onPressed: () =>
                                      _notSil(tumNotlar[index].notID!.toInt()),
                                  child: Text(
                                    "SİL",
                                    style: TextStyle(
                                        color: Color(0xff501E4B),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              OutlineButton(
                                  borderSide:
                                      BorderSide(color: Color(0xff501E4B)),
                                  onPressed: () {
                                    _detaySayfasinaGit(
                                        context, tumNotlar[index]);
                                  },
                                  child: Text(
                                    "GÜNCELLE",
                                    style: TextStyle(
                                        color: Color(0xff501E4B),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        } else {
          return Center(
              child: Text(
            "Yükleniyor...",
            style: TextStyle(
                color: Color(
                  0xff501E4B,
                ),
                fontSize: 16),
          ));
        }
      },
    );
  }

  _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotDetay(
                  baslik: "Notu Düzenle",
                  duzenlenecekNot: not,
                ))).then((value) {
      setState(() {});
    });
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "DÜŞÜK",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey.shade200);

      case 1:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ORTA",
              style: TextStyle(
                  color: Colors.deepOrange.shade600,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey.shade200);
      case 2:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ACIL",
              style: TextStyle(
                  color: Colors.deepOrange.shade900,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey.shade200);
    }
  }

  _notSil(int notID) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black, content: Text("Not Silindi")));

        setState(() {});
      }
    });
  }
}
