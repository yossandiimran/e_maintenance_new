// ignore_for_file: file_names
part of "../header.dart";

class AnggotaModel {
  bool? success;
  String? message;
  DataAnggota? data;

  AnggotaModel({success, message, data});

  AnggotaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? DataAnggota.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataAnggota {
  int? id;
  int? reffId;
  String? name;
  String? username;
  String? email;
  String? emailVerifiedAt;
  bool? firstLogin;
  DataDetail? data;

  DataAnggota({id, reffId, name, username, email, emailVerifiedAt, firstLogin, data});

  DataAnggota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reffId = json['reff_id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    firstLogin = json['first_login'];
    data = json['data'] != null ? DataDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reff_id'] = reffId;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['first_login'] = firstLogin;
    data['data'] = this.data!.toJson();
    return data;
  }
}

class DataDetail {
  int? id;
  bool? anggotaBaru;
  String? kodeAnggota;
  String? tipeAnggota;
  String? golongan;
  String? plafon;
  String? saldoSimpanan;
  String? saldoPinjaman;
  int? status;
  String? tanggalPermohonan;
  String? buktiPermohonan;
  String? tanggalPersetujuan;
  String? tanggalPernyataan;
  Info? info;

  DataDetail(
      {id,
      anggotaBaru,
      kodeAnggota,
      tipeAnggota,
      golongan,
      plafon,
      saldoSimpanan,
      saldoPinjaman,
      status,
      tanggalPermohonan,
      buktiPermohonan,
      tanggalPersetujuan,
      tanggalPernyataan,
      info});

  DataDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    anggotaBaru = json['anggota_baru'];
    kodeAnggota = json['kode_anggota'];
    tipeAnggota = json['tipe_anggota'];
    golongan = json['golongan'];
    plafon = json['plafon'];
    saldoSimpanan = json['saldo_simpanan'];
    saldoPinjaman = json['saldo_pinjaman'];
    status = json['status'];
    tanggalPermohonan = json['tanggal_permohonan'];
    buktiPermohonan = json['bukti_permohonan'];
    tanggalPersetujuan = json['tanggal_persetujuan'];
    tanggalPernyataan = json['tanggal_pernyataan'];
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['anggota_baru'] = anggotaBaru;
    data['kode_anggota'] = kodeAnggota;
    data['tipe_anggota'] = tipeAnggota;
    data['golongan'] = golongan;
    data['plafon'] = plafon;
    data['saldo_simpanan'] = saldoSimpanan;
    data['saldo_pinjaman'] = saldoPinjaman;
    data['status'] = status;
    data['tanggal_permohonan'] = tanggalPermohonan;
    data['bukti_permohonan'] = buktiPermohonan;
    data['tanggal_persetujuan'] = tanggalPersetujuan;
    data['tanggal_pernyataan'] = tanggalPernyataan;
    if (info != null) {
      data['info'] = info!.toJson();
    }
    return data;
  }
}

class Info {
  int? id;
  String? nik;
  String? nama;
  String? tglLahir;
  bool? jenisKelamin;
  String? alamat;
  String? kelurahan;
  String? kecamatan;
  String? kota;
  String? kodePos;
  String? noHp;
  String? fFoto;
  String? fKtp;
  String? nrp;
  String? wSite;
  String? pSite;
  String? bagian;
  int? statgaji;
  String? norekBank;
  String? fNorek;
  String? npwp;
  String? alamatDom;
  String? kelurahanDom;
  String? kecamatanDom;
  String? kotaDom;
  String? kodePosDom;
  String? fDokumen;

  Info(
      {id,
      nik,
      nama,
      tglLahir,
      jenisKelamin,
      alamat,
      kelurahan,
      kecamatan,
      kota,
      kodePos,
      noHp,
      fFoto,
      fKtp,
      nrp,
      wSite,
      pSite,
      bagian,
      statgaji,
      norekBank,
      fNorek,
      npwp,
      alamatDom,
      kelurahanDom,
      kecamatanDom,
      kotaDom,
      kodePosDom,
      fDokumen});

  Info.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nik = json['nik'];
    nama = json['nama'];
    tglLahir = json['tgl_lahir'];
    jenisKelamin = json['jenis_kelamin'];
    alamat = json['alamat'];
    kelurahan = json['kelurahan'];
    kecamatan = json['kecamatan'];
    kota = json['kota'];
    kodePos = json['kode_pos'];
    noHp = json['no_hp'];
    fFoto = json['f_foto'];
    fKtp = json['f_ktp'];
    nrp = json['nrp'];
    wSite = json['w_site'];
    pSite = json['p_site'];
    bagian = json['bagian'];
    statgaji = json['statgaji'];
    norekBank = json['norek_bank'];
    fNorek = json['f_norek'];
    npwp = json['npwp'];
    alamatDom = json['alamat_dom'];
    kelurahanDom = json['kelurahan_dom'];
    kecamatanDom = json['kecamatan_dom'];
    kotaDom = json['kota_dom'];
    kodePosDom = json['kode_pos_dom'];
    fDokumen = json['f_dokumen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nik'] = nik;
    data['nama'] = nama;
    data['tgl_lahir'] = tglLahir;
    data['jenis_kelamin'] = jenisKelamin;
    data['alamat'] = alamat;
    data['kelurahan'] = kelurahan;
    data['kecamatan'] = kecamatan;
    data['kota'] = kota;
    data['kode_pos'] = kodePos;
    data['no_hp'] = noHp;
    data['f_foto'] = fFoto;
    data['f_ktp'] = fKtp;
    data['nrp'] = nrp;
    data['w_site'] = wSite;
    data['p_site'] = pSite;
    data['bagian'] = bagian;
    data['statgaji'] = statgaji;
    data['norek_bank'] = norekBank;
    data['f_norek'] = fNorek;
    data['npwp'] = npwp;
    data['alamat_dom'] = alamatDom;
    data['kelurahan_dom'] = kelurahanDom;
    data['kecamatan_dom'] = kecamatanDom;
    data['kota_dom'] = kotaDom;
    data['kode_pos_dom'] = kodePosDom;
    data['f_dokumen'] = fDokumen;
    return data;
  }
}
