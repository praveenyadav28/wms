// ignore_for_file: unused_import, unnecessary_import, unnecessary_type_check, unnecessary_null_comparison, unused_local_variable, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously, empty_catches, must_be_immutable, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/model/group.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/reuse_widget.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:searchfield/searchfield.dart';

class ProspectScreen extends StatefulWidget {
  ProspectScreen({super.key});
  @override
  State<ProspectScreen> createState() => _ProspectScreenState();
}

class _ProspectScreenState extends State<ProspectScreen> {
  late List<String> statesSuggestions;
  late List<String> citiesSuggestions;

  late SearchFieldListItem<String>? selectedState;
  late SearchFieldListItem<String>? selectedCity;

  Map<String, List<String>> stateCities = {
    'Andaman and Nicobar Islands': [
      'Car Nicobar',
      'Hut Bay',
      'Diglipur',
      'Mayabunder',
      'Port Blair',
      'Rangat',
    ],
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Tirupati',
      'Nellore',
      'Kurnool',
      'Rajahmundry',
      'Kakinada',
      'Anantapur',
      'Kadapa',
      'Eluru',
      'Ongole',
      'Chittoor',
      'Machilipatnam',
      'Srikakulam',
      'Vizianagaram',
      'Nandyal',
      'Proddatur',
      'Hindupur',
      'Tenali',
      'Madanapalle',
      'Gudivada',
      'Bhimavaram',
      'Adoni',
      'Tadepalligudem',
      'Chilakaluripet',
      'Dharmavaram',
      'Srikalahasti',
      'Nagari',
      'Puttaparthi',
      'Markapur',
      'Palakollu',
      'Narasaraopet',
      'Tadipatri',
      'Rayadurg',
      'Kovvur',
      'Samalkot',
      'Amalapuram',
      'Kandukur',
      'Mandapeta',
      'Tanuku',
      'Jaggayyapeta',
      'Yemmiganur',
      'Vinukonda',
      'Sattenapalle',
      'Punganur',
      'Pamidi',
      'Tiruvuru',
      'Bapatla',
      'Parvathipuram',
      'Salur',
      'Renigunta',
      'Gooty',
      'Ichchapuram',
      'Kavali',
      'Nandigama',
    ],
    'Arunachal Pradesh': [
      'Itanagar',
      'Naharlagun',
      'Tawang',
      'Bomdila',
      'Ziro',
      'Pasighat',
      'Roing',
      'Along (Aalo)',
      'Daporijo',
      'Tezu',
      'Khonsa',
      'Seppa',
      'Yingkiong',
      'Changlang',
      'Namsai',
      'Bhalukpong',
      'Hawai',
      'Anini',
      'Palin',
      'Raga',
      'Basar',
      'Mechuka',
      'Jairampur',
      'Koloriang',
      'Menchukha',
      'Dirang',
      'Sagalee',
      'Pakke-Kessang',
      'Longding',
      'Lohitpur',
      'Tuting',
      'Miao',
      'Deomali',
      'Hayuliang',
      'Dibang Valley',
      'Ruksin',
      'Bordumsa',
      'Kanubari',
      'Kharsang',
    ],
    'Assam': [
      'Guwahati',
      'Silchar',
      'Dibrugarh',
      'Jorhat',
      'Nagaon',
      'Tinsukia',
      'Tezpur',
      'Bongaigaon',
      'Karimganj',
      'Diphu',
      'Sivasagar',
      'Goalpara',
      'Lakhimpur',
      'Dhubri',
      'Barpeta',
      'Hailakandi',
      'Golaghat',
      'Mariani',
      'Kokrajhar',
      'Rangia',
      'Hojai',
      'Udalguri',
      'Morigaon',
      'Bilasipara',
      'North Lakhimpur',
      'Mangaldoi',
      'Nazira',
      'Sonari',
      'Abhayapuri',
      'Dhekiajuli',
      'Badarpur',
      'Titabor',
      'Sarupathar',
      'Charaideo',
      'Tamulpur',
      'Majuli',
      'Bajali',
      'Gohpur',
      'Jonai',
      'Lanka',
      'Pathsala',
      'Howraghat',
      'Jagiroad',
      'Hamren',
      'Sarang',
      'Biswanath Chariali',
      'Gossaigaon',
      'Haflong',
      'Sapatgram',
    ],
    'Bihar': [
      'Patna',
      'Gaya',
      'Bhagalpur',
      'Muzaffarpur',
      'Darbhanga',
      'Purnia',
      'Ara',
      'Begusarai',
      'Katihar',
      'Munger',
      'Chhapra',
      'Hajipur',
      'Samastipur',
      'Motihari',
      'Siwan',
      'Sasaram',
      'Bettiah',
      'Dehri',
      'Sitamarhi',
      'Nawada',
      'Buxar',
      'Kishanganj',
      'Jamui',
      'Jehanabad',
      'Aurangabad',
      'Lakhisarai',
      'Sheikhpura',
      'Araria',
      'Madhepura',
      'Supaul',
      'Vaishali',
      'Gopalganj',
      'Khagaria',
      'Sheohar',
      'Banka',
      'Arwal',
      'Rohtas',
      'Kaimur',
      'Saharsa',
      'East Champaran',
      'West Champaran',
      'Nalanda',
      'Madhubani',
    ],
    'Chhattisgarh': [
      'Raipur',
      'Bhilai',
      'Durg',
      'Bilaspur',
      'Korba',
      'Raigarh',
      'Jagdalpur',
      'Ambikapur',
      'Dhamtari',
      'Rajnandgaon',
      'Champa',
      'Mahasamund',
      'Kanker',
      'Kawardha',
      'Baikunthpur',
      'Jashpur',
      'Sakti',
      'Mungeli',
      'Balod',
      'Bemetara',
      'Durg-Bhilai Urban',
      'Chirimiri',
      'Dongargarh',
      'Tilda Newra',
      'Manendragarh',
      'Kondagaon',
      'Surajpur',
      'Pathalgaon',
      'Balrampur',
      'Saraipali',
      'Pandariya',
      'Khairagarh',
      'Ambagarh Chowki',
      'Narayanpur',
      'Dabhra',
      'Gharghoda',
      'Pendra',
      'Gaurela',
      'Bhatapara',
      'Janjgir',
      'Kasdol',
      'Rajpur',
      'Shivpuri',
      'Bodla',
      'Udaipur',
      'Lormi',
      'Marwahi',
    ],
    'Dadra and Nagar Haveli and Daman and Diu': [
      'Silvassa', // Capital and main city
      'Daman', // Coastal town and district HQ
      'Diu', // Coastal town and tourist hub
      'Amli',
      'Naroli',
      'Samarvarni',
      'Vapi (Partly in Gujarat but connected)',
      'Kachigam',
      'Marwad',
      'Bhimpore',
      'Kadaiya',
    ],
    'Delhi': [
      'New Delhi',
      'Old Delhi',
      'Dwarka',
      'Rohini',
      'Karol Bagh',
      'Chandni Chowk',
      'Connaught Place',
      'Lajpat Nagar',
      'Saket',
      'Hauz Khas',
      'Vasant Kunj',
      'Greater Kailash',
      'Janakpuri',
      'Pitampura',
      'Shahdara',
      'Laxmi Nagar',
      'Mayur Vihar',
      'Preet Vihar',
      'Nehru Place',
      'Rajouri Garden',
      'Tilak Nagar',
      'Paschim Vihar',
      'Mukherjee Nagar',
      'Model Town',
      'Yamuna Vihar',
      'Mehrauli',
      'Tughlakabad',
      'Ashok Vihar',
      'Patparganj',
      'Sarita Vihar',
      'Jasola',
      'Okhla',
      'Nangloi',
      'Najafgarh',
      'Uttam Nagar',
      'Burari',
      'Dilshad Garden',
      'Chhatarpur',
      'Sonia Vihar',
      'Badarpur',
      'Adarsh Nagar',
      'Sultanpur',
      'Inderlok',
      'Gandhi Nagar',
      'Madangir',
      'Bhikaji Cama Place',
    ],
    'Goa': [
      'Panaji', // Capital city
      'Vasco da Gama',
      'Margao',
      'Mapusa',
      'Ponda',
      'Bicholim',
      'Curchorem',
      'Quepem',
      'Canacona',
      'Sanguem',
      'Sanquelim',
      'Valpoi',
      'Tiswadi',
      'Dabolim',
      'Cuncolim',
      'Chinchinim',
      'Aldona',
      'Calangute',
      'Candolim',
      'Colva',
      'Pernem',
      'Assagao',
      'Navelim',
      'Siolim',
      'Benaulim',
      'Cansaulim',
      'Loutolim',
    ],
    'Gujarat': [
      'Ahmedabad',
      'Surat',
      'Vadodara',
      'Rajkot',
      'Bhavnagar',
      'Jamnagar',
      'Gandhinagar',
      'Junagadh',
      'Anand',
      'Bharuch',
      'Mehsana',
      'Bhuj',
      'Porbandar',
      'Navsari',
      'Morbi',
      'Nadiad',
      'Surendranagar',
      'Gandhidham',
      'Vapi',
      'Patan',
      'Dahod',
      'Amreli',
      'Godhra',
      'Veraval',
      'Botad',
      'Palanpur',
      'Valsad',
      'Himatnagar',
      'Deesa',
      'Bardoli',
      'Vyara',
      'Modasa',
      'Lunawada',
      'Wadhwan',
      'Mandvi',
      'Kalol',
      'Unjha',
      'Dhoraji',
      'Jetpur',
      'Mangrol',
      'Keshod',
      'Anjar',
      'Sanand',
      'Mahuva',
      'Savarkundla',
      'Chhota Udaipur',
      'Talala',
      'Jhalod',
      'Sidhpur',
      'Kapadvanj',
      'Halol',
      'Umreth',
      'Gondal',
      'Dabhoi',
      'Viramgam',
      'Khambhat',
      'Kadi',
      'Petlad',
      'Idar',
      'Morva Hadaf',
      'Bhayavadar',
      'Bhachau',
      'Lathi',
      'Dhrangadhra',
      'Radhanpur',
      'Mansa',
      'Vijapur',
      'Mundra',
      'Jasdan',
      'Rajula',
      'Diu',
    ],
    'Haryana': [
      'Chandigarh', // Joint capital with Punjab
      'Faridabad',
      'Gurgaon (Gurugram)',
      'Ambala',
      'Panipat',
      'Karnal',
      'Hisar',
      'Sonipat',
      'Rohtak',
      'Yamunanagar',
      'Panchkula',
      'Bhiwani',
      'Sirsa',
      'Jhajjar',
      'Jind',
      'Rewari',
      'Mahendragarh',
      'Kaithal',
      'Kurukshetra',
      'Palwal',
      'Fatehabad',
      'Charkhi Dadri',
      'Narnaul',
      'Hansi',
      'Bahadurgarh',
      'Gohana',
      'Narwana',
      'Thanesar',
      'Ratia',
      'Tohana',
      'Pehowa',
      'Tauru',
      'Safidon',
      'Samalkha',
      'Barwala',
      'Kalanaur',
      'Ladwa',
      'Firozpur Jhirka',
      'Nuh',
      'Sohna',
      'Hathin',
      'Shahbad',
      'Kosli',
      'Bawal',
      'Ellenabad',
    ],
    'Himachal Pradesh': [
      'Bilaspur',
      'Ghumarwin',
      'Naina Devi',
      'Chamba',
      'Dalhousie',
      'Banikhet',
      'Bharmour',
      'Hamirpur',
      'Nadaun',
      'Sujanpur',
      'Dharamshala',
      'Palampur',
      'Kangra',
      'Nurpur',
      'Reckong Peo',
      'Kalpa',
      'Sangla',
      'Kullu',
      'Manali',
      'Bhuntar',
      'Banjar',
      'Keylong',
      'Kaza',
      'Udaipur',
      'Mandi',
      'Sundernagar',
      'Joginder Nagar',
      'Karsog',
      'Shimla',
      'Rampur',
      'Theog',
      'Rohru',
      'Chaupal',
      'Nahan',
      'Paonta Sahib',
      'Rajgarh',
      'Shillai',
      'Solan',
      'Baddi',
      'Nalagarh',
      'Parwanoo',
      'Una',
      'Amb',
      'Bangana',
      'Gagret',
    ],
    'Jammu and Kashmir': [
      'Srinagar',
      'Jammu',
      'Anantnag',
      'Baramulla',
      'Pulwama',
      'Udhampur',
      'Kathua',
      'Kupwara',
      'Rajouri',
      'Poonch',
      'Ganderbal',
      'Budgam',
      'Kulgam',
      'Bandipora',
      'Reasi',
      'Doda',
      'Ramban',
      'Kishtwar',
      'Shopian',
      'Handwara',
      'Awantipora',
      'Bijbehara',
      'Sopore',
      'Akhnoor',
      'Bishnah',
      'Samba',
      'Chenani',
      'Banihal',
      'Qazigund',
      'Tangmarg',
    ],
    'Jharkhand': [
      'Ranchi',
      'Jamshedpur',
      'Dhanbad',
      'Bokaro Steel City',
      'Hazaribagh',
      'Deoghar',
      'Giridih',
      'Ramgarh',
      'Phusro',
      'Medininagar (Daltonganj)',
      'Chaibasa',
      'Chirkunda',
      'Gumia',
      'Sahibganj',
      'Ghatshila',
      'Lohardaga',
      'Simdega',
      'Jhumri Telaiya',
      'Dumka',
      'Latehar',
      'Pakur',
      'Chakradharpur',
      'Chatra',
      'Khunti',
      'Godda',
      'Bundu',
      'Madhupur',
      'Basukinath',
      'Barkagaon',
      'Hussainabad',
      'Patratu',
      'Rajmahal',
      'Nagar Untari',
      'Koderma',
      'Balumath',
      'Sisai',
      'Kuru',
      'Murhu',
      'Hiranpur',
      'Manoharpur',
      'Kolebira',
      'Nala',
      'Bishrampur',
      'Dhanwar',
      'Bermo',
      'Tenughat',
      'Rajrappa',
      'Simaria',
      'Bano',
      'Chandil',
      'Tamar',
      'Itki',
      'Torpa',
      'Chandwa',
      'Hatia',
    ],
    'Karnataka': [
      'Bengaluru',
      'Mysuru',
      'Hubballi',
      'Dharwad',
      'Mangaluru',
      'Belagavi',
      'Shivamogga',
      'Tumakuru',
      'Ballari',
      'Vijayapura',
      'Davangere',
      'Kalaburagi',
      'Bidar',
      'Raichur',
      'Hassan',
      'Udupi',
      'Chikkamagaluru',
      'Mandya',
      'Kolar',
      'Ramanagara',
      'Chitradurga',
      'Bagalkot',
      'Koppal',
      'Haveri',
      'Yadgir',
      'Chikkaballapur',
      'Gadag',
      'Kodagu',
      'Uttara Kannada',
      'Karwar',
      'Sirsi',
      'Bhadravati',
      'Channapatna',
      'Kundapura',
      'Mudhol',
      'Nanjangud',
      'Tiptur',
      'Sagara',
      'Gokak',
      'Challakere',
      'Kollegal',
      'Hosapete',
      'Sira',
      'Puttur',
      'Gundlupet',
      'Ron',
      'Sindhanur',
      'Ramdurg',
      'Shiggaon',
      'Alnavar',
      'Sorab',
      'Turuvekere',
      'Yellapur',
      'Magadi',
      'Basavakalyan',
      'Afzalpur',
      'Malavalli',
      'Channarayapatna',
      'Harihar',
      'Sakleshpur',
      'Mudalagi',
      'Madhugiri',
      'Humnabad',
      'Gangavathi',
      'Siruguppa',
    ],
    'Kerala': [
      'Thiruvananthapuram',
      'Kollam',
      'Pathanamthitta',
      'Alappuzha',
      'Kottayam',
      'Idukki',
      'Ernakulam',
      'Kochi',
      'Thrissur',
      'Palakkad',
      'Malappuram',
      'Kozhikode',
      'Wayanad',
      'Kannur',
      'Kasaragod',
      'Attingal',
      'Varkala',
      'Nedumangad',
      'Kottarakara',
      'Punalur',
      'Karunagappally',
      'Adoor',
      'Chengannur',
      'Mavelikkara',
      'Cherthala',
      'Vaikom',
      'Changanassery',
      'Thodupuzha',
      'Muvattupuzha',
      'Perumbavoor',
      'Angamaly',
      'Aluva',
      'Kothamangalam',
      'Kalpetta',
      'Kunnamkulam',
      'Guruvayur',
      'Chalakudy',
      'Irinjalakuda',
      'Ponnani',
      'Manjeri',
      'Perinthalmanna',
      'Tirur',
      'Nilambur',
      'Malappuram',
      'Vadakara',
      'Thalassery',
      'Payyannur',
      'Kanhangad',
      'Neyyattinkara',
      'Kasaragod',
    ],
    'Ladakh': [
      'Leh',
      'Kargil',
      'Diskit',
      'Dras',
      'Nubra Valley',
      'Padum',
      'Turtuk',
      'Tangtse',
      'Nyoma',
      'Hanle',
      'Choglamsar',
      'Basgo',
      'Saspol',
      'Shakar Chiktan',
      'Panamik',
    ],
    'Lakshadweep': [
      'Kavaratti',
      'Agatti',
      'Amini',
      'Andrott',
      'Kalpeni',
      'Kadmat',
      'Minicoy',
      'Chetlat',
      'Bitra',
      'Kiltan',
    ],
    'Madhya Pradesh': [
      "Alirajpur",
      "Anuppur",
      "Ashoknagar",
      "Balaghat",
      "Barwani",
      "Betul",
      "Bhind",
      "Bhopal",
      "Burhanpur",
      "Chhatarpur",
      "Chhindwara",
      "Damoh",
      "Datia",
      "Dewas",
      "Dhar",
      "Dindori",
      "Guna",
      "Gwalior",
      "Harda",
      "Hoshangabad",
      "Indore",
      "Jabalpur",
      "Jhabua",
      "Katni",
      "Khandwa",
      "Khargone",
      "Mandla",
      "Mandsaur",
      "Morena",
      "Narsinghpur",
      "Neemuch",
      "Panna",
      "Raisen",
      "Rajgarh",
      "Ratlam",
      "Rewa",
      "Sagar",
      "Satna",
      "Sehore",
      "Seoni",
      "Shahdol",
      "Shajapur",
      "Sheopur",
      "Shivpuri",
      "Sidhi",
      "Singrauli",
      "Tikamgarh",
      "Ujjain",
      "Umaria",
      "Vidisha",
      "Agar Malwa",
      "Niwari",
    ],
    'Maharashtra': [
      "Ahmednagar",
      "Akola",
      "Amravati",
      "Aurangabad",
      "Beed",
      "Bhandara",
      "Buldhana",
      "Chandrapur",
      "Dhule",
      "Gadchiroli",
      "Gondia",
      "Hingoli",
      "Jalgaon",
      "Jalna",
      "Kolhapur",
      "Latur",
      "Mumbai City",
      "Mumbai Suburban",
      "Nagpur",
      "Nanded",
      "Nandurbar",
      "Nashik",
      "Osmanabad",
      "Palghar",
      "Parbhani",
      "Pune",
      "Raigad",
      "Ratnagiri",
      "Sangli",
      "Satara",
      "Sindhudurg",
      "Solapur",
      "Thane",
      "Wardha",
      "Washim",
      "Yavatmal",
    ],
    'Manipur': [
      "Bishnupur",
      "Chandel",
      "Churachandpur",
      "Imphal East",
      "Imphal West",
      "Jiribam",
      "Kakching",
      "Kamjong",
      "Kangpokpi",
      "Noney",
      "Pherzawl",
      "Senapati",
      "Tamenglong",
      "Tengnoupal",
      "Thoubal",
      "Ukhrul",
    ],
    'Meghalaya': [
      "East Garo Hills",
      "East Jaintia Hills",
      "East Khasi Hills",
      "North Garo Hills",
      "Ri Bhoi",
      "South Garo Hills",
      "South West Garo Hills",
      "South West Khasi Hills",
      "West Garo Hills",
      "West Jaintia Hills",
      "West Khasi Hills",
    ],
    'Mizoram': [
      "Aizawl",
      "Champhai",
      "Hnahthial",
      "Khawzawl",
      "Kolasib",
      "Lawngtlai",
      "Lunglei",
      "Mamit",
      "Saitual",
      "Serchhip",
      "Siaha",
    ],
    'Nagaland': [
      "Chümoukedima",
      "Dimapur",
      "Kiphire",
      "Kohima",
      "Longleng",
      "Mokokchung",
      "Mon",
      "Niuland",
      "Noklak",
      "Peren",
      "Phek",
      "Shamator",
      "Tseminyu",
      "Tuensang",
      "Wokha",
      "Zunheboto",
    ],
    'Odisha': [
      "Angul",
      "Balangir",
      "Balasore",
      "Bargarh",
      "Bhadrak",
      "Boudh",
      "Cuttack",
      "Deogarh",
      "Dhenkanal",
      "Gajapati",
      "Ganjam",
      "Jagatsinghpur",
      "Jajpur",
      "Jharsuguda",
      "Kalahandi",
      "Kandhamal",
      "Kendrapara",
      "Kendujhar",
      "Khordha",
      "Koraput",
      "Malkangiri",
      "Mayurbhanj",
      "Nabarangpur",
      "Nayagarh",
      "Nuapada",
      "Puri",
      "Rayagada",
      "Sambalpur",
      "Subarnapur",
      "Sundargarh",
    ],
    'Puducherry': ['Puducherry', 'Karaikal', 'Mahe', 'Yanam'],
    'Punjab': [
      "Amritsar",
      "Barnala",
      "Bathinda",
      "Faridkot",
      "Fatehgarh Sahib",
      "Fazilka",
      "Ferozepur",
      "Gurdaspur",
      "Hoshiarpur",
      "Jalandhar",
      "Kapurthala",
      "Ludhiana",
      "Mansa",
      "Moga",
      "Pathankot",
      "Patiala",
      "Rupnagar",
      "Sahibzada Ajit Singh Nagar",
      "Sangrur",
      "Shahid Bhagat Singh Nagar",
      "Sri Muktsar Sahib",
      "Tarn Taran",
    ],
    'Rajasthan': [
      "Ajmer",
      "Alwar",
      "Banswara",
      "Baran",
      "Barmer",
      "Bharatpur",
      "Bhilwara",
      "Bikaner",
      "Bundi",
      "Chittorgarh",
      "Churu",
      "Dausa",
      "Dholpur",
      "Dungarpur",
      "Hanumangarh",
      "Jaipur",
      "Jaisalmer",
      "Jalor",
      "Jhalawar",
      "Jhunjhunu",
      "Jodhpur",
      "Karauli",
      "Kota",
      "Nagaur",
      "Pali",
      "Pratapgarh",
      "Rajsamand",
      "Sawai Madhopur",
      "Sikar",
      "Sirohi",
      "Sri Ganganagar",
      "Tonk",
      "Udaipur",
      "Shahpura",
      "Khairthal-Tijara",
      "Neem Ka Thana",
      "Anupgarh",
      "Balotra",
      "Beawar",
      "Deeg",
      "Didwana-Kuchaman",
      "Dudu",
      "Gangapur City",
      "Kekri",
      "Kotputli-Behror",
      "Phalodi",
      "Salumber",
      "Sanchore",
      "Shahpura",
    ],
    'Sikkim': ["Gangtok", "Gyalshing", "Mangan", "Namchi", "Pakyong", "Soreng"],
    'Tamil Nadu': [
      "Ariyalur",
      "Chengalpattu",
      "Chennai",
      "Coimbatore",
      "Cuddalore",
      "Dharmapuri",
      "Dindigul",
      "Erode",
      "Kallakurichi",
      "Kanchipuram",
      "Kanniyakumari",
      "Karur",
      "Krishnagiri",
      "Madurai",
      "Mayiladuthurai",
      "Nagapattinam",
      "Namakkal",
      "Nilgiris",
      "Perambalur",
      "Pudukkottai",
      "Ramanathapuram",
      "Ranipet",
      "Salem",
      "Sivaganga",
      "Tenkasi",
      "Thanjavur",
      "Theni",
      "Thoothukudi",
      "Tiruchirappalli",
      "Tirunelveli",
      "Tirupathur",
      "Tiruppur",
      "Tiruvallur",
      "Tiruvannamalai",
      "Tiruvarur",
      "Vellore",
      "Viluppuram",
      "Virudhunagar",
    ],
    'Telangana': [
      "Adilabad",
      "Bhadradri Kothagudem",
      "Hanamkonda",
      "Hyderabad",
      "Jagitial",
      "Jangaon",
      "Jayashankar Bhupalpally",
      "Jogulamba Gadwal",
      "Kamareddy",
      "Karimnagar",
      "Khammam",
      "Komaram Bheem Asifabad",
      "Mahabubabad",
      "Mahabubnagar",
      "Mancherial",
      "Medak",
      "Medchal–Malkajgiri",
      "Mulugu",
      "Nagarkurnool",
      "Nalgonda",
      "Narayanpet",
      "Nirmal",
      "Nizamabad",
      "Peddapalli",
      "Rajanna Sircilla",
      "Rangareddy",
      "Sangareddy",
      "Siddipet",
      "Suryapet",
      "Vikarabad",
      "Wanaparthy",
      "Warangal",
      "Yadadri Bhuvanagiri",
    ],
    'Tripura': [
      "Dhalai",
      "Gomati",
      "Khowai",
      "North Tripura",
      "Sepahijala",
      "South Tripura",
      "Unakoti",
      "West Tripura",
    ],
    'Uttar Pradesh': [
      "Agra",
      "Aligarh",
      "Allahabad",
      "Ambedkar Nagar",
      "Amethi",
      "Amroha",
      "Auraiya",
      "Azamgarh",
      "Badaun",
      "Bahraich",
      "Ballia",
      "Balrampur",
      "Banda",
      "Barabanki",
      "Bareilly",
      "Basti",
      "Bhadohi",
      "Bijnor",
      "Budaun",
      "Bulandshahr",
      "Chandauli",
      "Chitrakoot",
      "Deoria",
      "Etah",
      "Etawah",
      "Faizabad",
      "Farrukhabad",
      "Fatehpur",
      "Firozabad",
      "Gautam Buddha Nagar",
      "Ghaziabad",
      "Ghazipur",
      "Gonda",
      "Gorakhpur",
      "Hamirpur",
      "Hardoi",
      "Hathras",
      "Jalaun",
      "Jaunpur",
      "Jhansi",
      "Kannauj",
      "Kanpur Dehat",
      "Kanpur Nagar",
      "Kaushambi",
      "Kushinagar",
      "Lakhimpur Kheri",
      "Lalitpur",
      "Lucknow",
      "Mainpuri",
      "Mathura",
      "Meerut",
      "Mirzapur",
      "Moradabad",
      "Muzaffarnagar",
      "Noida",
      "Pratapgarh",
      "Rae Bareli",
      "Rampur",
      "Saharanpur",
      "Sant Kabir Nagar",
      "Shahjahanpur",
      "Shamli",
      "Siddharthnagar",
      "Sitapur",
      "Sonbhadra",
      "Sultanpur",
      "Unnao",
      "Varanasi",
    ],
    'Uttarakhand': [
      "Almora",
      "Bageshwar",
      "Chamoli",
      "Champawat",
      "Dehradun",
      "Haridwar",
      "Nainital",
      "Pauri Garhwal",
      "Pithoragarh",
      "Rudraprayag",
      "Tehri Garhwal",
      "Udham Singh Nagar",
      "Uttarkashi",
    ],
    'West Bengal': [
      "Alipurduar",
      "Bankura",
      "Birbhum",
      "Cooch Behar",
      "Dakshin Dinajpur",
      "Darjeeling",
      "Hooghly",
      "Howrah",
      "Jalpaiguri",
      "Jhargram",
      "Kalimpong",
      "Kolkata",
      "Malda",
      "Murshidabad",
      "Nadia",
      "North 24 Parganas",
      "Paschim Bardhaman",
      "Paschim Medinipur",
      "Purba Bardhaman",
      "Purba Medinipur",
      "Purulia",
      "South 24 Parganas",
      "Uttar Dinajpur",
    ],
  };

  bool isLoadingProspect = false;
  final TextEditingController _customernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _alternativemobileController =
      TextEditingController();
  final TextEditingController _lastRemarkController = TextEditingController();
  final TextEditingController _specialRemarkController =
      TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //Date
  TextEditingController appointmentDatePickar = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  List<Map<String, dynamic>> varientList = [];
  int? selectedvarientId;

  // EnqueryType
  List<Map<String, dynamic>> productList = [];
  int? selectedProductId;

  //Priority
  final List<Map<String, dynamic>> priorityDataList = [
    {'id': 1, 'name': 'Cold'},
    {'id': 2, 'name': 'Normal'},
    {'id': 3, 'name': 'Hot'},
  ];
  int selectedPriorityId = 1;

  final List<Map<String, dynamic>> demoDataList = [
    {'id': 0, 'name': 'Demo Pending'},
    {'id': 1, 'name': 'Demo Fixed'},
    {'id': 2, 'name': 'Demo Done'},
  ];
  int selectedDemoId = 0;

  //SalesXid
  List<Map<String, dynamic>> salesmanList = [];
  // int? selectedsalesmanId;

  @override
  void initState() {
    statesSuggestions = stateCities.keys.toList();
    citiesSuggestions = [];

    selectedState = null;
    selectedCity = null;

    fetchDataWait().then((value) {
      setState(() {
        selectedProductId = productList[0]['id'];
        // selectedsalesmanId = salesmanList[0]['id'];
        selectedvarientId = varientList[0]['id'];
      });
    });
    super.initState();
    staffData();
    refreshData();
    getautoRefNumber();
  }

  refreshData() {
    varientData().then((value) => setState(() {}));
    productData().then((value) => setState(() {}));
    productData().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _dataLoaded = false;
  Future<void> fetchDataWait() async {
    while (!_dataLoaded) {
      // Check if data is loaded
      if (productList.isNotEmpty || salesmanList.isNotEmpty) {
        if (mounted) {
          setState(() {
            _dataLoaded = true;
          });
        }
      }
      // Simulate delay
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  StyleText textStyles = StyleText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        title: Text("Add Prospect", style: TextStyle(color: AppColor.white)),
      ),
      backgroundColor: AppColor.white,
      body: DecorationContainer(
        url: Images.prospectBackground,
        child:
            !_dataLoaded
                ? const Center(child: CircularProgressIndicator())
                : Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.height * 0.02,
                      horizontal:
                          (Responsive.isMobile(context))
                              ? Sizes.width * .03
                              : Sizes.width * 0.15,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Sizes.height * .04,
                        horizontal: Sizes.width * .03,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Personal Details ",
                                style: textStyles.adlamText(
                                  18,
                                  FontWeight.w400,
                                  AppColor.black,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Sizes.height * .02),
                          addMasterOutside(
                            children: [
                              Stack(
                                children: [
                                  commonTextField(
                                    _customernameController,
                                    labelText: "Customer Name",
                                    prefixIcon: SizedBox(width: 80),
                                    borderColor: AppColor.colYellow.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 80,
                                    child: CoverTextField(
                                      boxColor:
                                          selectedPriorityId == 1
                                              ? const Color.fromARGB(
                                                255,
                                                166,
                                                215,
                                                255,
                                              )
                                              : selectedPriorityId == 2
                                              ? const Color.fromARGB(
                                                255,
                                                252,
                                                240,
                                                136,
                                              )
                                              : const Color.fromARGB(
                                                255,
                                                250,
                                                126,
                                                117,
                                              ),
                                      widget: DropdownButton<int>(
                                        underline: Container(),
                                        value: selectedPriorityId,
                                        items:
                                            priorityDataList.map((data) {
                                              return DropdownMenuItem<int>(
                                                value: data['id'],
                                                child: Text(
                                                  data['name'],
                                                  style: textStyles
                                                      .sarifProText(
                                                        16,
                                                        FontWeight.w500,
                                                        AppColor.black,
                                                      ),
                                                ),
                                              );
                                            }).toList(),
                                        icon: const SizedBox(),
                                        isExpanded: false,
                                        onChanged: (selectedId) {
                                          setState(() {
                                            selectedPriorityId = selectedId!;
                                            // Call function to make API request
                                          });
                                        },
                                      ),
                                      borderColor: Color(0xffA9AD4B),
                                    ),
                                  ),
                                ],
                              ),
                              commonTextField(
                                _mobileController,
                                labelText: "Mobile No.",
                                keyboardType: TextInputType.number,
                                borderColor: AppColor.colYellow.withValues(
                                  alpha: 1,
                                ),
                              ),
                              commonTextField(
                                _alternativemobileController,
                                labelText: "Alternative No.",
                                keyboardType: TextInputType.number,
                              ),
                              CoverTextField(
                                widget: SearchField(
                                  searchInputDecoration: SearchInputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                      top: 28,
                                      left: 15,
                                      right: 10,
                                    ),
                                    hintStyle: textStyles.sarifProText(
                                      15,
                                      FontWeight.w500,
                                      AppColor.grey,
                                    ),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  hint: 'Select State',
                                  maxSuggestionBoxHeight: 200,
                                  onSuggestionTap: (
                                    SearchFieldListItem<String> item,
                                  ) {
                                    setState(() {
                                      selectedState = item;
                                      citiesSuggestions =
                                          stateCities[item.searchKey] ?? [];
                                      selectedCity =
                                          null; // Reset state when country changes
                                    });
                                  },
                                  selectedValue: selectedState,
                                  suggestions:
                                      statesSuggestions.map((x) {
                                        return SearchFieldListItem<String>(
                                          x,
                                          item: x,
                                        );
                                      }).toList(),
                                  suggestionState: Suggestion.expand,
                                ),
                              ),
                              // State SearchField
                              CoverTextField(
                                widget: SearchField(
                                  hint: 'Select City',
                                  maxSuggestionBoxHeight: 200,
                                  searchInputDecoration: SearchInputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                      top: 28,
                                      left: 15,
                                      right: 10,
                                    ),
                                    hintStyle: textStyles.sarifProText(
                                      15,
                                      FontWeight.w500,
                                      AppColor.grey,
                                    ),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),

                                  onSuggestionTap: (
                                    SearchFieldListItem<String> item,
                                  ) {
                                    setState(() {
                                      selectedCity = item;
                                    });
                                  },
                                  selectedValue: selectedCity,
                                  suggestions:
                                      citiesSuggestions.map((x) {
                                        return SearchFieldListItem<String>(
                                          x,
                                          item: x,
                                        );
                                      }).toList(),
                                  suggestionState: Suggestion.expand,
                                ),
                              ),
                              commonTextField(
                                _addressController,
                                labelText: "Address",
                              ),
                            ],
                            context: context,
                          ),
                          SizedBox(height: Sizes.height * .06),
                          Row(
                            children: [
                              Text(
                                "Software Details ",
                                style: textStyles.adlamText(
                                  18,
                                  FontWeight.w400,
                                  AppColor.black,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Sizes.height * .02),
                          addMasterOutside(
                            children: [
                              CoverTextField(
                                widget: DropdownButton<int>(
                                  underline: Container(),
                                  value: selectedProductId,
                                  items:
                                      productList.map((data) {
                                        return DropdownMenuItem<int>(
                                          value: data['id'],
                                          child: Text(
                                            data['name'],
                                            style: textStyles.sarifProText(
                                              16,
                                              FontWeight.w500,
                                              AppColor.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                  ),
                                  isExpanded: true,
                                  onChanged: (selectedId) {
                                    setState(() {
                                      selectedProductId = selectedId!;
                                    });
                                  },
                                ),
                              ),
                              CoverTextField(
                                widget: DropdownButton<int>(
                                  underline: Container(),
                                  value: selectedvarientId,
                                  items:
                                      varientList.map((data) {
                                        return DropdownMenuItem<int>(
                                          value: data['id'],
                                          child: Text(
                                            data['name'],
                                            style: textStyles.sarifProText(
                                              16,
                                              FontWeight.w500,
                                              AppColor.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                  ),
                                  isExpanded: true,
                                  onChanged: (selectedId) {
                                    setState(() {
                                      selectedvarientId = selectedId!;
                                    });
                                  },
                                ),
                              ),

                              commonTextField(
                                _specialRemarkController,
                                labelText: "Software Price",
                              ),
                              CoverTextField(
                                widget: InkWell(
                                  onTap: () async {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2200),
                                    ).then((selectedDate) {
                                      if (selectedDate != null) {
                                        appointmentDatePickar.text = DateFormat(
                                          'yyyy/MM/dd',
                                        ).format(selectedDate);
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        appointmentDatePickar.text,
                                        style: textStyles.sarifProText(
                                          16,
                                          FontWeight.w500,
                                          AppColor.primarydark,
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit_calendar,
                                        color: AppColor.primarydark,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              commonTextField(
                                _lastRemarkController,
                                labelText: "Remark",
                                borderColor: AppColor.colYellow.withValues(
                                  alpha: 1,
                                ),
                              ),
                              CoverTextField(
                                widget: DropdownButton<int>(
                                  underline: Container(),
                                  value: selectedDemoId,
                                  items:
                                      demoDataList.map((data) {
                                        return DropdownMenuItem<int>(
                                          value: data['id'],
                                          child: Text(
                                            data['name'],
                                            style: textStyles.sarifProText(
                                              16,
                                              FontWeight.w500,
                                              AppColor.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  isExpanded: true,
                                  onChanged: (selectedId) {
                                    setState(() {
                                      selectedDemoId = selectedId!;
                                      // Call function to make API request
                                    });
                                  },
                                ),
                              ),
                            ],
                            context: context,
                          ),
                          SizedBox(height: Sizes.height * .02),
                          DefaultButton(
                            text: "Save",
                            hight: 50,
                            width: 170,
                            buttonColor: Color(0xff55B1F7),
                            onTap: () {
                              if (_customernameController.text.trim().isEmpty) {
                                showCustomSnackbar(
                                  context,
                                  'Please enter customer name',
                                );
                              } else if (_mobileController.text.isEmpty) {
                                showCustomSnackbar(
                                  context,
                                  'Please enter mobile number',
                                );
                              } else if (_lastRemarkController.text.isEmpty) {
                                showCustomSnackbar(
                                  context,
                                  'Please enter remark',
                                );
                              } else {
                                setState(() {
                                  isLoadingProspect = true;
                                });
                                postProspect();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  Future<void> staffData() async {
    final url = Uri.parse(
      'http://lms.muepetro.com/api/UserController1/GetStaffDetailsLocationwise?locationid=${Preference.getString(PrefKeys.locationId)}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Staffmodel> staffmodelList = staffmodelFromJson(
          response.body,
        );
        salesmanList.clear();
        for (var item in staffmodelList) {
          salesmanList.add({'id': item.id, 'name': item.staffName});
        }
        setState(() {});
      }
    } catch (e) {}
  }

  Future<void> varientData() async {
    await fetchDataByMiscTypeId(17, varientList);
  }

  Future<void> productData() async {
    await fetchDataByMiscTypeId(18, productList);
  }

  Future postProspect() async {
    var response = await ApiService.postData(
      'CRM/PostProspect?locationId=${Preference.getString(PrefKeys.locationId)}',
      {
        "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
        "Prefix_Name": "online",
        "Ref_No": int.parse(refController.text.toString()),
        "Ref_Date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
        "Ref_Time": "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
        "Title_id": 101,
        "Gender_Name": "Not Set Yet",
        "Customer_Name": _customernameController.text.toString(),
        "Contact_Name": "Not Set Yet",
        "SanOff_Name": "Not Set Yet",
        "Address_Details": _addressController.text.toString(),
        "City_Id": "Not Set Yet",
        "City": selectedCity?.item ?? "",
        "Pin_Code": "Not Set Yet",
        "Mob_No": _mobileController.text.toString(),
        "Phon_No": _alternativemobileController.text.toString(),
        "Std_Code": "Not Set Yet",
        "Fax_No": "Not Set Yet",
        "Email_Id": "Not Set Yet",
        "Birthday_Date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
        "Anniversary_Date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
        "Enq_Type": selectedProductId,
        "Mode_Type": "Not Set Yet",
        "Occupation": 0,
        "Income": "Not Set Yet",
        "EnqGenBy_Id": int.parse(Preference.getString(PrefKeys.staffId)),
        "SalesEx_id": int.parse(Preference.getString(PrefKeys.staffId)),
        "Source_Id": 0,
        "NoOfVisitor": "Not Set Yet",
        "Scheme": "Not Set Yet",
        "Priority": selectedPriorityId,
        "InterestIn": "Not Set Yet",
        "Model_Id": selectedProductId,
        "Colour_Id": selectedvarientId,
        "Remark_interest": "Not Set Yet",
        "ModelTest_Id": selectedDemoId,
        "ModelTest_Date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
        "Remark_ModelTest": "Not Set Yet",
        "Appointment_Date": appointmentDatePickar.text,
        "Appointment_Time": "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
        "Remark_Appointment": _lastRemarkController.text.toString(),
        "Remark_Special": _specialRemarkController.text.toString(),
        "CurrentAppointmentDate": appointmentDatePickar.text,
        "EnquiryStatus": 105,
        "Last_Remark": _lastRemarkController.text.toString(),
        "LastContact_Date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
        "a": selectedState?.item ?? "",
        "b": '',
        'c': "",
      },
    );
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "somedata");
      isLoadingProspect = false;
    } else {
      setState(() {
        isLoadingProspect = false;
      });

      showCustomSnackbar(context, response['message']);
    }
  }

  Future<dynamic> getautoRefNumber() async {
    int response = await ApiService.fetchData(
      'UserController1/GetInvoiceNo?Tblname=Prospect&Fldname=Ref_No&transdatefld=Ref_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27Online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}',
    );
    refController = TextEditingController(text: '$response');
  }
}
