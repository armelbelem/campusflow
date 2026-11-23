// API simulée de CampusFlow avec connexion par jeton (séance 7).
// json-server fournit le CRUD REST ; ce fichier ajoute un faux /login et
// refuse toute requête sans jeton valide (réponse 401).
const path = require('path');
const crypto = require('crypto');
const jsonServer = require('json-server');

const PORT = Number(process.env.PORT) || 3000;
const MOT_DE_PASSE_DEMO = 'campus2026'; // compte de démonstration uniquement
const DUREE_JETON_MS = 2 * 60 * 60 * 1000; // un jeton expire après 2 heures

const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const jetons = new Map(); // jeton -> { utilisateurId, expire }

server.use(jsonServer.defaults()); // CORS, journal des requêtes
server.use(jsonServer.bodyParser);

server.post('/login', (req, res) => {
  const { email, motDePasse } = req.body || {};
  const utilisateur = router.db.get('utilisateurs').find({ email }).value();
  if (!utilisateur || motDePasse !== MOT_DE_PASSE_DEMO) {
    return res.status(401).json({ message: 'E-mail ou mot de passe incorrect.' });
  }
  const jeton = crypto.randomBytes(24).toString('hex');
  jetons.set(jeton, { utilisateurId: utilisateur.id, expire: Date.now() + DUREE_JETON_MS });
  res.json({ jeton, utilisateur });
});

// Toutes les autres routes exigent « Authorization: Bearer <jeton> ».
server.use((req, res, next) => {
  const [type, jeton] = (req.headers.authorization || '').split(' ');
  const session = type === 'Bearer' ? jetons.get(jeton) : undefined;
  if (!session || session.expire < Date.now()) {
    if (session) jetons.delete(jeton);
    return res.status(401).json({ message: 'Jeton absent ou expiré.' });
  }
  next();
});

server.use(router);

server.listen(PORT, '0.0.0.0', () => {
  console.log(`API CampusFlow avec connexion : http://localhost:${PORT}`);
  console.log('Compte de démo : ibrahim.sawadogo@campus.bf / campus2026');
});
