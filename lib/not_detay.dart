// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:not_sepeti/models/kategori.dart';

import 'models/notlar.dart';
import 'utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  String? baslik;
  Not? duzenlenecekNot;

  NotDetay({Key? key, this.baslik, this.duzenlenecekNot}) : super(key: key);

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DatabaseHelper databaseHelper;
  late int kategoriID;
  late int secilenOncelik;
  Kategori? secilenKategori;
  late String notBaslik, notIcerik;
  static final _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = <Kategori>[];
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((kategoriIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in kategoriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }

      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot!.kategoriID!;
        secilenOncelik = widget.duzenlenecekNot!.notOncelik!;
      } else {
        kategoriID = 1;
        secilenOncelik = 0;
        secilenKategori = tumKategoriler[0];
        debugPrint("secilen kategoriye deger atandı" +
            secilenKategori!.kategoriBaslik);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Color(0xff501E4B),
        title: Text(widget.baslik.toString()),
      ),
      body: tumKategoriler.isEmpty
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Kategori :",
                            style: TextStyle(
                                color: Color(0xff501E4B),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff501E4B), width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<Kategori>(
                                  items: kategoriItemleriOlustur(),
                                  hint: const Text("Kategori Seç"),
                                  value: secilenKategori,
                                  onChanged:
                                      (Kategori? kullanicininSectigiKategori) {
                                    debugPrint("Seçilen kategori:" +
                                        kullanicininSectigiKategori.toString());
                                    setState(() {
                                      secilenKategori =
                                          kullanicininSectigiKategori!;
                                      kategoriID = kullanicininSectigiKategori
                                          .kategoriID!;
                                    });
                                  })),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notBaslik
                            : "",
                        // ignore: missing_return
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "En az 1 karakter olmalı";
                          }
                        },
                        onSaved: (text) {
                          notBaslik = text!;
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          hintText: "Not başlığını giriniz",
                          labelText: "Başlık",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff501E4B), width: 2.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notIcerik
                            : "",
                        onSaved: (text) {
                          notIcerik = text!;
                        },
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "Not içeriğini giriniz",
                          labelText: "İçerik",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff501E4B), width: 2.0)),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Öncelik :",
                            style: TextStyle(
                                color: Color(0xff501E4B),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff501E4B), width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                  items: _oncelik.map((oncelik) {
                                    return DropdownMenuItem<int>(
                                      child: Text(
                                        oncelik,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      value: _oncelik.indexOf(oncelik),
                                    );
                                  }).toList(),
                                  value: secilenOncelik,
                                  onChanged: (secilenOncelikID) {
                                    setState(() {
                                      secilenOncelik = secilenOncelikID!;
                                    });
                                  })),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "VAZGEÇ",
                              style: TextStyle(
                                  color: Colors.red[500],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            )),
                        OutlinedButton(
                            onPressed: () {
                              setState(() {});
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                var suan = DateTime.now();
                                if (widget.duzenlenecekNot == null) {
                                  databaseHelper
                                      .notEkle(Not(
                                          kategoriID,
                                          notBaslik,
                                          notIcerik,
                                          suan.toString(),
                                          secilenOncelik))
                                      .then((kaydedilenNotID) {
                                    if (kaydedilenNotID != 0) {
                                      Navigator.pop(context);
                                    }
                                  });
                                } else {
                                  databaseHelper
                                      .notGuncelle(Not.withID(
                                          widget.duzenlenecekNot!.notID,
                                          kategoriID,
                                          notBaslik,
                                          notIcerik,
                                          suan.toString(),
                                          secilenOncelik))
                                      .then((guncellenenID) {
                                    if (guncellenenID != 0) {
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              }
                            },
                            child: const Text(
                              "KAYDET",
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
            ),
    );
  }

  List<DropdownMenuItem<Kategori>> kategoriItemleriOlustur() {
    return tumKategoriler.map((kategorim) {
      return DropdownMenuItem<Kategori>(
        value: kategorim,
        child: Text(
          kategorim.kategoriBaslik,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }).toList();
  }
}
