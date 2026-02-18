const express = require('express');
const { listUsers, saveUser, deactivateUser } = require('../controllers/users.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const roleMiddleware = require('../middlewares/role.middleware');

const router = express.Router();

router.use(authMiddleware);
router.get('/', roleMiddleware('ADMIN'), listUsers);
router.post('/', roleMiddleware('ADMIN'), saveUser);
router.delete('/:id', roleMiddleware('ADMIN'), deactivateUser);

module.exports = router;
