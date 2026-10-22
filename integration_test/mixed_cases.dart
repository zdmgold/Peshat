// Realistic mixed-language cases: [kind, foreign language, text].
// kind: E = English with a short foreign phrase, F = foreign sentence with
// English words, B = balanced.
// kind: E = English with a short foreign phrase, F = foreign sentence with
// English words, B = balanced. [kind, foreign code, text]
const List<List<String>> kMixedBase = <List<String>>[
  ['E', 'hi', 'She replied नमस्ते with a smile and walked into the room.'],
  ['E', 'hi', 'The shop sign says दुकान बंद है today, so we went home.'],
  ['E', 'zh', 'The sign at the entrance says 早上好 which means good morning.'],
  ['E', 'zh', 'Please ask for 麻婆豆腐 when you order at the restaurant.'],
  ['E', 'ja', 'The menu lists ラーメン and 餃子 for lunch today.'],
  ['E', 'ja', 'I learned the word ありがとう from my Japanese teacher yesterday.'],
  ['E', 'ko', 'My friend said 안녕하세요 when we met at the station.'],
  ['E', 'ru', 'My Russian friend always says Привет when he calls me.'],
  ['E', 'ar', 'He greeted us with مرحبا and offered some tea.'],
  ['E', 'th', 'The waiter said สวัสดี and showed us to the table.'],
  ['F', 'hi', 'आज मैं office जा रहा हूँ और मेरी meeting दस बजे है।'],
  ['F', 'hi', 'मुझे यह phone बहुत पसंद है, battery भी अच्छी है।'],
  ['F', 'hi', 'कृपया WiFi password reception से पूछें।'],
  ['F', 'ru', 'Я вчера купил новый iPhone в магазине.'],
  ['F', 'ru', 'Пожалуйста, введите ваш password и email.'],
  ['F', 'ja', '今日は午後三時からMeetingがあります。'],
  ['F', 'ja', 'このレストランのWiFiパスワードを教えてください。'],
  ['F', 'zh', '我喜欢用iPhone拍照，也常用WeChat聊天。'],
  ['F', 'zh', '请在前台询问WiFi密码。'],
  ['F', 'ko', '오늘 오후에 meeting이 있어요.'],
  ['F', 'ar', 'اشتريت iPhone جديد أمس من المتجر.'],
  ['F', 'th', 'วันนี้ฉันมี meeting ตอนบ่ายสามโมง'],
  ['F', 'bn', 'আমি আজ office যাচ্ছি এবং meeting আছে।'],
  ['B', 'hi', 'Hello दोस्त, how are you? आज मौसम अच्छा है।'],
  ['B', 'ja', 'Hello 友達、元気ですか? How are you today?'],
  ['B', 'zh', 'Good morning 朋友，你今天好吗? See you soon.'],
  ['B', 'ru', 'Hello друг, как дела? I hope you are fine.'],
];


const List<List<String>> kMixedExtra = <List<String>>[
  ['E', 'hi', 'Welcome to the City Library\nनगर पुस्तकालय में आपका स्वागत है'],
  ['E', 'ja', 'Ramen ラーメン900\nGyoza 餃子 500\nBeer ビール600'],
  ['E', 'ko', 'Coffee 커피 3,000\nTea 차 2,500'],
  ['E', 'zh', 'Please ask for 麻婆豆腐 when you\norder at the restaurant. It is\nthe best dish on the menu.'],
  ['E', 'hi', 'The hotel staff greeted every guest with\na warm नमस्ते and a glass of fresh juice\nbefore showing them to their rooms.'],
  ['F', 'hi', 'आज office बंद है और meeting कल है।'],
  ['F', 'zh', '请在前台询问WiFi密码'],
  ['B', 'hi', 'Hello दोस्त, how are you? I hope you are doing well today. आज मौसम अच्छा है।'],
  ['B', 'hi', 'The sale starts today. सभी वस्तुओं पर 50% छूट। Come early.'],
  ['B', 'zh', 'Order #4521: 麻婆豆腐 x2, 宫保鸡丁 x1, rice x3, tea x2'],
  ['B', 'hi', 'Room 204 कमरा नंबर 204 है'],
  ['B', 'ru', 'Exit — Выход. Please keep the door closed.'],
  ['B', 'ar', 'Welcome مرحبا بكم في فندقنا'],
  ['B', 'ko', 'Thank you 감사합니다 for visiting us'],
  ['B', 'th', 'Thank you ขอบคุณ for visiting'],
];

final List<List<String>> kMixed = <List<String>>[...kMixedBase, ...kMixedExtra];
