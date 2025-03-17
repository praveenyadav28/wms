import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class AddStaffWidget extends StatefulWidget {
  AddStaffWidget({super.key, required this.isFirst, required this.id});
  bool isFirst;
  int? id;
  @override
  State<AddStaffWidget> createState() => _AddStaffWidgetState();
}

class _AddStaffWidgetState extends State<AddStaffWidget> {
  final TextEditingController _staffnamecontroller = TextEditingController();
  final TextEditingController _fathernamecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _pinCodecontroller = TextEditingController();
  final TextEditingController _mobilecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();

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

  //Degination
  List<Map<String, dynamic>> deginationList = [];
  int? deginationId;

  //Department
  List<Map<String, dynamic>> departmentList = [];
  int? departmentId;

  //  Date
  TextEditingController joiningDatePickar = TextEditingController(
    text: DateFormat('M/d/yyyy').format(DateTime.now()),
  );
  TextEditingController leaveDatePickar = TextEditingController(
    text: DateFormat('M/d/yyyy').format(DateTime.now()),
  );

  bool isload = false;
  bool _isDeactive = false;

  @override
  void initState() {
    statesSuggestions = stateCities.keys.toList();
    citiesSuggestions = [];

    selectedState = null;
    selectedCity = null;
    deginationData().then((value) {
      deginationId = deginationList.isEmpty ? null : deginationList[0]['id'];
      if (widget.isFirst != true) {
        getstaffDetails().then((value) => setState(() {}));
      }
    });
    departmentData().then((value) {
      departmentId = departmentList[0]['id'];
      setState(() {});
    });

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02,
            horizontal:
                (Responsive.isMobile(context))
                    ? Sizes.width * .03
                    : Sizes.width * 0.13,
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
                      "Staff Details ",
                      style: textStyles.adlamText(
                        18,
                        FontWeight.w400,
                        AppColor.black,
                      ),
                    ),
                    Expanded(
                      child: Container(height: 1, color: AppColor.black),
                    ),
                  ],
                ),
                SizedBox(height: Sizes.height * .02),

                addMasterOutside(
                  context: context,
                  children: [
                    commonTextField(
                      _staffnamecontroller,
                      labelText: "Staff Name*",
                      validator: (value) {
                        if (value!.isEmpty &&
                            _staffnamecontroller.text.trim().isEmpty) {
                          return "Please enter staff name";
                        }
                        return null;
                      },
                    ),
                    commonTextField(
                      _fathernamecontroller,
                      labelText: 'Father Name',
                    ),

                    commonTextField(
                      _mobilecontroller,
                      labelText: 'Mobile No.',
                      keyboardType: TextInputType.number,
                    ),

                    commonTextField(
                      _pinCodecontroller,
                      labelText: 'Pin code',
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
                        onSuggestionTap: (SearchFieldListItem<String> item) {
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
                              return SearchFieldListItem<String>(x, item: x);
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

                        onSuggestionTap: (SearchFieldListItem<String> item) {
                          setState(() {
                            selectedCity = item;
                          });
                        },
                        selectedValue: selectedCity,
                        suggestions:
                            citiesSuggestions.map((x) {
                              return SearchFieldListItem<String>(x, item: x);
                            }).toList(),
                        suggestionState: Suggestion.expand,
                      ),
                    ),
                    commonTextField(_addresscontroller, labelText: 'Address'),
                    CoverTextField(
                      widget: defaultDropDown(
                        value:
                            departmentList.isEmpty
                                ? null
                                : departmentList.firstWhere(
                                  (item) => item['id'] == departmentId,
                                ),
                        items:
                            departmentList.map((data) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: data,
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
                        onChanged: (selectedId) {
                          setState(() {
                            departmentId = selectedId!['id'];
                            // Call function to make API request
                          });
                        },
                      ),
                    ),
                    CoverTextField(
                      widget: defaultDropDown(
                        value:
                            deginationList.isEmpty
                                ? null
                                : deginationList.firstWhere(
                                  (item) => item['id'] == deginationId,
                                ),
                        items:
                            deginationList.map((data) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: data,
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
                        onChanged: (selectedId) {
                          setState(() {
                            deginationId = selectedId!['id'];
                            // Call function to make API request
                          });
                        },
                      ),
                    ),
                    commonTextField(
                      _passwordcontroller,
                      labelText: 'Create Password*',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Password";
                        } else if (_passwordcontroller.text.length < 6) {
                          return "Please enter minumum 6 digit";
                        }
                        return null;
                      },
                    ),
                    CoverTextField(
                      widget: InkWell(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2500),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              joiningDatePickar.text = DateFormat(
                                'M/d/yyyy',
                              ).format(selectedDate);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              joiningDatePickar.text,
                              style: textStyles.sarifProText(
                                16,
                                FontWeight.w500,
                                AppColor.black,
                              ),
                            ),
                            Icon(Icons.edit_calendar, color: AppColor.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Sizes.height * .02),
                (Responsive.isMobile(context))
                    ? Column(
                      children: [
                        !widget.isFirst
                            ? addMasterOutside(
                              context: context,
                              children: [
                                Center(
                                  child: CheckboxListTile(
                                    title: const Text('Deactivate Staff ID'),
                                    value: _isDeactive,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isDeactive = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                            : Container(),
                        _isDeactive && !widget.isFirst
                            ? addMasterOutside(
                              context: context,
                              children: [
                                CoverTextField(
                                  widget: InkWell(
                                    onTap: () async {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(FocusNode());
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2500),
                                      ).then((selectedDate) {
                                        if (selectedDate != null) {
                                          leaveDatePickar.text = DateFormat(
                                            'M/d/yyyy',
                                          ).format(selectedDate);
                                        }
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          leaveDatePickar.text,
                                          style: textStyles.sarifProText(
                                            16,
                                            FontWeight.w500,
                                            AppColor.black,
                                          ),
                                        ),
                                        Icon(
                                          Icons.edit_calendar,
                                          color: AppColor.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Container(),
                      ],
                    )
                    : !widget.isFirst
                    ? addMasterOutside(
                      context: context,
                      children: [
                        Center(
                          child: CheckboxListTile(
                            title: const Text('Deactivate Staff ID'),
                            value: _isDeactive,
                            onChanged: (bool? value) {
                              setState(() {
                                _isDeactive = value!;
                              });
                            },
                          ),
                        ),
                        _isDeactive && !widget.isFirst
                            ? CoverTextField(
                              widget: InkWell(
                                onTap: () async {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(FocusNode());
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2500),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      leaveDatePickar.text = DateFormat(
                                        'M/d/yyyy',
                                      ).format(selectedDate);
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      leaveDatePickar.text,
                                      style: textStyles.sarifProText(
                                        16,
                                        FontWeight.w500,
                                        AppColor.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit_calendar,
                                      color: AppColor.black,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : Container(),
                      ],
                    )
                    : Container(),
                SizedBox(height: Sizes.height * 0.02),
                isload == true
                    ? const CircularProgressIndicator()
                    : DefaultButton(
                      hight: 45,
                      width: 250,
                      text: widget.isFirst ? 'Save' : "Update",

                      onTap: () {
                        if (_staffnamecontroller.text.isEmpty ||
                            _passwordcontroller.text.isEmpty) {
                          showCustomSnackbar(
                            context,
                            "Please fill staff name and password",
                          );
                        } else if (deginationId == null &&
                            departmentId == null) {
                          showCustomSnackbar(
                            context,
                            "Please select Degination and Department",
                          );
                        } else {
                          addstaffApi();
                        }
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deginationData() async {
    await fetchDataByMiscTypeId(28, deginationList);
  }

  Future<void> departmentData() async {
    await fetchDataByMiscTypeId(27, departmentList);
  }

  Future addstaffApi() async {
    try {
      Map<String, dynamic> response = await ApiService.postData(
        widget.isFirst
            ? "UserController1/PostStaff"
            : "UserController1/UpdateStaff?Id=${widget.id}",
        {
          "Title_Id": 101,
          "Staff_Name": _staffnamecontroller.text.toString(),
          "Son_Off": _fathernamecontroller.text.toString(),
          "Address": _addresscontroller.text.toString(),
          "Address2": "Not Set Yet",
          "City_Id": "0",
          "City_Name": selectedCity?.item ?? "",
          "District_Name": selectedCity?.item ?? "",
          "State_Name": selectedState?.item ?? "",
          "Pin_Code": _pinCodecontroller.text.toString(),
          "Std_Code": "Not Set Yet",
          "Mob": _mobilecontroller.text.toString(),
          "Staff_Degination_Id": deginationId,
          "Staff_Department_Id": departmentId,
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "Joining_Date": joiningDatePickar.text.toString(),
          "Left_Date": "Not Set Yet",
          "UserName": _staffnamecontroller.text.toString(),
          "Password": _passwordcontroller.text.toString(),
          "UserType": "staff",
          "UserValid": "Not Set Yet",
        },
      );
      if (response['result'] != null && response['message'] != null) {
        bool result = response['result'];
        String message = response['message'];
        if (result) {
          Navigator.pop(context);
          showCustomSnackbarSuccess(context, message);
        } else {
          showCustomSnackbar(context, message);
        }
      } else {}
    } catch (e) {}
  }

  //get staff details
  Future getstaffDetails() async {
    var response = await ApiService.fetchData(
      "UserController1/GetStaffDetailsByStaffId?StaffId=${widget.id}",
    );
    _staffnamecontroller.text = response["staff_Name"];
    _fathernamecontroller.text = response['son_Off'];
    _addresscontroller.text = response['address'];
    _pinCodecontroller.text = response['pin_Code'];
    _mobilecontroller.text = response['mob'];
    joiningDatePickar.text = response['joining_Date'];
    _passwordcontroller.text = response['password'];
    // selectedState?.item = response['state_Name'];
    // selectedCity?.item = response['city_Name'];
    deginationId = response['staff_Degination_Id'];
    departmentId = response['staff_Department_Id'];
  }
}
