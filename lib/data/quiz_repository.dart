import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/quiz_category.dart';

/// Local, hand-written question bank. No network or database is involved.
abstract final class QuizRepository {
  static const List<QuizCategory> categories = [
    QuizCategory(
      id: 'rimba',
      name: 'Rimba & Satwa',
      tagline: 'Flora, fauna, dan penghuni hutan',
      icon: Icons.park_outlined,
    ),
    QuizCategory(
      id: 'bumi',
      name: 'Bumi & Iklim',
      tagline: 'Geografi, cuaca, dan lingkungan',
      icon: Icons.public_outlined,
    ),
    QuizCategory(
      id: 'sains',
      name: 'Sains Hijau',
      tagline: 'Cara kerja kehidupan sehari-hari',
      icon: Icons.science_outlined,
    ),
  ];

  static QuizCategory categoryById(String id) =>
      categories.firstWhere((category) => category.id == id);

  static const Map<String, List<Question>> _bank = {
    'rimba': [
      Question(
        id: 'rimba-01',
        prompt: 'Satwa purba yang hanya hidup alami di Pulau Komodo adalah…',
        options: ['Anoa', 'Komodo', 'Babirusa', 'Tarsius'],
        answerIndex: 1,
        note:
            'Komodo (Varanus komodoensis) hanya ditemukan di Nusa Tenggara, '
            'terutama Taman Nasional Komodo.',
      ),
      Question(
        id: 'rimba-02',
        prompt:
            'Bunga terbesar di dunia, yang tumbuh sebagai parasit di Sumatra, '
            'bernama…',
        options: [
          'Bunga bangkai',
          'Rafflesia arnoldii',
          'Kantong semar raja',
          'Anggrek hitam',
        ],
        answerIndex: 1,
        note:
            'Rafflesia arnoldii menghasilkan bunga tunggal terbesar. Bunga '
            'bangkai (Amorphophallus titanum) justru terkenal karena '
            'perbungaannya yang tinggi.',
      ),
      Question(
        id: 'rimba-03',
        prompt:
            'Burung khas Papua yang dikenal karena bulu hiasnya yang indah '
            'adalah…',
        options: ['Kasuari', 'Cenderawasih', 'Maleo', 'Julang emas'],
        answerIndex: 1,
        note:
            'Cenderawasih menjadi salah satu ikon fauna Papua dan dilindungi '
            'karena perdagangan bulunya.',
      ),
      Question(
        id: 'rimba-04',
        prompt: 'Mamalia terbesar yang hidup di Bumi adalah…',
        options: ['Gajah Sumatra', 'Paus biru', 'Orca', 'Dugong'],
        answerIndex: 1,
        note:
            'Paus biru dapat mencapai panjang lebih dari 30 meter. Perairan '
            'Indonesia juga menjadi jalur migrasi beberapa jenis paus.',
      ),
      Question(
        id: 'rimba-05',
        prompt: 'Fungsi utama hutan bakau di pesisir adalah…',
        options: [
          'Menahan abrasi dan menjadi tempat pembesaran ikan',
          'Menghasilkan air tawar untuk permukiman',
          'Mencegah gempa bumi di pesisir',
          'Menjadi tambang kayu untuk industri',
        ],
        answerIndex: 0,
        note:
            'Akar bakau meredam gelombang dan menahan sedimen. Kawasan ini '
            'juga menjadi nursery bagi banyak ikan dan udang.',
      ),
      Question(
        id: 'rimba-06',
        prompt:
            'Primata endemik Kalimantan yang jantan dewasa memiliki hidung '
            'besar dan panjang adalah…',
        options: ['Orangutan', 'Tarsius', 'Bekantan', 'Lutung budeng'],
        answerIndex: 2,
        note:
            'Bekantan (Nasalis larvatus) hidup di hutan bakau dan tepi sungai '
            'Kalimantan. Hidung besar menjadi ciri jantan dewasa.',
      ),
      Question(
        id: 'rimba-07',
        prompt:
            'Kantong semar menangkap serangga terutama untuk memenuhi '
            'kebutuhan…',
        options: ['Nitrogen', 'Oksigen', 'Kalsium', 'Air'],
        answerIndex: 0,
        note:
            'Kantong semar tumbuh di tanah miskin nitrogen. Serangga yang '
            'tertangkap menjadi sumber nutrisi tambahan.',
      ),
      Question(
        id: 'rimba-08',
        prompt:
            'Satwa bercula satu yang menjadi prioritas konservasi di Taman '
            'Nasional Ujung Kulon adalah…',
        options: ['Badak Sumatra', 'Gajah Sumatra', 'Banteng', 'Badak Jawa'],
        answerIndex: 3,
        note:
            'Populasi badak Jawa (Rhinoceros sondaicus) hanya tersisa di Ujung '
            'Kulon dan sangat rentan terhadap penyakit serta bencana.',
      ),
    ],
    'bumi': [
      Question(
        id: 'bumi-01',
        prompt:
            'Garis khayal yang membagi Bumi menjadi belahan utara dan selatan '
            'disebut…',
        options: ['Meridian', 'Ekuator', 'Garis tanggal', 'Lintang kutub'],
        answerIndex: 1,
        note:
            'Ekuator membentang di 0° lintang dan melintasi beberapa wilayah '
            'Indonesia, termasuk Sumatra, Kalimantan, dan Sulawesi.',
      ),
      Question(
        id: 'bumi-02',
        prompt: 'Indonesia berada di antara dua samudra besar, yaitu…',
        options: [
          'Atlantik dan Pasifik',
          'Hindia dan Arktik',
          'Pasifik dan Hindia',
          'Atlantik dan Hindia',
        ],
        answerIndex: 2,
        note:
            'Posisi ini membuat Indonesia berada di persimpangan jalur '
            'pelayaran dan memiliki perairan yang luas.',
      ),
      Question(
        id: 'bumi-03',
        prompt:
            'Gas rumah kaca yang paling banyak dihasilkan dari pembakaran '
            'bahan bakar fosil adalah…',
        options: ['Karbon dioksida', 'Ozon', 'Helium', 'Nitrogen'],
        answerIndex: 0,
        note:
            'Karbon dioksida (CO₂) menyumbang porsi terbesar emisi global '
            'dari pembakaran batu bara, minyak, dan gas.',
      ),
      Question(
        id: 'bumi-04',
        prompt:
            'Naiknya suhu rata-rata atmosfer dan laut dalam jangka panjang '
            'disebut…',
        options: ['El Niño', 'Pemanasan global', 'Efek albedo', 'Inversi suhu'],
        answerIndex: 1,
        note:
            'Pemanasan global memicu perubahan iklim: cuaca ekstrem, kenaikan '
            'muka laut, dan pergeseran musim.',
      ),
      Question(
        id: 'bumi-05',
        prompt:
            'Berdasarkan luas hutan hujan tropisnya, Indonesia menempati '
            'urutan ke… di dunia.',
        options: ['Pertama', 'Kedua', 'Ketiga', 'Kelima'],
        answerIndex: 2,
        note:
            'Setelah Brasil dan Republik Demokratik Kongo, Indonesia memiliki '
            'salah satu hamparan hutan hujan tropis terluas.',
      ),
      Question(
        id: 'bumi-06',
        prompt: 'Puncak tertinggi di Indonesia berada di…',
        options: [
          'Gunung Kerinci',
          'Gunung Rinjani',
          'Puncak Jaya',
          'Gunung Semeru',
        ],
        answerIndex: 2,
        note:
            'Puncak Jaya (Carstensz Pyramid) di Papua mencapai sekitar 4.884 '
            'meter dan diselimuti gletser tropis.',
      ),
      Question(
        id: 'bumi-07',
        prompt: 'Danau terluas di Indonesia adalah…',
        options: [
          'Danau Toba',
          'Danau Sentani',
          'Danau Singkarak',
          'Danau Poso',
        ],
        answerIndex: 0,
        note:
            'Danau Toba di Sumatra Utara adalah danau vulkanik terluas di '
            'dunia, terbentuk dari letusan super purba.',
      ),
      Question(
        id: 'bumi-08',
        prompt:
            'Pergantian musim hujan dan kemarau di Indonesia terutama '
            'dipengaruhi oleh…',
        options: ['Angin pasat', 'Arus laut', 'Rotasi Bumi', 'Angin monsun'],
        answerIndex: 3,
        note:
            'Monsun Asia membawa udara lembap dan hujan, sedangkan monsun '
            'Australia cenderung kering.',
      ),
    ],
    'sains': [
      Question(
        id: 'sains-01',
        prompt:
            'Proses tumbuhan mengubah cahaya matahari menjadi energi kimia '
            'disebut…',
        options: ['Fotosintesis', 'Respirasi', 'Transpirasi', 'Fermentasi'],
        answerIndex: 0,
        note:
            'Dalam fotosintesis, karbon dioksida dan air diubah menjadi '
            'glukosa dengan bantuan cahaya dan klorofil.',
      ),
      Question(
        id: 'sains-02',
        prompt: 'Pigmen yang memberi warna hijau pada daun adalah…',
        options: ['Karotenoid', 'Antosianin', 'Klorofil', 'Xantofil'],
        answerIndex: 2,
        note:
            'Klorofil menyerap sebagian besar cahaya merah dan biru, lalu '
            'memantulkan hijau sehingga daun tampak hijau.',
      ),
      Question(
        id: 'sains-03',
        prompt: 'Bagian tumbuhan yang paling banyak menyerap air dari tanah adalah…',
        options: ['Daun', 'Akar', 'Batang', 'Bunga'],
        answerIndex: 1,
        note:
            'Rambut akar memperluas permukaan penyerapan. Air lalu diangkut '
            'ke atas melalui pembuluh xilem.',
      ),
      Question(
        id: 'sains-04',
        prompt:
            'Bentuk simbiosis antara jamur dan alga yang sering tumbuh di '
            'batuan atau kulit pohon disebut…',
        options: ['Lumut hati', 'Pakis', 'Jamur merang', 'Lumut kerak'],
        answerIndex: 3,
        note:
            'Lumut kerak (lichen) adalah simbiosis mutualisme: alga '
            'berfotosintesis, jamur menyediakan tempat dan mineral.',
      ),
      Question(
        id: 'sains-05',
        prompt:
            'Organisme yang berperan menguraikan sisa makhluk hidup menjadi '
            'nutrisi tanah adalah…',
        options: ['Produsen', 'Bakteri dan jamur', 'Herbivora', 'Karnivora'],
        answerIndex: 1,
        note:
            'Dekomposer memecah bahan organik menjadi senyawa sederhana yang '
            'bisa dipakai tumbuhan lagi.',
      ),
      Question(
        id: 'sains-06',
        prompt:
            'Energi terbarukan yang memanfaatkan panas dari dalam Bumi '
            'disebut…',
        options: [
          'Energi surya',
          'Energi angin',
          'Energi panas bumi',
          'Energi biomassa',
        ],
        answerIndex: 2,
        note:
            'Indonesia berada di Cincin Api sehingga memiliki potensi panas '
            'bumi yang besar untuk pembangkit listrik.',
      ),
      Question(
        id: 'sains-07',
        prompt:
            'Tiga langkah utama dalam mengelola sampah dikenal dengan prinsip…',
        options: [
          'Reduce, reuse, recycle',
          'Burn, bury, buy',
          'Collect, carry, clean',
          'Plant, pick, pack',
        ],
        answerIndex: 0,
        note:
            'Mengurangi dan memakai ulang lebih dulu, baru mendaur ulang. '
            'Urutan ini lebih hemat energi daripada langsung mendaur ulang.',
      ),
      Question(
        id: 'sains-08',
        prompt:
            'Bahan utama yang dibutuhkan agar tumpukan kompos terurai adalah…',
        options: [
          'Plastik dan logam',
          'Pasir dan kerikil',
          'Sabun dan deterjen',
          'Bahan organik dan mikroorganisme',
        ],
        answerIndex: 3,
        note:
            'Sisa dapur hijau dan cokelat, air secukupnya, serta udara '
            'membantu bakteri dan jamur mengurai bahan organik.',
      ),
    ],
  };

  static List<Question> questionsFor(String categoryId) =>
      List<Question>.unmodifiable(_bank[categoryId] ?? const <Question>[]);

  static int get totalQuestions =>
      _bank.values.fold(0, (total, questions) => total + questions.length);
}
